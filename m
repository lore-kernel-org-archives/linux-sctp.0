From: David Miller <davem@davemloft.net>
Date: Sun, 14 Jun 2015 19:56:01 +0000
Subject: Re: [PATCH v5] sctp: fix ASCONF list handling
Message-Id: <20150614.125601.1919783457395979333.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20150611.163122.1431848988995103178.davem@davemloft.net>
	<57c14bf7ac9eba1ceb76615cf52f5955c8349988.1434114814.git.marcelo.leitner@gmail.com>
In-Reply-To: <57c14bf7ac9eba1ceb76615cf52f5955c8349988.1434114814.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: nhorman@tuxdriver.com, hannes@stressinduktion.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, daniel@iogearbox.net, vyasevich@gmail.com, micchie@sfc.wide.ad.jp

From: marcelo.leitner@gmail.com
Date: Fri, 12 Jun 2015 10:16:41 -0300

> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> ->auto_asconf_splist is per namespace and mangled by functions like
> sctp_setsockopt_auto_asconf() which doesn't guarantee any serialization.
> 
> Also, the call to inet_sk_copy_descendant() was backuping
> ->auto_asconf_list through the copy but was not honoring
> ->do_auto_asconf, which could lead to list corruption if it was
> different between both sockets.
> 
> This commit thus fixes the list handling by using ->addr_wq_lock
> spinlock to protect the list. A special handling is done upon socket
> creation and destruction for that. Error handlig on sctp_init_sock()
> will never return an error after having initialized asconf, so
> sctp_destroy_sock() can be called without addrq_wq_lock. The lock now
> will be take on sctp_close_sock(), before locking the socket, so we
> don't do it in inverse order compared to sctp_addr_wq_timeout_handler().
> 
> Instead of taking the lock on sctp_sock_migrate() for copying and
> restoring the list values, it's preferred to avoid rewritting it by
> implementing sctp_copy_descendant().
> 
> Issue was found with a test application that kept flipping sysctl
> default_auto_asconf on and off, but one could trigger it by issuing
> simultaneous setsockopt() calls on multiple sockets or by
> creating/destroying sockets fast enough. This is only triggerable
> locally.
> 
> Fixes: 9f7d653b67ae ("sctp: Add Auto-ASCONF support (core).")
> Reported-by: Ji Jianwen <jiji@redhat.com>
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, thank you.
