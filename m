From: David Miller <davem@davemloft.net>
Date: Wed, 13 Sep 2017 16:25:22 +0000
Subject: Re: [PATCH net] sctp: potential read out of bounds in sctp_ulpevent_type_enabled()
Message-Id: <20170913.092522.934509429497822082.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170913092028.idzvduj7ran4li6b@mwanda>
In-Reply-To: <20170913092028.idzvduj7ran4li6b@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dan.carpenter@oracle.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 13 Sep 2017 12:20:28 +0300

> @@ -154,7 +154,11 @@ static inline int sctp_ulpevent_type_enabled(__u16 sn_type,
>  					     struct sctp_event_subscribe *mask)
>  {
>  	char *amask = (char *) mask;
> -	return amask[sn_type - SCTP_SN_TYPE_BASE];
> +	int offset = sn_type - SCTP_SN_TYPE_BASE;

Please use reverse-christmas-tree local variable ordering.

Thank you.
