From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Aug 2019 14:58:43 +0000
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-Id: <20190819145843.GE2870@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> +static int sctp_setsockopt_asconf_supported(struct sock *sk,
> +					    char __user *optval,
> +					    unsigned int optlen)
> +{
> +	struct sctp_assoc_value params;
> +	struct sctp_association *asoc;
> +	struct sctp_endpoint *ep;
> +	int retval = -EINVAL;
> +
> +	if (optlen != sizeof(params))
> +		goto out;
> +
> +	if (copy_from_user(&params, optval, optlen)) {
> +		retval = -EFAULT;
> +		goto out;
> +	}
> +
> +	asoc = sctp_id2assoc(sk, params.assoc_id);
> +	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
> +	    sctp_style(sk, UDP))
> +		goto out;
> +
> +	ep = sctp_sk(sk)->ep;
> +	ep->asconf_enable = !!params.assoc_value;

Considering this will be negotiated on handshake, shouldn't it deny
changes to Established asocs? (Same for Auth)

> +
> +	if (ep->asconf_enable && ep->auth_enable) {
> +		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
> +		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
> +	}
> +
> +	retval = 0;
> +
> +out:
> +	return retval;
> +}
