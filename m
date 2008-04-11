From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 11 Apr 2008 19:56:11 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the new specification
Message-Id: <47FFC25B.1090008@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F2AD4E.8000203@hp.com>
In-Reply-To: <47F2AD4E.8000203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Ivan Skytte J=F8rgensen wrote:
> On Friday 11 April 2008 15:20:44 Vlad Yasevich wrote:
>> Here is an update to the connectx() implementation the way
>> Ivan proposed.
>=20
> The patch looks fine.
>=20
>> The hard part to figure out is how to not break the library
>> ABI.  Right now there is really no way to do that without making
>> it a compile time feature for the library.  That is not really
>> an acceptable solution though.  So any ifdefs tricks will not
>> really solve the issue.
>=20
>=20
> For the user-level library I assume something like this will work:
>=20
> ---connect.c---
> int connectx(void) {
> 	return 13; /*old implementation*/
> }
>=20
> int connectx_draft14(void) {
> 	return 14; /*new implementation*/
> }
> ---sctp.h---
> #ifndef SCTP_DRAFT13_CONNECTX
> extern int connectx(void) asm ("connectx_draft14");
> #else
> extern int connectx(void);
> #endif

The problem is that the number of parameters to connectx() differs.

This also means that any application attempting to rebuild with with
the new library, but using an old API, will have to change.
I don't know if we can get away this.

Also, who defines SCTP_DRAFT13_CONNECTX or SCTP_DRAFT14_CONNECTX, depending
on how ifdef is written?

It's a non-starter to do that for applications.

If we put that in netinet/sctp.h, then simply by recompiling against the ne=
wer
header, you have to change your program to comply to the new symbol without=
 ability
to use the older one.

> ---example program---
> #include <stdio.h>
> int main(void) {
> 	printf("%d\n",connectx());
> 	return 0;
> }
> ---end
>=20
> I think the solution above fulfills:
> - old programs continue to use the old function, even if a new library is=
=20
> present.
> 	-	new programs will use the new API.
> 	-	new programs can use the old API if they are in a hurry to recompile a=
nd=20
> don't have the time to change their source files.
> 	-	new programs will fail to run (hard) if only the old API is available
> 	-	a program can use both APIs (eg. though shared libraries etc)
> 	-	and last: new programs don't have to do anything extra to to use the n=
ew=20
> API.
>=20
> There are other ways to do it, eg. with symbol versioning, with macro=20
> definitions, inline functions, etc. I can see that glibc uses internal sy=
mbol=20
> versioning. I don't know if there is any downside to use the asm("....").=
=20
> Both gcc and icc supports it.
>=20

I guess I have to figure out symbol versioning since I think anything else
falls short.

Of course we can just swallow the whole incompatibility thing and break the=
 API/ABI
stating that you must change your apps.

-vlad
