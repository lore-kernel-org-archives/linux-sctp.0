From: David Miller <davem@davemloft.net>
Date: Sun, 04 Mar 2018 18:02:17 +0000
Subject: Re: [PATCH net-next 0/9] sctp: clean up sctp_sendmsg
Message-Id: <20180304.130217.1441144680336824217.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu,  1 Mar 2018 23:05:09 +0800

> This cleanup mostly does three things:
> 
>  - extract some codes into functions to make sendmsg more readable.
> 
>  - tidy up some codes to avoid the unnecessary checks.
> 
>  - adjust some logic so that it will be easier to add the send flags
>    and cmsgs features that I will post after this.
> 
> To make it easy to review and to check if the code is compatible with
> before, this patchset is to do it step by step in 9 patches.
> 
> NOTE:
> There will be a conflict when merging
> Commit 2277c7cd75e3 ("sctp: Add LSM hooks") from selinux tree,
> the solution is to:
> 
> 1. remove all the lines in [B]:
> 
>     <<<<<<< HEAD
>     [A]
>     ===>     [B]
>     >>>>>>> 2277c7c... sctp: Add LSM hooks
> 
> 2. and apply the following diff-output:
 ...

Series applied, thank you.

In particular, thanks for the merge resolution details.
