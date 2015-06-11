From: David Miller <davem@davemloft.net>
Date: Thu, 11 Jun 2015 23:31:22 +0000
Subject: Re: [PATCH v4] sctp: fix ASCONF list handling
Message-Id: <20150611.163122.1431848988995103178.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20150610191418.GA19556@hmsreliant.think-freely.org>
	<94ae715119611f8df1baccd4f016c5d49a047a8d.1434032881.git.marcelo.leitner@gmail.com>
In-Reply-To: <94ae715119611f8df1baccd4f016c5d49a047a8d.1434032881.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mleitner@redhat.com
Cc: nhorman@tuxdriver.com, hannes@stressinduktion.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, daniel@iogearbox.net, vyasevich@gmail.com, micchie@sfc.wide.ad.jp

From: mleitner@redhat.com
Date: Thu, 11 Jun 2015 11:30:46 -0300

>     Attempts to circumvent this lock invertion with RCU and/or list splicing
>     were unsuccessful, as they led to more and more code to handle it
>     properly.
>     
>     Back when Hannes started reviewing the patches, he had asked if I
>     couldn't take the lock earlier during the socket destruction. I had said
>     no because sctp_destroy_sock() is called with socket lock already held
>     on sctp_close_sock() and such would not be possible to handle on error
>     handling situations like when sctp_init_sock() fails and
>     sctp_destroy_sock() is called right after that.
>     
>     But if we take care that nothing fails after initializing asconf on
>     sctp_init_sock(), this is possible, and less complicated than my RCU and
>     list splicing attempts.

This is definitely a cleaner/simpler fix, but:

> @@ -1528,7 +1528,10 @@ static void sctp_close(struct sock *sk, long timeout)
>  
>  	/* Supposedly, no process has access to the socket, but
>  	 * the net layers still may.
> +	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
> +	 * held and that should be grabbed before socket lock.
>  	 */
> +	spin_lock_bh(&net->sctp.addr_wq_lock);
>  	local_bh_disable();
>  	bh_lock_sock(sk);
>  
> @@ -1540,6 +1543,7 @@ static void sctp_close(struct sock *sk, long timeout)
>  
>  	bh_unlock_sock(sk);
>  	local_bh_enable();
> +	spin_unlock_bh(&net->sctp.addr_wq_lock);
>  
>  	sock_put(sk);
>  

The local_bh_{enable,disable}() now appear to be superfluous and thus
can be removed.
