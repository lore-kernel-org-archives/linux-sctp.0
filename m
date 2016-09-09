From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 09 Sep 2016 07:11:57 +0000
Subject: Re: [PATCH net 1/6] sctp: remove the unnecessary state check in sctp_outq_tail
Message-Id: <CADvbK_ddvZ4855B1PPLYVY2JV1okKzYXCpv-quNMBXp0Qb5Otw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1473326067.git.lucien.xin@gmail.com> <1718155e984f63995d1be9b053c58aa1a645718e.1473326067.git.lucien.xin@gmail.com>
 <20160908142701.GC16608@hmsreliant.think-freely.org> <CADvbK_dxTYrPPFJT5UPZErZLbW9y9oRm+VWbQXxhruwV6UgOZA@mail.gmail.com>
 <20160908192319.GD16608@hmsreliant.think-freely.org>
In-Reply-To: <20160908192319.GD16608@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

>>
> Its not enough to just look at the paths where outq_tail is called, because
> the outq_tail function is checking a state variable that can update
> asynchronously in the side effect processing queue.  Look at any one of the
> timer functions.  Those all fire asynchronous to the outq list, but they all

Fortunately, sctp_do_sm is protected by lock_sock.
I just checked all the sctp_do_sm calling in  timer functions.

------------
        bh_lock_sock(sk);
        if (sock_owned_by_user(sk)) {    <----------- [1]
                pr_debug("%s: sock is busy\n", __func__);
                /* Try again later.  */
                mod_timer()
                goto out_unlock;
        }
        error = sctp_do_sm(net, SCTP_EVENT_T_TIMEOUT,
out_unlock:
        bh_unlock_sock(sk);


which means sctp_do_sm is *non-reenterable* because of
sock lock's protection. even if it's interrupted by something
like timers, they have to delay their real process until sock
lock is released.

So It's still safe here. pls double-check.
