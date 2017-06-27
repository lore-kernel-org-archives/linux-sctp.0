From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 27 Jun 2017 12:02:05 +0000
Subject: Re: possible deadlock in sctp_close
Message-Id: <20170627120204.GA8532@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jun 27, 2017 at 02:34:00PM +0800, GeneBlue wrote:
> Hi:
>     I got this error when fuzzing linux kernel 4.11.rc1 by running
> syzkaller.
> 
> 
> 
> ======================> [ INFO: possible recursive locking detected ]
> 4.11.0-rc1 #10 Not tainted
> ---------------------------------------------
> syz-executor3/11836 is trying to acquire lock:
>  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff83207811>] lock_sock
> include/net/sock.h:1460 [inline]
>  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff83207811>] sctp_close+0xa1/0x720
> net/sctp/socket.c:1497
> 
> but task is already holding lock:
>  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff83219b98>] lock_sock
> include/net/sock.h:1460 [inline]
>  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff83219b98>]
> sctp_getsockopt+0x228/0x47c0 net/sctp/socket.c:6611
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(sk_lock-AF_INET);
>   lock(sk_lock-AF_INET);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 

Looks like this has already been reported, and was fixed via commit 6dfe4b97e,
available in v4.12-rc5
Neil

