From: "David Laight" <David.Laight@ACULAB.COM>
Date: Mon, 16 Dec 2013 15:24:48 +0000
Subject: RE: [PATCH] SCTP: Reduce log spamming for sctp setsockopt
Message-Id: <AE90C24D6B3A694183C094C60CF0A2F6026B749A@saturn3.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org

> From: Neil Horman
> During a recent discussion regarding some sctp socket options, it was noted that
> we have several points at which we issue log warnings that can be flooded at an
> unbounded rate by any user.  Fix this by converting all the pr_warns in the
> sctp_setsockopt path to be pr_warn_ratelimited.
> 
> Note there are several debug level messages as well.  I'm leaving those alone,
> as, if you turn on pr_debug, you likely want lots of verbosity.
...
> -		pr_warn("Use of struct sctp_assoc_value in delayed_ack socket option deprecated\n");
> -		pr_warn("Use struct sctp_sack_info instead\n");
> +		pr_warn_ratelimited("Use of struct sctp_assoc_value in delayed_ack socket option
> deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_sack_info instead\n");

Do you need to send these as a single ratelimited message?

	David



