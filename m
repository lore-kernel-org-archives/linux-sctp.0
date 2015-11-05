From: "Balasundaram, Gunabalan" <gbalasundaram@sonusnet.com>
Date: Thu, 05 Nov 2015 19:47:19 +0000
Subject: lksctp-tools upgrade/downgrade questions 1.0.14 <= > (latest) 1.0.16
Message-Id: <BN3PR0301MB08332F1651CAB9C2A6A324EAC4290@BN3PR0301MB0833.namprd03.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

We are in the process of upgrading Fedora 16 kernel from 3.4.2-1 to 3.4.110 . During this time, considering whether the lksctp-tools need to be upgraded from 1.0.14 to latest (1.0.16). 

Here are my questions:

1. Does the current lksctp-tools 1.0.14 version compatible with new kernel 3.4.110?

2. If I want to upgrade the lksctp-tools to new version 1.0.16, do I need to remove the old one first prior to install the new version or installing the new version will automatically uninstall the old one? 
Here are the steps that currently being used to install 1.0.14:
cd lksctp-tools-1.0.14 >/dev/null 2>&1
./bootstrap >/dev/null 2>&1
./configure --prefix=/usr --libdir=/usr/lib64 >/dev/null 2>&1
make >/dev/null 2>&1
make install >/dev/null 2>&1

3. Similar to upgrade question above, what are the steps required to follow for downgrade procedures move from 1.0.16 to 1.0.14? We need to downgrade the version of lksctp-tools to match with rest of the downgraded software on the system.

Thank you,
Guna 

