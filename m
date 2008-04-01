From: Ivan Skytte =?iso-8859-1?q?J=F8rgensen?= <isj-sctp@i1.dk>
Date: Tue, 01 Apr 2008 22:42:21 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH] [SCTP]: Support the =?iso-8859-1?q?new=09specification_of?= sctp
Message-Id: <200804020042.22011.isj-sctp@i1.dk>
List-Id: <linux-sctp.vger.kernel.org>
References: <47F2AD4E.8000203@hp.com>
In-Reply-To: <47F2AD4E.8000203@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tuesday 01 April 2008 23:46:54 Vlad Yasevich wrote:
> Ivan Skytte J=F8rgensen wrote:
> > On Friday 28 March 2008 20:54:38 Vlad Yasevich wrote:
> >> The specification of sctp_connectx() has been changed to return
> >> an association id.  Sence it is guaranteed the association id will
> >> be a positive 32 bit integer, we can simply return that from our
> >> setsockopt() in the case of success.  The library that implements
> >> sctp_connectx() will re-interpret the call.
> >
> > Partial NAK.
> >
> > It breaks old versions of lksctp. I am not aware that we previously have
> > required lksctp to match the kernel exactly unless there was no other
> > way.
> >
> > A new sockopt is safer.
> >
> > /isj
>
> In what way?  The only possible problem is that sctp_connectx()
> can return a positive value on success in addition to 0, depending
> on which kernel is used.


Your kernel patch will return positive values on success (the association i=
d).

lksctp-tools-1.0.8 has this in sctp_connectx():
	return setsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX, addrs, addrs_size);

and according to draft-ietf-tsvwg-sctpsocket-15.txt
"
   The call returns 0 on success or -1 if an error occured.  The
   variable errno is then set appropriately."

So new kernel + lksctp108 will not work, because correctly written programs=
=20
that tests for zero/non-zero returncodes for success/failure will suddenly =

start interpreting the return value from the new kernel as an error.

> How much of a problem is this really?

That is more interesting. I will only affect applications that has "=3D0"=20
instead of ">=3D0" test in calls to sctp_connectx(). I don't know how often=
=20
sctp_connectx() is actually used - I have never used it.

But at least it needs a notice somewhere that there is potential breakage, =
and=20
that there is a tighter-than-usual dependency between kernel and sctplib.

> A new socket option is actually problematic as well, because the
> behavior will depend on the system that lksctp libraries are built
> on.

Uhmm no, because the socket option names are in lksctp's local=20
include/netinet/sctp.h. lksctp does not depend on kernel headers at all.

the sctp_connectx() in lksctp will of course have to use the old socket nam=
e=20
as fallback:
  call brand new sockopt
  ok: good
  failure:
    if application don't care about assoc-id ('id' parameter is NULL):
      call old sockopt
    else
      fail (kernel too old)


And while we are at it: please reread my message from 2006-12-27 about some=
=20
thoughtsI had about sctp_connectx(). I have still not had any time to do=20
anything about it :-/

/isj
