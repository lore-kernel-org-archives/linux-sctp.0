From: Joshua Kinard <kumba@gentoo.org>
Date: Wed, 16 Apr 2014 17:35:39 +0000
Subject: Re: [PATCH]: NULL pointer dereference in sctp_auth_asoc_set_default_hmac
Message-Id: <534EBF6B.6070804@gentoo.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <534E0C7A.9070309@gentoo.org>
In-Reply-To: <534E0C7A.9070309@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 04/16/2014 03:58, Daniel Borkmann wrote:
> Hi Joshua,
>=20
> On 04/16/2014 06:52 AM, Joshua Kinard wrote:
>> Hi linux-sctp,
>>
>> I stumbled into a NULL pointer dereference on amd64 and mips when receiv=
ing
>> an INIT chunk containing the HMAC Algorithm Parameter (0x8004) when
>> net.sctp.auth_enable =3D 1.
>>
>>  From some quick debugging I did, even if net.sctp.auth_enable =3D 1, th=
e if
>> statement on line 448 in net/sctp/auth.c::sctp_auth_init_hmacs() checks
>> net->sctp.auth_enable and gets '0' back, which causes ep->auth_hmacs to =
get
>> set to NULL:
>>
>> 448         if (!net->sctp.auth_enable) {
>> 449                 ep->auth_hmacs =3D NULL;
>> 450                 return 0;
>> 451         }
>>
>>
>> Later, the if statement on line 621 in
>> net/sctp/auth.c::sctp_auth_asoc_set_default_hmac() attempts to access
>> ep->auth_hmacs without first checking for NULL, which triggers the oops:
>=20
> I presume at this point, it's net->sctp.auth_enable =3D 1 as we test for
> it here before calling sctp_auth_asoc_set_default_hmac():
>=20
>     case SCTP_PARAM_HMAC_ALGO:
>         if (!net->sctp.auth_enable)
>             goto fall_through;
>=20
> Could it be that upon sctp_endpoint_init() time in your case,
> sctp.auth_enable was still reset to 0, but you've set it between
> sctp_endpoint_init() time and before invocation of
> sctp_auth_asoc_set_default_hmac() to 1, so that this code path
> will suddenly be taken, causing the NULL ptr deref?
>=20

I am not real certain.  I am not setting net.sctp.auth_enable in any code,
but literally executing "sysctl -w net.sctp.auth_enable=3D1" on the command
line, then switching to another box's shell in a different window and then
attempting an "ssh -z ..." connection (-z is the arg the SCTP patch adds to
force the SCTP protocol).  That is what triggers the oops.  So that sysctl
flag should be set to 1 long before I even switch windows.

As long as net.sctp.auth_enable=3D0 when I ssh over SCTP, the oops doesn't
trigger.  I am not ruling out a bug in the ssh SCTP patch either, as it
could malform the packet in a subtle way.  WireShark reports nothing wrong,
however.


>> 620                 /* If this TFM has been allocated, use this id */
>> 621                 if (ep->auth_hmacs[id]) {
>> 622                         asoc->default_hmac_id =3D id;
>> 623                         break;
>> 624                 }
>>
>>
>> I am not sure why net->sctp.auth_enable is initially returning '0' when =
it's
>> set in sysctl, and verified in /proc/sys/net/sctp/auth_enable.  Adding a
>> check for NULL on ep->auth_hmacs in the if statement stops the oops from
>> happening, though I am not sure if this is the correct fix.
> ...
>> Another thing I noticed, is that I cannot trigger the Oops from the
>> SCTP/DTLS samples on this page:
>> http://sctp.fh-muenster.de/dtls-samples.html
>>
>> But if I patch OpenSSH with the SCTP patch below, that does trigger it on
>> the sshd server machine as soon as I issue 'ssh -z user@host ...'.  I've
>> looked at both INIT chunks sent out by the respective programs in Wiresh=
ark,
>> but nothing stands out.
>=20
> Same symptoms?
>=20
> Do you have a test pcap though?
>=20

I have a PCAP file from both cases, but I haven't tried injecting that
specific packet into the NIC of the affected machine to see if that will
trigger the oops.  I'll install tcpreplay on it and see if that does trigger
the same issue for the ssh session.

Here's the Oops report off of my MIPS box.  It's the same as on the AMD64
machine, I just couldn't get a clean serial capture off the console port th=
ere:

