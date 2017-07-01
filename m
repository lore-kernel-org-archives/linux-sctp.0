From: David Miller <davem@davemloft.net>
Date: Sat, 01 Jul 2017 16:09:00 +0000
Subject: Re: [PATCH net-next 00/11] sctp: remove typedefs from structures part 1
Message-Id: <20170701.090900.1231795762851084102.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1498794481.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1498794481.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 30 Jun 2017 11:52:11 +0800

> As we know, typedef is suggested not to use in kernel, even checkpatch.pl
> also gives warnings about it. Now sctp is using it for many structures.
> 
> All this kind of typedef's using should be removed. As the 1st part, this
> patchset is to remove it for 11 basic structures in linux/sctp.h. It is
> also to fix some indents.
> 
> No any code's logic is changed in these patches, only cleaning up.

Series applied, thanks.
