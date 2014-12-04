From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Thu, 04 Dec 2014 09:54:08 +0000
Subject: RE: Problem with a host having an UNREACHABLE address ?
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B005722550@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B005721E0A@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

	Hello,

 I've put aside multiple receives of UNREACHABLE notifications, and done so=
me network packets captures, and actually found my mistake :=A0I had downsi=
zed too much the 'rto_max' parameter, for quickier detection of unavailable=
 peers on a fast network, but here its value was like the mean roundtrip ti=
me between hosts (given by the 'ping'), and from time to time, this retrans=
mission timeout was  exceeded ! Using a larger value for this parameter sol=
ved my problem :-)

What could be a good rto_max value calculation from the mean RTT value betw=
een hosts ?


     Thanks for your help,
		Fred.
