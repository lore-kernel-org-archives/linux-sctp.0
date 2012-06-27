From: David Miller <davem@davemloft.net>
Date: Wed, 27 Jun 2012 04:05:04 +0000
Subject: Re: [PATCH] sctp: be mroe restrictive in transport selection on bundled sacks
Message-Id: <20120626.210504.657326352932517334.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1340742704-2192-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1340742704-2192-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 26 Jun 2012 16:31:44 -0400

> @@ -240,15 +240,20 @@ static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
>  	 */
>  	if (sctp_chunk_is_data(chunk) && !pkt->has_sack &&
>  	    !pkt->has_cookie_echo) {
> -		struct sctp_association *asoc;
>  		struct timer_list *timer;
> -		asoc = pkt->transport->asoc;
> +		struct sctp_association *asoc = pkt->transport->asoc;
> +		struct sctp_transport *trans;
> +
>  		timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
>  
>  		/* If the SACK timer is running, we have a pending SACK */
>  		if (timer_pending(timer)) {
>  			struct sctp_chunk *sack;
>  			asoc->a_rwnd = asoc->rwnd;
> +
> +			if (chunk->transport && !chunk->transport->moved_ctsn)
> +				return retval;
> +
>  			sack = sctp_make_sack(asoc);
>  			if (sack) {
>  				retval = sctp_packet_append_chunk(pkt, sack);

The new local variable 'trans' seems to be unused.
