From: Ivan Skytte =?iso-8859-1?q?J=F8rgensen?= <isj-sctp@i1.dk>
Date: Sat, 12 Apr 2008 11:11:52 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the new specification of sctp_connectx()
Message-Id: <200804121311.52265.isj-sctp@i1.dk>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F2AD4E.8000203@hp.com>
In-Reply-To: <47F2AD4E.8000203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Friday 11 April 2008 21:56:11 Vlad Yasevich wrote:
> Ivan Skytte J=F8rgensen wrote:
> > ---connect.c---
> > int connectx(void) {
> > 	return 13; /*old implementation*/
> > }
> >
> > int connectx_draft14(void) {
> > 	return 14; /*new implementation*/
> > }
> > ---sctp.h---
> > #ifndef SCTP_DRAFT13_CONNECTX
> > extern int connectx(void) asm ("connectx_draft14");
> > #else
> > extern int connectx(void);
> > #endif
>
> This also means that any application attempting to rebuild with with
> the new library, but using an old API, will have to change.
> I don't know if we can get away this.

We have to. the API is a live draft. The burden should not be one programs =

that follow the latest draft.

> Also, who defines SCTP_DRAFT13_CONNECTX or SCTP_DRAFT14_CONNECTX, dependi=
ng
> on how ifdef is written?

The application programmer define that.

If he wants to use the new API then he does nothing. This means that the li=
ne
	extern int connectx(void) asm ("connectx_draft14");
will be used. The compiler will generate references to connectx_draft14. on=
=20
runtime connectx_draft14 will be called.

If a newly compiledprogram tries to run with an old lksctp then the program=
=20
cannot start at all due to missing symbol.

If the application programmer thinks it is too much of a burden to fix the =

calls to sctp_connectx() then he can #define SCTP_DRAFT13_CONNECTX and the =

line:
	extern int connectx(void);
will be used. The compiler will generate references to connectx. on runtime=
=20
connectx will be called. If run with an old lksctp the program will functio=
n=20
fine.

If a non-recompiled program uses the old API it will have references to=20
connectx, which is the old API.

> If we put that in netinet/sctp.h, then simply by recompiling against the
> newer header, you have to change your program to comply to the new symbol
> without ability to use the older one.

No. The programmer can define SCTP_DRAFT13_CONNECTX  if he wants to use the=
=20
old API.


[snip]
> I guess I have to figure out symbol versioning since I think anything
> else falls short.

Symbol versioning does not solve the compile-time problem of old/new API.

