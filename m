From: Thomas Dreibholz <dreibh@iem.uni-due.de>
Date: Wed, 15 Sep 2010 12:53:11 +0000
Subject: Re: [PATCH] net: SCTP NULL-pointer dereference problem description and fix
Message-Id: <201009151453.14465.dreibh@iem.uni-due.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <201009151003.17407.dreibh@iem.uni-due.de> <4C908768.4040502@cn.fujitsu.com>
In-Reply-To: <4C908768.4040502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Martin Becke <martin.becke@uni-due.de>

On Mittwoch 15 September 2010, Shan Wei wrote:
> Thomas Dreibholz wrote, at 09/15/2010 04:03 PM:
> > sctp_assoc_update_retran_path() in net/sctp/associola.c may dereference=
 a
> > NULL-pointer when compiled with SCTP_DEBUG option: t will be NULL if
> > there is no usable path for retransmission. SCTP_DEBUG_PRINTK_IPADDR()
> > makes an access to t->ipaddr.v4.sin_port, without checking t before.
> > t=3DNULL =3D> oops.
> >=20
> > The patch below against 2.6.36-rc4 (git repository) simply ensures that=
 t
> > is checked for not being set to NULL before calling
> > SCTP_DEBUG_PRINTK_IPADDR().
>=20
> This bug has been reported by WeiYongjun and fixed by vlad for several
> months. About the details see .
> http://marc.info/?l=3Dlinux-sctp&m=127359276009851&w=3D2
>=20
> But this patch is still in vlad's net-next tree, not in main tree.
> See the patch:
> http://git.kernel.org/?p=3Dlinux/kernel/git/vxy/lksctp-dev.git;a=3Dcommit=
;h=EB1
> 639d206320e6a09168d6dd77306eaf5f02582

This patch resolves the problem. I am using the main tree. The patch should=
=20
also be applied there.


Best regards
--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Dr. Thomas Dreibholz

 University of Duisburg-Essen,                   Room ES210
 Inst. for Experimental Mathematics              Ellernstra=C3=9Fe 29
 Computer Networking Technology Group            D-45326 Essen/Germany
-----------------------------------------------------------------------
 E-Mail:     dreibh@iem.uni-due.de
 Homepage:   http://www.iem.uni-due.de/~dreibh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D