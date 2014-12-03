From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Wed, 03 Dec 2014 13:27:07 +0000
Subject: RE: wrong family for IP addresses given by sctp library
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B00569FB89@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00569F8CC@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

	Hello Ivan, Michael, Daniel,

> Isn't the returned address simply a IPv6-mapped IPv4 address (::ffff:1.2.3.4) ? You can test it with IN6_IS_ADDR_V4MAPPED.

Yes, it is (I've verified with the provided macro) ! I'll use this macro to detect and update provided addresses, thanks !


Daniel, I'll try to test it on a recent kernel, but it will take some time to set up... thanks for the commit's reference !

	Regards,
		Fred.
