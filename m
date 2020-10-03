From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 04:05:50 +0000
Subject: Re: [PATCH net-next 09/15] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Message-Id: <20201003040550.GD70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

On Tue, Sep 29, 2020 at 09:49:01PM +0800, Xin Long wrote:
...
> +struct sctp_udpencaps {
> +	sctp_assoc_t sue_assoc_id;
> +	struct sockaddr_storage sue_address;
> +	uint16_t sue_port;
> +};
...
> +static int sctp_setsockopt_encap_port(struct sock *sk,
> +				      struct sctp_udpencaps *encap,
> +				      unsigned int optlen)
> +{
> +	struct sctp_association *asoc;
> +	struct sctp_transport *t;
> +
> +	if (optlen != sizeof(*encap))
> +		return -EINVAL;
> +
> +	/* If an address other than INADDR_ANY is specified, and
> +	 * no transport is found, then the request is invalid.
> +	 */
> +	if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
> +		t = sctp_addr_id2transport(sk, &encap->sue_address,
> +					   encap->sue_assoc_id);
> +		if (!t)
> +			return -EINVAL;
> +
> +		t->encap_port = encap->sue_port;
                   ^^^^^^^^^^          ^^^^^^^^

encap_port is defined as __u16 is previous patch, but from RFC:
  sue_port:  The UDP port number in network byte order...

asoc->peer.port is stored in host order, so it makes sense to follow
it here. Then need a htons() here and its counter parts.  It is right
in some parts of the patches already.
