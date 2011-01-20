From: Christoph Paasch <christoph.paasch@uclouvain.be>
Date: Thu, 20 Jan 2011 14:09:34 +0000
Subject: MultiPath TCP in the Linux Kernel
Message-Id: <201101201509.34536.christoph.paasch@uclouvain.be>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net, linux-sctp@vger.kernel.org

Hi all,

The IETF is developing a new transport layer solution, MultiPath TCP, which=
=20
allows to efficiently exploit several Internet paths between a pair of host=
s,=20
while presenting a single TCP connection to the application layer.

At the UCLouvain in Belgium we are developping the support for MultiPath TC=
P=20
in the Linux Kernel. The implementation is a major extension to the Linux T=
CP-
stack.

For general information, access:
http://inl.info.ucl.ac.be/mptcp
https://scm.info.ucl.ac.be/trac/mptcp/

To access the git-repository:
git://scm.info.ucl.ac.be/mtcp.git
branches:
	mptcp_2.6.36 - based on Linux Kernel 2.6.36
	mtcp_no_subrcvqueue - based on Linux Kernel 2.6.28

For questions, feedback,... feel free to subscribe to the mptcp-dev Mailing-
List:
https://listes-2.sipr.ucl.ac.be/sympa/info/mptcp-dev


Regards,
Christoph

--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Universit=E9 Catholique de Louvain

www.rollerbulls.be
--
