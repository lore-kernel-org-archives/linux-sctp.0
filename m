From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 06 Jan 2009 13:50:15 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <49636197.7080800@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michal Hocko wrote:
> On Mon 05-01-09 18:05:21, Vlad Yasevich wrote:
>> Karsten, Michal
> 
> Hi Vlad,
> 
>> I think I found this cursed race.
>>
>> The problem is that nothing is guarding the asoc->base.sk reference.  This
>> reference changes during the accept()/peeloff() code paths and the only
>> guard around it is the socket lock.  But that lock is not taken when
>> the reference is used for reading as it is done in sctp_rcv().
>>
>> So, when we do sctp_bh_lock_sock(sk) in sctp_rcv(), we may be using
>> a stale cached copy of the sk which might have changed during sctp_accept().
>>
>> What this allows us to do is to have a user sending a packet on a socket
>> at the same time we may be processing and incoming packet on the same socket.
>> We just end up taking different locks which totally hoses us.
>>
>> -vlad
>>
>>
> 
>> diff --git a/net/sctp/input.c b/net/sctp/input.c
>> index bf612d9..2e4a864 100644
>> --- a/net/sctp/input.c
>> +++ b/net/sctp/input.c
>> @@ -249,6 +249,19 @@ int sctp_rcv(struct sk_buff *skb)
>>  	 */
>>  	sctp_bh_lock_sock(sk);
>>  
>> +	if (sk != rcvr->sk) {
>> +		/* Our cached sk is different from the rcvr->sk.  This is
>> +		 * because migrate()/accept() may have moved the association
>> +		 * to a new socket and released all the sockets.  So now we
>> +		 * are holding a lock on the old socket while the user may
>> +		 * be doing something with the new socket.  Switch our veiw
>> +		 * of the current sk.
>> +		 */
>> +		sctp_bh_unlock_sock(sk);
>> +		sk = rcvr->sk;
>> +		sctp_bh_lock_sock(sk);
>> +	}
>> +
>>  	if (sock_owned_by_user(sk)) {
>>  		SCTP_INC_STATS_BH(SCTP_MIB_IN_PKT_BACKLOG);
>>  		sctp_add_backlog(sk, skb);
> 
> Can you reproduce with this patch? Unfortunately, I don't have any HW
> configuration available at the moment.

I've had the test run for a few hours without any issues.  Usually the
system crashes with the first 15 minutes.

> 
> Our SLES10SP2 kernel contains similar code:
> [...]
>         /* Acquire access to the sock lock. Note: We are safe from other
>          * bottom halves on this lock, but a user may be in the lock too,
>          * so check if it is busy.
>          */
>         sctp_bh_lock_sock(sk);
> 
>         /* It is possible that the association could have moved to a different
>          * socket if it is peeled off. If so, update the sk.
>          */
>         if (sk != rcvr->sk) {
>                 sctp_bh_lock_sock(rcvr->sk);
>                 sctp_bh_unlock_sock(sk);
>                 sk = rcvr->sk;
>         }
> 
>         if (sock_owned_by_user(sk))
>                 sk_add_backlog(sk, skb);
>         else
>                 sctp_backlog_rcv(sk, skb);
> 
>         /* Release the sock and the sock ref we took in the lookup calls.
>          * The asoc/ep ref will be released in sctp_backlog_rcv.
>          */
>         sctp_bh_unlock_sock(sk);
>         sock_put(sk);
> 
>         return ret;
> [...]
> 
> This test, however, has been removed by 61c9fed41638249f8b6ca5345064eb1beb50179f.
> AFAIU this patch deals with similar race in the receive path when socket
> is moved.

Yes.  The old code was insufficient, but this part should not have been removed.
The old code was still racy in other parts of the peel-off and resulted in
crashes you've seen.   However, this particular part or something along these
lines needs to be there.

I really hate the this is done and currently looking at a way to protect this
pointer somehow, or rework it so it's not needed.  The problem is that we
perform other checks using the sk without locking it so there could be other
races as well that we just haven't seen because noone has an app yet that needs
the additional functionality.  So, even this patch I sent is not a complete
solution, but it is enough to fix the crash your customer is seeing.

> 
> As you can see the test&relock part differs only in ordering of the old
> unlock and the new lock.
> Is this ordering important? 

I don't think so.  In fact, I think having both sockets locked will make lockdep
complain.  Releasing the lock on the socket can let the user lock it, but then
we enter the backlog code and everything is ok.  If the socket is not owned,
then everything proceeds normally.  As long as we own the correct lock, it
should be safe.  Right now, we don't own the correct lock and that causes trouble.

> Do we have to unlock old socket sooner to enable rcvr->sk change? 
> Personally, I don't think so, because we would see deadlock otherwise,
> right? 
> Are there any other patches which depend on the above one?
> 

I don't think so.

-vlad
