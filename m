From: Karsten Keil <kkeil@suse.de>
Date: Fri, 12 Dec 2008 13:04:20 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <20081212130420.GA32467@pingi.kke.suse.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Vlad,

On Thu, Dec 11, 2008 at 10:28:35AM -0500, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > Hi Vlad,
> >=20
> > I am starting this new thread because I am starting to believe that
> > sles10sp2 kernel (based on 2.6.16 upstream kernel) experiences different
> > issue than we can see in the upstream kernel (see bellow).
> >=20
> > Karsten (CCing him) has found out following:
> > "
> > OK I think the
> > KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
> > net/ipv4/af_inet.c (149)
> >=20
> > is related to the main problem here, it says that on the time a socket
> > get destroyed here is still some wmem allocated. This mean here is still
> > a transmit skb on the fly. Since sctp use skb destructors to do the
> > memory accounting, this also means that after destroying the socket, the
> > destructor of this skb will access the already freed socket struct,
> > which will let in some cases (if the memory is in use again and the
> > pointers are already overwritten) cause the crash with on
> > {sock_wfree+48} (which is a call to sk->sk_write_space(sk);).  Of course
> > it can crash in every other place, since the accounting may overwrite
> > pointers in any other struct, which reuse this memory.
> >=20
> > I instrument some routines with extra debug (eg. inet_sock_destruct) too
> > see the amount of memory in sk->sk_wmem_alloc, it allmost show=20
> >=20
> > Dec 11 12:31:16 gw kernel: inet_sock_destruct:
> > sk(ffff810116960e00)->sk_wmem_alloc 496
> > Dec 11 12:31:17 gw kernel: inet_sock_destruct:
> > sk(ffff8101144f1b00)->sk_wmem_alloc 496
> > Dec 11 12:31:18 gw kernel: inet_sock_destruct:
> > sk(ffff8101144f1b00)->sk_wmem_alloc -496
> > Dec 11 12:31:20 gw kernel: inet_sock_destruct:
> > sk(ffff81011d461a00)->sk_wmem_alloc 496
> > Dec 11 12:31:21 gw kernel: inet_sock_destruct:
> > sk(ffff81011d460080)->sk_wmem_alloc 496
> >=20
> > Note the -496, I think this is a case in which the same memory was again
> > allocated by a socket struct, so the memory still has valid pointers and
> > so on the destructor call for the old socket it did decrement the memory
> > on the new socket.
> >=20
> > Do you agree with this analysis ?
> > "
> >=20
> > I am trying to go through git logs but maybe you remember some fix in
> > this area.
> >=20
> > If I understand correctly, then 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
> > removes destructors from sctp completely, so the previous should not
> > happen in upstream, shouldn't it?
> >=20
>=20
>=20
> Here are a few commits that you need to check on:
>=20
> 61c9fed41638249f8b6ca5345064eb1beb50179f
> [SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_=
rcv().
>=20
> cfdeef3282705a4b872d3559c4e7d2561251363c
> [SCTP]: Unhash the endpoint in sctp_endpoint_free().
>=20
> f26f7c480555812ca7c4037e0a50fa54afe2cb4a
> [SCTP]: Add bind hash locking to the migrate code
>=20
>=20
> All of the above commits address races in the SCTP code and are not in th=
e base
> 2.6.16 kernel.
>=20

Thanks for your input.

61c9fed41638249f8b6ca5345064eb1beb50179f
[SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_rc=
v().

seems to fix this issue, I applied also the other patches.

Now I do not get any longer the "KERNEL: assertion
(!atomic_read(&sk->sk_wmem_alloc)) failed ..." messages.

But now I run into the skb_overflow BUG.
With some extra debug (based on your debug patch) I see:

Possible SKB overflow: packet size =3D 76, packet overhead =3D 32, packet c=
hunk =3D 1/4, chunk len =1040 packet padding 0 nskb len 12 mtu =3D 1500

packet chunk =3D 1/4 read as first chunk of total 4 chunks cause the overfl=
ow.

First I was thinking that maybe the padding cause this, so I also print this
value, but it is 0 in all traces.

I also applied
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=B90a137d30a6322d76023d879d40fc31f3edf0a6

which sound likely to fix such kind of problem, but it seems that we do not
hit this, the bug is still here.


--=20
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB=
 16746 (AG Nuernberg)
