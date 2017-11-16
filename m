From: "Butler, Peter" <pbutler@sonusnet.com>
Date: Thu, 16 Nov 2017 15:21:55 +0000
Subject: Multi-homed SCTP with NAT
Message-Id: <BY2PR03MB409F0A6B2B29B20B0201BCCD62E0@BY2PR03MB409.namprd03.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Are there any Linux tools/tricks/hacks that would allow us to setup a multi-homed association through a NAT?

I am aware of the information in the SCTP Applicability Statement (RFC 3257), however the NAT in question does not have an internal Application Layer Gateway (ALG) capable of intelligently translating the additional IP addresses embedded within the INIT and INIT ACK chunks (only the addresses in the IP header are translated).  As such, these additional address do not get translated to addresses that the remote end understands.

Peter Butler

