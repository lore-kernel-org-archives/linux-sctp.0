From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 15 Dec 2008 15:38:56 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <49467A10.8030802@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Karsten Keil wrote:
> Hi Vlad,
>=20
> On Thu, Dec 11, 2008 at 10:28:35AM -0500, Vlad Yasevich wrote:
>> Michal Hocko wrote:
>>> Hi Vlad,
>>>
>>> I am starting this new thread because I am starting to believe that
>>> sles10sp2 kernel (based on 2.6.16 upstream kernel) experiences different
>>> issue than we can see in the upstream kernel (see bellow).
>>>
>>> Karsten (CCing him) has found out following:
>>> "
>>> OK I think the
>>> KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc)) failed at
>>> net/ipv4/af_inet.c (149)
>>>
>>> is related to the main problem here, it says that on the time a socket
>>> get destroyed here is still some wmem allocated. This mean here is still
>>> a transmit skb on the fly. Since sctp use skb destructors to do the
>>> memory accounting, this also means that after destroying the socket, the
>>> destructor of this skb will access the already freed socket struct,
>>> which will let in some cases (if the memory is in use again and the
>>> pointers are already overwritten) cause the crash with on
>>> {sock_wfree+48} (which is a call to sk->sk_write_space(sk);).  Of course
>>> it can crash in every other place, since the accounting may overwrite
>>> pointers in any other struct, which reuse this memory.
>>>
>>> I instrument some routines with extra debug (eg. inet_sock_destruct) too
>>> see the amount of memory in sk->sk_wmem_alloc, it allmost show=20
>>>
>>> Dec 11 12:31:16 gw kernel: inet_sock_destruct:
>>> sk(ffff810116960e00)->sk_wmem_alloc 496
>>> Dec 11 12:31:17 gw kernel: inet_sock_destruct:
>>> sk(ffff8101144f1b00)->sk_wmem_alloc 496
>>> Dec 11 12:31:18 gw kernel: inet_sock_destruct:
>>> sk(ffff8101144f1b00)->sk_wmem_alloc -496
>>> Dec 11 12:31:20 gw kernel: inet_sock_destruct:
>>> sk(ffff81011d461a00)->sk_wmem_alloc 496
>>> Dec 11 12:31:21 gw kernel: inet_sock_destruct:
>>> sk(ffff81011d460080)->sk_wmem_alloc 496
>>>
>>> Note the -496, I think this is a case in which the same memory was again
>>> allocated by a socket struct, so the memory still has valid pointers and
>>> so on the destructor call for the old socket it did decrement the memory
>>> on the new socket.
>>>
>>> Do you agree with this analysis ?
>>> "
>>>
>>> I am trying to go through git logs but maybe you remember some fix in
>>> this area.
>>>
>>> If I understand correctly, then 20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
>>> removes destructors from sctp completely, so the previous should not
>>> happen in upstream, shouldn't it?
>>>
>>
>> Here are a few commits that you need to check on:
>>
>> 61c9fed41638249f8b6ca5345064eb1beb50179f
>> [SCTP]: A better solution to fix therace between sctp_peeloff() and sctp=
_rcv().
>>
>> cfdeef3282705a4b872d3559c4e7d2561251363c
>> [SCTP]: Unhash the endpoint in sctp_endpoint_free().
>>
>> f26f7c480555812ca7c4037e0a50fa54afe2cb4a
>> [SCTP]: Add bind hash locking to the migrate code
>>
>>
>> All of the above commits address races in the SCTP code and are not in t=
he base
>> 2.6.16 kernel.
>>
>=20
> Thanks for your input.
>=20
> 61c9fed41638249f8b6ca5345064eb1beb50179f
> [SCTP]: A better solution to fix therace between sctp_peeloff() and sctp_=
rcv().
>=20
> seems to fix this issue, I applied also the other patches.
>=20
> Now I do not get any longer the "KERNEL: assertion
> (!atomic_read(&sk->sk_wmem_alloc)) failed ..." messages.
>=20
> But now I run into the skb_overflow BUG.
> With some extra debug (based on your debug patch) I see:
>=20
> Possible SKB overflow: packet size =3D 76, packet overhead =3D 32, packet=
 chunk =3D 1/4, chunk len =1040 packet padding 0 nskb len 12 mtu =3D 1500
>=20
> packet chunk =3D 1/4 read as first chunk of total 4 chunks cause the over=
flow.

OK.  It appears that the list of chunk on the packets is not cleaned up
correctly.  It could also be that in my prior debug patches I didn't reset
the number of chunks properly.

Since this is the same bug that I am trying to diagnose in 2.6.27+, it now
boils down to the same problem.  Either the packet is not cleaned up
correctly, or there is a race wrt packet chunk list.

I am currently somewhat off-line due to power issues at my house, but I'll
see if I can get a somewhat cleaned-up debug patch to you.

-vlad
>=20
> First I was thinking that maybe the padding cause this, so I also print t=
his
> value, but it is 0 in all traces.
>=20
> I also applied
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=B90a137d30a6322d76023d879d40fc31f3edf0a6
>=20
> which sound likely to fix such kind of problem, but it seems that we do n=
ot
> hit this, the bug is still here.
>=20
>=20

