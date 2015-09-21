From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 21 Sep 2015 17:06:36 +0000
Subject: Re: [PATCH RFC 1/1] sctp: Prevent soft lockup when sctp_accept() is called during a timeout event
Message-Id: <5600391C.2040309@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1442511143-26992-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1442511143-26992-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 09/17/2015 01:32 PM, Karl Heiss wrote:
> A case can occur when sctp_accept() is called by the user during
> a heartbeat timeout event after the 4-way handshake.  Since
> sctp_assoc_migrate() changes both assoc->base.sk and assoc->ep, the
> bh_sock_lock in sctp_generate_heartbeat_event() will be taken with
> the listening socket but released with the new association socket.
> The result is a deadlock on any future attempts to take the listening
> socket lock.
> 
> Note that this race can occur with other SCTP timeouts that take
> the bh_lock_sock() in the event sctp_accept() is called.
> 
>  BUG: soft lockup - CPU#9 stuck for 67s! [swapper:0]
>  ...
>  RIP: 0010:[<ffffffff8152d48e>]  [<ffffffff8152d48e>] _spin_lock+0x1e/0x30
>  RSP: 0018:ffff880028323b20  EFLAGS: 00000206
>  RAX: 0000000000000002 RBX: ffff880028323b20 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff880028323be0 RDI: ffff8804632c4b48
>  RBP: ffffffff8100bb93 R08: 0000000000000000 R09: 0000000000000000
>  R10: ffff880610662280 R11: 0000000000000100 R12: ffff880028323aa0
>  R13: ffff8804383c3880 R14: ffff880028323a90 R15: ffffffff81534225
>  FS:  0000000000000000(0000) GS:ffff880028320000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>  CR2: 00000000006df528 CR3: 0000000001a85000 CR4: 00000000000006e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process swapper (pid: 0, threadinfo ffff880616b70000, task ffff880616b6cab0)
>  Stack:
>  ffff880028323c40 ffffffffa01c2582 ffff880614cfb020 0000000000000000
>  <d> 0100000000000000 00000014383a6c44 ffff8804383c3880 ffff880614e93c00
>  <d> ffff880614e93c00 0000000000000000 ffff8804632c4b00 ffff8804383c38b8
>  Call Trace:
>  <IRQ>
>  [<ffffffffa01c2582>] ? sctp_rcv+0x492/0xa10 [sctp]
>  [<ffffffff8148c559>] ? nf_iterate+0x69/0xb0
>  [<ffffffff814974a0>] ? ip_local_deliver_finish+0x0/0x2d0
>  [<ffffffff8148c716>] ? nf_hook_slow+0x76/0x120
>  [<ffffffff814974a0>] ? ip_local_deliver_finish+0x0/0x2d0
>  [<ffffffff8149757d>] ? ip_local_deliver_finish+0xdd/0x2d0
>  [<ffffffff81497808>] ? ip_local_deliver+0x98/0xa0
>  [<ffffffff81496ccd>] ? ip_rcv_finish+0x12d/0x440
>  [<ffffffff81497255>] ? ip_rcv+0x275/0x350
>  [<ffffffff8145cfeb>] ? __netif_receive_skb+0x4ab/0x750
>  ...
> 
> With lockdep debugging:
> 
>  ==================>  [ BUG: bad unlock balance detected! ]
>  -------------------------------------
>  CslRx/12087 is trying to release lock (slock-AF_INET) at:
>  [<ffffffffa01bcae0>] sctp_generate_timeout_event+0x40/0xe0 [sctp]
>  but there are no more locks to release!
> 
>  other info that might help us debug this:
>  2 locks held by CslRx/12087:
>  #0:  (&asoc->timers[i]){+.-...}, at: [<ffffffff8108ce1f>] run_timer_softirq+0x16f/0x3e0
>  #1:  (slock-AF_INET){+.-...}, at: [<ffffffffa01bcac3>] sctp_generate_timeout_event+0x23/0xe0 [sctp]
> 
> Ensure the socket taken is also the same one that is released by
> saving a copy of the socket before entering the timeout event
> critical section.
> 
> Signed-off-by: Karl Heiss <kheiss@gmail.com>
> 

Thanks for finding this.  Good catch.

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

> -- >8 --
> 
> I cooked up the patch above, and while it appears to fix the soft lockups,
> it still seems like a copy of the endpoint should also be saved off for
> the use in sctp_do_sm() since sctp_assoc_migrate() changes it as well.

I think you are OK here.  The only time this would actually be an issue is
in the race of the timer against migrate.  Migrate will run with the user
side of the lock taken.  The timer grabs the bh side of the lock, checks to
see if the user side is running and drops the lock.  The issue you see is that
the association attachment changed between taking of the lock and dropping it.
Caching the sk pointer solves this.

This is not a problem for actually running through the state machine because
the user side of lock can not be taken by anyone else while we are holding
the bh side.  And if the user side isn't running already, we can safely
access all the pointers.

> 
> However, this begs the question, between saving the two off, is that not
> just a smaller race surface?  I had considered wrapping the call to
> sctp_assoc_migrate() in bh_sock_[un]lock() calls, but I don't know if
> that is overkill.

