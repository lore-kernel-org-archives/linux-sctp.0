From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 16 Aug 2012 18:23:35 +0000
Subject: Re: [patch] sctp: fix bogus if statement in sctp_auth_recv_cid()
Message-Id: <87txw266hk.fsf@xmission.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20120816131618.GA23279@elgon.mountain>
In-Reply-To: <20120816131618.GA23279@elgon.mountain> (Dan Carpenter's message
	of "Thu, 16 Aug 2012 16:16:19 +0300")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> There is an extra semi-colon here, so we always return 0 instead of
> calling __sctp_auth_cid().

Doh.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only needed for linux-next.
>
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index aaa6c12..159b9bc 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -695,7 +695,7 @@ int sctp_auth_recv_cid(sctp_cid_t chunk, const struct sctp_association *asoc)
>  		return 0;
>  
>  	net = sock_net(asoc->base.sk);
> -	if (!net->sctp.auth_enable);
> +	if (!net->sctp.auth_enable)
>  		return 0;
>  
>  	return __sctp_auth_cid(chunk,
