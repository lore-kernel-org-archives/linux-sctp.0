From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 17 Jan 2017 16:37:21 +0000
Subject: Re: Test-Suite for the Partial Reliability Extension
Message-Id: <20170117163720.GJ3781@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117122328.GA4322@aomx-netbook>
In-Reply-To: <20170117122328.GA4322@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Tue, Jan 17, 2017 at 01:23:28PM +0100, Julian Cordes wrote:
> Dear linux sctp mailing list,
> I am a master student of the M=FCnster University of Applied Sciences
> (Germany).
> In the last months I have developed a test suite in packetdrill for the
> partial reliability extension of sctp.
> Many test cases can run the Linux and FreeBSD kernel and therefore I
> have
> found some potential problems / bugs with my test suite.
> I want to share and discuss these potential issues with you on the
> mailing list.

Hi Julian,

Thanks for coming forward with all this, much appreciated.

>=20
> Because the testsuite is published on Github with a permissive license
> (bsd-style) you can get all developed tests by cloning the following
> repository with git:
> https://github.com/nplab/PR_SCTP_Testsuite.
> On Github I also have documented the test-results of the test-suite in
> README-Files.
> Please note that only the tests from the subfolder forward-tsn
> are applicable for Linux, because the tests in the other directories
> require
> support for the NR-SACK and the User Message Interleaving extension.
>=20
> Please also note that you need the nplab-version of packetdrill from
> https://github.com/nplab/packetdrill
> in order to run the tests on linux. The original version of packetdrill
> from google misses SCTP support.
>=20
> I will send a couple of mails, one for every potential issue that I have
> found with the test suite on kernel 4.4.0-x under ubuntu 16.04.
> All mails will contain a short description of the potential problem and
> a link to the test-case or multiple test-cases that were used to detect
> this behaviour.
>=20
> Yours sincerely,
> Julian Cordes


