From: David Miller <davem@davemloft.net>
Date: Tue, 24 Jul 2018 21:11:41 +0000
Subject: Re: [PATCH PATCH net-next 00/18] net whitespace cleanups
Message-Id: <20180724.141141.740309584672047092.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724192918.31165-1-sthemmin@microsoft.com>
In-Reply-To: <20180724192918.31165-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stephen@networkplumber.org
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, ralf@linux-mips.org, jreuter@yaina.de, pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de, alex.aring@gmail.com, stefan@datenfreihafen.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, johannes@sipsolutions.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net, linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-wpan@vger.kernel.org, linux-s3

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 24 Jul 2018 12:29:00 -0700

> Ran script that I use to check for trailing whitespace and
> blank lines at end of files across all files in net/ directory.
> These are errors that checkpatch reports and git flags.
> 
> These are the resulting fixes broken up mostly by subsystem.

I skipped 9p, ceph, and sunrpc since those don't go via my tree.

I applied the rest because it's mostly small and won't cause too
many conflicts in the future.

Thanks.
