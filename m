From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 16 Apr 2014 20:30:33 +0000
Subject: Re: [PATCH]: NULL pointer dereference in sctp_auth_asoc_set_default_hmac
Message-Id: <534EE869.2010009@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <534E0C7A.9070309@gentoo.org>
In-Reply-To: <534E0C7A.9070309@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 04/16/2014 09:56 PM, Joshua Kinard wrote:
> On 04/16/2014 15:12, Vlad Yasevich wrote:
>> On 04/16/2014 12:52 AM, Joshua Kinard wrote:
>>> Hi linux-sctp,
>>>
>>> I stumbled into a NULL pointer dereference on amd64 and mips when recei=
ving
>>> an INIT chunk containing the HMAC Algorithm Parameter (0x8004) when
>>> net.sctp.auth_enable =3D 1.
>>>
>>>  From some quick debugging I did, even if net.sctp.auth_enable =3D 1, t=
he if
>>> statement on line 448 in net/sctp/auth.c::sctp_auth_init_hmacs() checks
>>> net->sctp.auth_enable and gets '0' back, which causes ep->auth_hmacs to=
 get
>>> set to NULL:
>>>
>>> 448         if (!net->sctp.auth_enable) {
>>> 449                 ep->auth_hmacs =3D NULL;
>>> 450                 return 0;
>>> 451         }
>>>
>>>
>>> Later, the if statement on line 621 in
>>> net/sctp/auth.c::sctp_auth_asoc_set_default_hmac() attempts to access
>>> ep->auth_hmacs without first checking for NULL, which triggers the oops:
>>>
>>> 620                 /* If this TFM has been allocated, use this id */
>>> 621                 if (ep->auth_hmacs[id]) {
>>> 622                         asoc->default_hmac_id =3D id;
>>> 623                         break;
>>> 624                 }
>>>
>>>
>>> I am not sure why net->sctp.auth_enable is initially returning '0' when=
 it's
>>> set in sysctl, and verified in /proc/sys/net/sctp/auth_enable.  Adding a
>>> check for NULL on ep->auth_hmacs in the if statement stops the oops from
>>> happening, though I am not sure if this is the correct fix.
>>>
>>> Another thing I noticed, is that I cannot trigger the Oops from the
>>> SCTP/DTLS samples on this page:
>>> http://sctp.fh-muenster.de/dtls-samples.html
>>>
>>> But if I patch OpenSSH with the SCTP patch below, that does trigger it =
on
>>> the sshd server machine as soon as I issue 'ssh -z user@host ...'.  I've
>>> looked at both INIT chunks sent out by the respective programs in Wires=
hark,
>>> but nothing stands out.
>>>
>>> OpenSSH SCTP:
>>> https://bugzilla.mindrot.org/show_bug.cgi?id 16
>>>
>>> If anyone's got other ideas to try out, let me know, thanks!
>>>
>>
>>
>> Which kernel are you running?  Does it have this commit in it?
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=EFb842c45e667332774196bd5a1d539d048159cc
>>
>> Without that, I could see how a bug might happen...
>>
>> -vlad
>
> For my MIPS machine (SGI O2), 3.14.1, built off of a linux-mips git pull.
> For the amd64 VM, 3.14 from Gentoo's sources.  I tested reversing that pa=
tch
> on one of my kernel trees, and it's reversible, so it's definitely includ=
ed.
>
> I haven't tried stepping through the kernel w/ kgdb yet.  The MIPS machine
> runs headless, and breaking into kdb to set a breakpoint, then resuming
> kills ssh some how (still responds to pings, but won't connect), and ttyS0
> gets stuck trying to talk to a remote gdb session.  The amd64 VM spikes my
> host system's CPU when it enters the debugger, so I can't run that for too
> long of a time.  I suppose I could enable telnet on the mips box and see =
if
> that's still usable after setting the breakpoint.
>
> If someone wants to try and reproduce it:
> 1. Compile OpenSSH w/ the patch from their bugzilla #2016 (use the latest
> copy I uploaded for 6.6p1), making sure to enable SCTP via --with-sctp on
> both a client and server machine.
> 2. Start sshd w/ at least "Transport all" in sshd_config (the SCTP patch
> adds this config directive) or via the command line.
> 3. On sshd machine, sysctl -w net.sctp.auth_enable=3D1.

Could you give it a try and do *first* the sysctl -w net.sctp.auth_enable=
=3D1
on server side and after that start the sshd instance? We definitely need
to fix that, but it seems ep is created on server side at time of auth_enab=
le=3D0
and you're setting if *afterwards* to 1. Looks this needs to be made immuta=
ble
during ep life-time.

> 4. On client, ssh -z <server>, and watch the bada boom.
>
> If there's a specific function I should go look at or pepper w/ printk()
> statements, let me know.  Not fully familiar w/ the call chain that the S=
CTP
> stack uses when it receives an INIT chunk.  If it's something bad in the
> INIT chunk sent by the ssh client machine, shouldn't be too hard to manua=
lly
> walk the functions and deduce how the code is interpreting things.
>
> --J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
