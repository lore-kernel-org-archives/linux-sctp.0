From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 02 Apr 2008 15:50:21 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the new specification
Message-Id: <47F3AB3D.7050906@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F2AD4E.8000203@hp.com>
In-Reply-To: <47F2AD4E.8000203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi Ivan

Ivan Skytte J=F8rgensen wrote:
>=20
>=20
> And while we are at it: please reread my message from 2006-12-27 about so=
me=20
> thoughtsI had about sctp_connectx(). I have still not had any time to do =

> anything about it :-/
>=20
> /isj
>=20

I've been pondering the library change as well and the conclusion I've=20
come to is that we either introduce some ugliness into the=20
include/net/sctp.h or we break the API and force people to recompile.

This is really a result of breaking the API in the specification.  That
should not have been allowed, but we now have to live with it.

The good thing is the lksctp library has been unofficially tied to the=20
kernel for some time; however, we haven't had to deal with such blatant
API breakage yet.

-vlad
