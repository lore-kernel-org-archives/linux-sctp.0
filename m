From: Thomas Dreibholz <dreibh@iem.uni-due.de>
Date: Sat, 18 Sep 2010 14:11:03 +0000
Subject: Re: [Bugme-new] [Bug 18592] New: Remote/local Denial of Service vulnerability in SCTP packet/chunk h
Message-Id: <201009181611.05665.dreibh@iem.uni-due.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <bug-18592-10286@https.bugzilla.kernel.org/> <20100915124340.5bf89d07.akpm@linux-foundation.org> <4C916615.4060400@hp.com>
In-Reply-To: <4C916615.4060400@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, bugzilla-daemon@bugzilla.kernel.org, netdev@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org, stable@kernel.org, David Miller <davem@davemloft.net>, Martin Becke <martin.becke@uni-due.de>

On Donnerstag 16 September 2010, Vlad Yasevich wrote:
> On 09/15/2010 03:43 PM, Andrew Morton wrote:
> > Thanks, but please send patches via email, not via bugzilla.
> > Documentation/SubmittingPatches has some tips.  Suitable recipients for
> > this patch are, from the MAINTAINERS file:
> >=20
> > M:      Vlad Yasevich <vladislav.yasevich@hp.com>
> > M:      Sridhar Samudrala <sri@us.ibm.com>
> > L:      linux-sctp@vger.kernel.org
> >=20
> > but please just send it as a reply-to-all to this email so that everyone
> > knows wht's happening.
> >=20
> > I'd suggest that you also add the line
> >=20
> > Cc: <stable@kernel.org>
> >=20
> > to the end of the changelog so that we don't forget to consider the
> > patch for backporting.
>=20
> Hi Andrew
>=20
> There is a much simpler solution to this problem that I posted to netdev
> today.

Dear all,

Vlad's patch solves the problem. I hope this patch can go into the mailine =

kernel soon, in order to get distribution kernels fixed as soon as possible=
. It=20
is relatively easy to trigger the denial of service problem, making all=20
systems providing SCTP-based services vulnerable to a remote DoS attack.

I have also been able to reproduce the problem with kernel 2.6.32, i.e. at =

least all kernels from 2.6.32 to 2.6.36 are affected.


Best regards
--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Dr. Thomas Dreibholz

 University of Duisburg-Essen,                   Room ES210
 Inst. for Experimental Mathematics              Ellernstra=DFe 29
 Computer Networking Technology Group            D-45326 Essen/Germany
-----------------------------------------------------------------------
 E-Mail:     dreibh@iem.uni-due.de
 Homepage:   http://www.iem.uni-due.de/~dreibh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D