From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 05 Nov 2015 20:18:57 +0000
Subject: Re: lksctp-tools upgrade/downgrade questions 1.0.14 <= > (latest) 1.0.16
Message-Id: <20151105201857.GA3644@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <BN3PR0301MB08332F1651CAB9C2A6A324EAC4290@BN3PR0301MB0833.namprd03.prod.outlook.com>
In-Reply-To: <BN3PR0301MB08332F1651CAB9C2A6A324EAC4290@BN3PR0301MB0833.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Nov 05, 2015 at 07:47:19PM +0000, Balasundaram, Gunabalan wrote:
> Hello,
> 
> We are in the process of upgrading Fedora 16 kernel from 3.4.2-1 to 3.4.110 . During this time, considering whether the lksctp-tools need to be upgraded from 1.0.14 to latest (1.0.16). 
> 
> Here are my questions:
> 
> 1. Does the current lksctp-tools 1.0.14 version compatible with new kernel 3.4.110?

Yes

> 2. If I want to upgrade the lksctp-tools to new version 1.0.16, do I need to remove the old one first prior to install the new version or installing the new version will automatically uninstall the old one? 
> Here are the steps that currently being used to install 1.0.14:
> cd lksctp-tools-1.0.14 >/dev/null 2>&1
> ./bootstrap >/dev/null 2>&1
> ./configure --prefix=/usr --libdir=/usr/lib64 >/dev/null 2>&1
> make >/dev/null 2>&1
> make install >/dev/null 2>&1

You can/should considering backporting a rpm from a newer Fedora. It
makes this handling much easier.
Removing is not really necessary, but helps to keep your system in a
saner state.

> 3. Similar to upgrade question above, what are the steps required to follow for downgrade procedures move from 1.0.16 to 1.0.14? We need to downgrade the version of lksctp-tools to match with rest of the downgraded software on the system.

You may just reinstall it over what is currently installed, being it
1.0.14 or 1.0.16.
Same deal as above regarding cleaning the previous one.

  Marcelo

