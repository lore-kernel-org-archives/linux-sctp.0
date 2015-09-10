From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 10 Sep 2015 19:31:41 +0000
Subject: Re: SCTP BH locking during sctp_inq_push()
Message-Id: <55F1DA9D.6080700@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbUFuhFYeEy=7e5ibgpthPsYw_4Rpa4htRf3Lmdbw3N_eA@mail.gmail.com>
In-Reply-To: <CAGugRbUFuhFYeEy=7e5ibgpthPsYw_4Rpa4htRf3Lmdbw3N_eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 09/10/2015 11:13 AM, Karl Heiss wrote:
> Hi,
> 
> While looking through the code in sctp_backlog_rcv(), I noticed a case
> whereby sctp_inq_push() can be called outside of a bh_lock_sock()
> region if the likely case succeeds and the association has not moved.
> 
> The exact line in question:
> https://github.com/torvalds/linux/blob/v4.2-rc8/net/sctp/input.c#L350
> 
> Intuitively this looks incorrect, as all other calls to
> sctp_inq_push() are within a BH socket lock.  Am I missing something
> obvious that allows this particular case?

The bh socket lock is needed to protect the state machine from concurrent
bh and user access.

If the socket hasn't moved, the caller of the of backlog processing
holds the user side of the lock (i.e socket is owned by user).
As a result, any further incoming packets will be queued to backlog.

So the inqueue and the state machine are already protected.  No need
to hold the bh_lock.

-vlad


> 
> Regards,
> Karl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