Oops[#1]:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.1-mipsgit-20140415 #1
task: ffffffff8056ce80 ti: ffffffff8055c000 task.ti: ffffffff8055c000
$ 0   : 0000000000000000 ffffffff9401fce0 0000000000000001 0000000000000001
$ 4   : 980000005fbd6020 980000005534a0b4 0000000000000008 0000000000000001
$ 8   : 980000005fb97ca0 0000000000000000 0000000000000001 e467ef67cb335f9d
$12   : 00000000000000c1 000000000000000f 0000000000000000 ffffffffa3ab0e7f
$16   : 980000005534a064 0000000000000020 0000000000000001 980000005f6680e0
$20   : 980000005f668180 980000005534a0b4 980000005fbd6020 980000005f668180
$24   : 0000000000000004 ffffffff8043dac4
$28   : ffffffff8055c000 ffffffff8055f7b0 00000000000f4240 ffffffff8042b300
Hi    : 0000000000000002
Lo    : 0000000000000000
epc   : ffffffff8043c4e8 sctp_auth_asoc_set_default_hmac+0x68/0x80
    Not tainted
ra    : ffffffff8042b300 sctp_process_init+0x5e0/0x8a4
Status: 9401fce3        KX SX UX KERNEL EXL IE
Cause : 00000008
BadVA : 0000000000000008
PrId  : 00002733 (RM7000)
Process swapper (pid: 0, threadinfo=FFffffff8055c000, task=FFffffff8056ce80,
tls=0000000000000000)
Stack : 980000005fbd6080 ffffffff8043107c 980000005fbd6080 980000005fbd6080
          980000005fb97d00 980000005dc14060 980000005fb97d08 ffffffff80431a=
14
          ffffffff80592ea0 980000005fb97ca0 980000005f6680e0 ffffffff8055f8=
a0
          980000005fbd6020 980000005fb97ca0 0000000000000000 980000005fb97c=
a0
          ffffffff8043b970 0000000000000020 ffffffff8049d030 ffffffff804218=
8c
          ffffffff8050ec58 0000000000000000 0000000100000000 00000000000000=
00
          0000000000000001 0000000000000000 ffffffff80592ea0 00000000000000=
00
          980000005f6680e0 ffffffff804228c8 0000000000000000 00000000000000=
00
          0000000000000000 0000000000000000 0000000000000000 00000000000000=
00
          0000000000000000 0000000000000000 0000000000000000 00000000000000=
00
          ...
Call Trace:
[<ffffffff8043c4e8>] sctp_auth_asoc_set_default_hmac+0x68/0x80
[<ffffffff8042b300>] sctp_process_init+0x5e0/0x8a4
[<ffffffff8042188c>] sctp_sf_do_5_1B_init+0x234/0x34c
[<ffffffff804228c8>] sctp_do_sm+0xb4/0x1e8
[<ffffffff80425a08>] sctp_endpoint_bh_rcv+0x1c4/0x214
[<ffffffff8043af68>] sctp_rcv+0x588/0x630
[<ffffffff8043e8e8>] sctp6_rcv+0x10/0x24
[<ffffffff803acb50>] ip6_input+0x2c0/0x440
[<ffffffff8030fc00>] __netif_receive_skb_core+0x4a8/0x564
[<ffffffff80310650>] process_backlog+0xb4/0x18c
[<ffffffff80313cbc>] net_rx_action+0x12c/0x210
[<ffffffff80034254>] __do_softirq+0x17c/0x2ac
[<ffffffff800345e0>] irq_exit+0x54/0xb0
[<ffffffff800075a4>] ret_from_irq+0x0/0x4
[<ffffffff800090ec>] rm7k_wait_irqoff+0x24/0x48
[<ffffffff8005e388>] cpu_startup_entry+0xc0/0x148
[<ffffffff805a88b0>] start_kernel+0x37c/0x398


Code: dd0900b8  000330f8  0126302d <dcc60000> 50c0fff1  0047182a  a48306a0
03e00008  00000000
---[ end trace b530b0551467f2fd ]---
Kernel panic - not syncing: Fatal exception in interrupt


--=20
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And
our lives slip away, moment by moment, lost in that vast, terrible in-betwe=
en."

--Emperor Turhan, Centauri Republic
