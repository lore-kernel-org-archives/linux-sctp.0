From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 01 Apr 2008 21:46:54 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the new	specification
Message-Id: <47F2AD4E.8000203@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Ivan Skytte J=F8rgensen wrote:
> On Friday 28 March 2008 20:54:38 Vlad Yasevich wrote:
>> The specification of sctp_connectx() has been changed to return
>> an association id.  Sence it is guaranteed the association id will
>> be a positive 32 bit integer, we can simply return that from our
>> setsockopt() in the case of success.  The library that implements
>> sctp_connectx() will re-interpret the call.
>=20
> Partial NAK.
>=20
> It breaks old versions of lksctp. I am not aware that we previously have =

> required lksctp to match the kernel exactly unless there was no other way.
>=20
> A new sockopt is safer.
>=20
> /isj


In what way?  The only possible problem is that sctp_connectx()
can return a positive value on success in addition to 0, depending
on which kernel is used.

How much of a problem is this really?

A new socket option is actually problematic as well, because the=20
behavior will depend on the system that lksctp libraries are built
on.

So, I am not sure which tradeoff is better...

-vlad
