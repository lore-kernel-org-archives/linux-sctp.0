From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 21 Jan 2014 14:10:24 +0000
Subject: Re: [PATCH net-next 0/7] sctp: remove some macro locking wrappers
Message-Id: <20140121141024.GA23113@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1390290252-16080-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1390290252-16080-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Tue, Jan 21, 2014 at 03:44:05PM +0800, Wang Weidong wrote:
> In sctp.h we can find some macro locking wrappers. As Neil point out that:
> 
> "Its because in the origional implementation of the sctp protocol, there was a
> user space test harness which built the kernel module for userspace execution to
> cary our some unit testing on the code.  It did so by redefining some of those
> locking macros to user space friendly code.  IIRC we haven't use those unit
> tests in years, and so should be removing them, not adding them to other
> locations."
> 
> So I remove them.
> 
> Wang Weidong (7):
>   sctp: remove macro sctp_spin_[un]lock_irqrestore
>   sctp: remove macro sctp_local_bh_{disable|enable}
>   sctp: remove macro sctp_spin_[un]lock
>   sctp: remove macros sctp_write_[un]_lock
>   sctp: remove macros sctp_read_[un]lock
>   sctp: remove macros sctp_{lock|release}_sock
>   sctp: remove macros sctp_bh_[un]lock_sock
> 
>  include/net/sctp/sctp.h  | 27 ++-----------
>  net/sctp/endpointola.c   |  4 +-
>  net/sctp/input.c         | 54 +++++++++++++-------------
>  net/sctp/proc.c          | 12 +++---
>  net/sctp/protocol.c      |  4 +-
>  net/sctp/sm_sideeffect.c | 16 ++++----
>  net/sctp/socket.c        | 98 ++++++++++++++++++++++++------------------------
>  7 files changed, 98 insertions(+), 117 deletions(-)
> 
> -- 
> 1.7.12
> 
> 
> 
I would have preferred that this all be done as one patch, so that if anyone was
still using this macro set they would have a single change to bisect to, but
given that we already had several non-macrotized uses of these locks, its not
overly relevant

Acked-by: Neil Horman <nhorman@tuxdriver.com>

