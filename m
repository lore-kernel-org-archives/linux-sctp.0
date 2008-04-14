From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 14 Apr 2008 01:13:08 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the new specification
Message-Id: <4802AFA4.7070700@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F2AD4E.8000203@hp.com>
In-Reply-To: <47F2AD4E.8000203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Ivan Skytte J=F8rgensen wrote:
> On Friday 11 April 2008 21:56:11 Vlad Yasevich wrote:
>> Ivan Skytte J=F8rgensen wrote:
>>> ---connect.c---
>>> int connectx(void) {
>>> 	return 13; /*old implementation*/
>>> }
>>>
>>> int connectx_draft14(void) {
>>> 	return 14; /*new implementation*/
>>> }
>>> ---sctp.h---
>>> #ifndef SCTP_DRAFT13_CONNECTX
>>> extern int connectx(void) asm ("connectx_draft14");
>>> #else
>>> extern int connectx(void);
>>> #endif
>> This also means that any application attempting to rebuild with with
>> the new library, but using an old API, will have to change.
>> I don't know if we can get away this.
>=20
> We have to. the API is a live draft. The burden should not be one program=
s=20
> that follow the latest draft.
>=20
>> Also, who defines SCTP_DRAFT13_CONNECTX or SCTP_DRAFT14_CONNECTX, depend=
ing
>> on how ifdef is written?
>=20
> The application programmer define that.

Sorry, but once we do that, we essentially introduce dead code since this r=
equires
modifications by the programmer and they should just fix the code and pass =
in NULL.

>=20
> If he wants to use the new API then he does nothing. This means that the =
line
> 	extern int connectx(void) asm ("connectx_draft14");
> will be used. The compiler will generate references to connectx_draft14. =
on=20
> runtime connectx_draft14 will be called.
>=20
> If a newly compiledprogram tries to run with an old lksctp then the progr=
am=20
> cannot start at all due to missing symbol.
>=20
> If the application programmer thinks it is too much of a burden to fix th=
e=20
> calls to sctp_connectx() then he can #define SCTP_DRAFT13_CONNECTX and th=
e=20
> line:
> 	extern int connectx(void);
> will be used. The compiler will generate references to connectx. on runti=
me=20
> connectx will be called. If run with an old lksctp the program will funct=
ion=20
> fine.

Sorry, but I don't buy that.  If the programmer doesn't want to full power =
of
the new connectx(), he just pass in NULL as additional parameter and he don=
e.
That's easier, IMHO, then to add a #define (less characters to type :>).

>=20
> If a non-recompiled program uses the old API it will have references to=20
> connectx, which is the old API.
>

That's the only part I am concerned about, but then your argument about the
api being a live draft also applies and once could put on onus on programme=
r again.

I think that we've accepted that we can not get away from breaking the API;
however, preserving the ABI is a worth goal and I look into that a bit more.
=20
>> If we put that in netinet/sctp.h, then simply by recompiling against the
>> newer header, you have to change your program to comply to the new symbol
>> without ability to use the older one.
>=20
> No. The programmer can define SCTP_DRAFT13_CONNECTX  if he wants to use t=
he=20
> old API.
>=20
>=20
> [snip]
>> I guess I have to figure out symbol versioning since I think anything
>> else falls short.
>=20
> Symbol versioning does not solve the compile-time problem of old/new API.
>=20

Neither does a #define.  It just works around it at the cost to the library=
 providers.
I haven't been convinced that that cost is worth it.

-vlad
