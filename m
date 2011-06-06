From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 06 Jun 2011 19:55:32 +0000
Subject: Re: linux-next: Tree for June 6 (sctp)
Message-Id: <20110606125532.793b3cfd.randy.dunlap@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
In-Reply-To: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-sctp@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>

On Mon, 6 Jun 2011 13:20:36 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110603:


when CONFIG_IPV6 is not enabled:

ERROR: "ipv6_chk_addr" [net/sctp/sctp.ko] undefined!



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
