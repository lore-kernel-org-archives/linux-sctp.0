From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 16 Apr 2014 19:12:15 +0000
Subject: Re: [PATCH]: NULL pointer dereference in sctp_auth_asoc_set_default_hmac
Message-Id: <534ED60F.9040606@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <534E0C7A.9070309@gentoo.org>
In-Reply-To: <534E0C7A.9070309@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 04/16/2014 12:52 AM, Joshua Kinard wrote:
> Hi linux-sctp,
>=20
> I stumbled into a NULL pointer dereference on amd64 and mips when receivi=
ng
> an INIT chunk containing the HMAC Algorithm Parameter (0x8004) when
> net.sctp.auth_enable =3D 1.
>=20
> From some quick debugging I did, even if net.sctp.auth_enable =3D 1, the =
if
> statement on line 448 in net/sctp/auth.c::sctp_auth_init_hmacs() checks
> net->sctp.auth_enable and gets '0' back, which causes ep->auth_hmacs to g=
et
> set to NULL:
>=20
> 448         if (!net->sctp.auth_enable) {
> 449                 ep->auth_hmacs =3D NULL;
> 450                 return 0;
> 451         }
>=20
>=20
> Later, the if statement on line 621 in
> net/sctp/auth.c::sctp_auth_asoc_set_default_hmac() attempts to access
> ep->auth_hmacs without first checking for NULL, which triggers the oops:
>=20
> 620                 /* If this TFM has been allocated, use this id */
> 621                 if (ep->auth_hmacs[id]) {
> 622                         asoc->default_hmac_id =3D id;
> 623                         break;
> 624                 }
>=20
>=20
> I am not sure why net->sctp.auth_enable is initially returning '0' when i=
t's
> set in sysctl, and verified in /proc/sys/net/sctp/auth_enable.  Adding a
> check for NULL on ep->auth_hmacs in the if statement stops the oops from
> happening, though I am not sure if this is the correct fix.
>=20
> Another thing I noticed, is that I cannot trigger the Oops from the
> SCTP/DTLS samples on this page:
> http://sctp.fh-muenster.de/dtls-samples.html
>=20
> But if I patch OpenSSH with the SCTP patch below, that does trigger it on
> the sshd server machine as soon as I issue 'ssh -z user@host ...'.  I've
> looked at both INIT chunks sent out by the respective programs in Wiresha=
rk,
> but nothing stands out.
>=20
> OpenSSH SCTP:
> https://bugzilla.mindrot.org/show_bug.cgi?id 16
>=20
> If anyone's got other ideas to try out, let me know, thanks!
>=20


Which kernel are you running?  Does it have this commit in it?
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=EFb842c45e667332774196bd5a1d539d048159cc

Without that, I could see how a bug might happen...

-vlad