No, I don't think there is a race surface at all.  The race was that while
holding the bh lock, we had a change in assoc->sk linkage due to association
moving.  If we save the original sk and always lock/unlock the same structure,
we eliminate the race.  It doesn't really matter whether we cache the new sk
or the original one as long as we lock/unlock the same one.

-vlad

> 
> Any feedback would be greatly appreciated.
> 
> P.S.: I plan on submitting a separate patch for the whitespace issue this set
> fixes.
> 
> ---
>  net/sctp/sm_sideeffect.c |   42 +++++++++++++++++++++++-------------------
>  1 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 35df126..7cf1c4a 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -244,12 +244,13 @@ void sctp_generate_t3_rtx_event(unsigned long peer)
>  	int error;
>  	struct sctp_transport *transport = (struct sctp_transport *) peer;
>  	struct sctp_association *asoc = transport->asoc;
> -	struct net *net = sock_net(asoc->base.sk);
> +	struct sock *sk = asoc->base.sk;
> +	struct net *net = sock_net(sk);
>  
>  	/* Check whether a task is in the sock.  */
>  
> -	bh_lock_sock(asoc->base.sk);
> -	if (sock_owned_by_user(asoc->base.sk)) {
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
>  		pr_debug("%s: sock is busy\n", __func__);
>  
>  		/* Try again later.  */
> @@ -272,10 +273,10 @@ void sctp_generate_t3_rtx_event(unsigned long peer)
>  			   transport, GFP_ATOMIC);
>  
>  	if (error)
> -		asoc->base.sk->sk_err = -error;
> +		sk->sk_err = -error;
>  
>  out_unlock:
> -	bh_unlock_sock(asoc->base.sk);
> +	bh_unlock_sock(sk);
>  	sctp_transport_put(transport);
>  }
>  
> @@ -285,11 +286,12 @@ out_unlock:
>  static void sctp_generate_timeout_event(struct sctp_association *asoc,
>  					sctp_event_timeout_t timeout_type)
>  {
> +	struct sock *sk = asoc->base.sk;
>  	struct net *net = sock_net(asoc->base.sk);
>  	int error = 0;
>  
> -	bh_lock_sock(asoc->base.sk);
> -	if (sock_owned_by_user(asoc->base.sk)) {
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
>  		pr_debug("%s: sock is busy: timer %d\n", __func__,
>  			 timeout_type);
>  
> @@ -312,10 +314,10 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
>  			   (void *)timeout_type, GFP_ATOMIC);
>  
>  	if (error)
> -		asoc->base.sk->sk_err = -error;
> +		sk->sk_err = -error;
>  
>  out_unlock:
> -	bh_unlock_sock(asoc->base.sk);
> +	bh_unlock_sock(sk);
>  	sctp_association_put(asoc);
>  }
>  
> @@ -365,10 +367,11 @@ void sctp_generate_heartbeat_event(unsigned long data)
>  	int error = 0;
>  	struct sctp_transport *transport = (struct sctp_transport *) data;
>  	struct sctp_association *asoc = transport->asoc;
> -	struct net *net = sock_net(asoc->base.sk);
> +	struct sock *sk = asoc->base.sk;
> +	struct net *net = sock_net(sk);
>  
> -	bh_lock_sock(asoc->base.sk);
> -	if (sock_owned_by_user(asoc->base.sk)) {
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
>  		pr_debug("%s: sock is busy\n", __func__);
>  
>  		/* Try again later.  */
> @@ -388,11 +391,11 @@ void sctp_generate_heartbeat_event(unsigned long data)
>  			   asoc->state, asoc->ep, asoc,
>  			   transport, GFP_ATOMIC);
>  
> -	 if (error)
> -		 asoc->base.sk->sk_err = -error;
> +	if (error)
> +		sk->sk_err = -error;
>  
>  out_unlock:
> -	bh_unlock_sock(asoc->base.sk);
> +	bh_unlock_sock(sk);
>  	sctp_transport_put(transport);
>  }
>  
> @@ -403,10 +406,11 @@ void sctp_generate_proto_unreach_event(unsigned long data)
>  {
>  	struct sctp_transport *transport = (struct sctp_transport *) data;
>  	struct sctp_association *asoc = transport->asoc;
> -	struct net *net = sock_net(asoc->base.sk);
> +	struct sock *sk = asoc->base.sk;
> +	struct net *net = sock_net(sk);
>  
> -	bh_lock_sock(asoc->base.sk);
> -	if (sock_owned_by_user(asoc->base.sk)) {
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
>  		pr_debug("%s: sock is busy\n", __func__);
>  
>  		/* Try again later.  */
> @@ -427,7 +431,7 @@ void sctp_generate_proto_unreach_event(unsigned long data)
>  		   asoc->state, asoc->ep, asoc, transport, GFP_ATOMIC);
>  
>  out_unlock:
> -	bh_unlock_sock(asoc->base.sk);
> +	bh_unlock_sock(sk);
>  	sctp_association_put(asoc);
>  }
>  
> 

