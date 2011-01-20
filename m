From: Hagen Paul Pfeifer <hagen@jauu.net>
Date: Thu, 20 Jan 2011 15:38:25 +0000
Subject: Re: MultiPath TCP in the Linux Kernel
Message-Id: <7e28a5ddc16848dcd98c05351113304f@localhost>
List-Id: <linux-sctp.vger.kernel.org>
References: <201101201509.34536.christoph.paasch@uclouvain.be>
In-Reply-To: <201101201509.34536.christoph.paasch@uclouvain.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: christoph.paasch@uclouvain.be
Cc: netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net, linux-sctp@vger.kernel.org


On Thu, 20 Jan 2011 15:09:34 +0100, Christoph Paasch wrote:
> Hi all,
> 
> The IETF is developing a new transport layer solution, MultiPath TCP,
> which 
> allows to efficiently exploit several Internet paths between a pair of
> hosts, 
> while presenting a single TCP connection to the application layer.
> 
> At the UCLouvain in Belgium we are developping the support for MultiPath
> TCP 
> in the Linux Kernel. The implementation is a major extension to the
Linux
> TCP-
> stack.

Hello Christoph,

if you want that your work becomes part of the official network stack you
should align your effort on the official Linux way. This means you should
split your work and publish patches on this maillinglist.

Cheers, Hagen
