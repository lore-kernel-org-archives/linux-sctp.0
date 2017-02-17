From: David Miller <davem@davemloft.net>
Date: Fri, 17 Feb 2017 20:19:07 +0000
Subject: Re: [PATCH net] sctp: check duplicate node before inserting a new transport
Message-Id: <20170217.151907.1987368624831286456.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ba2afff1b2cf9e0026a23dde02d207583efa3d83.1487320524.git.lucien.xin@gmail.com>
In-Reply-To: <ba2afff1b2cf9e0026a23dde02d207583efa3d83.1487320524.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Feb 2017 16:35:24 +0800


> +	list = rhltable_lookup(&sctp_transport_hashtable, &arg,
> +			       sctp_hash_params);
> +
> +	rhl_for_each_entry_rcu(transport, tmp, list, node)
> +		if (transport->asoc->ep = t->asoc->ep) {
> +			err = -EEXIST;
> +			goto out;
> +		}
> +
>  	err = rhltable_insert_key(&sctp_transport_hashtable, &arg,
>  				  &t->node, sctp_hash_params);
> +
> +out:

Well, what if another thread of control inserts a matching transport
after you've checked the list but before rhltable_insert_key() does
it's work?

What write side lock is being held to protect the table from
modifications here?
