From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 12:23:28 +0000
Subject: Test-Suite for the Partial Reliability Extension
Message-Id: <20170117122328.GA4322@aomx-netbook>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear linux sctp mailing list,
I am a master student of the M=FCnster University of Applied Sciences
(Germany).
In the last months I have developed a test suite in packetdrill for the
partial reliability extension of sctp.
Many test cases can run the Linux and FreeBSD kernel and therefore I
have
found some potential problems / bugs with my test suite.
I want to share and discuss these potential issues with you on the
mailing list.

Because the testsuite is published on Github with a permissive license
(bsd-style) you can get all developed tests by cloning the following
repository with git:
https://github.com/nplab/PR_SCTP_Testsuite.
On Github I also have documented the test-results of the test-suite in
README-Files.
Please note that only the tests from the subfolder forward-tsn
are applicable for Linux, because the tests in the other directories
require
support for the NR-SACK and the User Message Interleaving extension.

Please also note that you need the nplab-version of packetdrill from
https://github.com/nplab/packetdrill
in order to run the tests on linux. The original version of packetdrill
=66rom google misses SCTP support.

I will send a couple of mails, one for every potential issue that I have
found with the test suite on kernel 4.4.0-x under ubuntu 16.04.
All mails will contain a short description of the potential problem and
a link to the test-case or multiple test-cases that were used to detect
this behaviour.

Yours sincerely,
Julian Cordes

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJYfgy+AAoJEAvjb6G8Rb/j1rAIAI4XsT46yzLEaAxpQVe3hG05
3MvPtJtYSf4WJv5BCgfowGgPN2aG2SqLZ0wkSLT0vMA4dU02rg/9QZfEfqKBxAq9
VgYooZJ5RLYD07J6w9dIaIpVWdueBhFwtOBXapVg6PmOdSGMzh+VTV5+Qs0t1pKh
CK9AfgyQitn6osHtjMPKzLG+L0Lss7yw9Qjjechq/McIBkcMAqGRhkdqLQM+5dmE
/AKXlPPBYk7zCc7QbbWJ+fUNXezfFd9YvvicSBIUMjBsEEew2zR9xayAoR//kKud
HtkpP0BxGaatm8iPbf4lZJvpT8f4ykiWNF90N76na0m3ZtgY1zQYlmd4Dl0+YYg=
=ZePJ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
