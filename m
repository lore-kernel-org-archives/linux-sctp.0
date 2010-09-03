From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 03 Sep 2010 14:15:47 +0000
Subject: Re: [PATCH] sctp: prevent reading out-of-bounds memory
Message-Id: <4C810313.80000@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTineCKfL-UvqfQBTZPDFeqm3Nrpb=pFnZpkSqbEQ@mail.gmail.com>
In-Reply-To: <AANLkTineCKfL-UvqfQBTZPDFeqm3Nrpb=pFnZpkSqbEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/03/2010 09:48 AM, Dan Rosenberg wrote:
> Two user-controlled allocations in SCTP are subsequently dereferenced
> as sockaddr structs, without checking if the dereferenced struct
> members fall beyond the end of the allocated chunk.  There doesn't
> appear to be any information leakage here based on how these members
> are used and additional checking, but it's still worth fixing.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/net/sctp/socket.c	2010-09-03 08:58:48.127080114 -0400
> +++ linux-2.6.35.4/net/sctp/socket.c	2010-09-03 09:22:06.337096825 -0400
> @@ -889,6 +889,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>  	int err;
>  	int addrcnt = 0;
>  	int walk_size = 0;
> +	unsigned int remaining = addrs_size;
>  	struct sockaddr *sa_addr;
>  	void *addr_buf;
>  	struct sctp_af *af;
> @@ -916,6 +917,13 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>  	/* Walk through the addrs buffer and count the number of addresses. */
>  	addr_buf = kaddrs;
>  	while (walk_size < addrs_size) {
> +
> +		/* Don't read out-of-bounds memory */
> +		if (remaining < sizeof(struct sockaddr)) {
> +			kfree(kaddrs);
> +			return -EINVAL;
> +		}
> +

Hm.. we already validate that we have the proper amount of space for a given sockaddr.
The only thing we are missing is making sure that there is room to get the proper address
family and I think you can do that without adding any extra variables:

	if (walk_size + sizeof(sa_family_t) > addr_size) {
		/* Not enough room for address family */
		kfree(kaddrs);
		return -EINVAL;
	}

-vlad

>  		sa_addr = (struct sockaddr *)addr_buf;
>  		af = sctp_get_af_specific(sa_addr->sa_family);
> 
> @@ -929,6 +937,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>  		addrcnt++;
>  		addr_buf += af->sockaddr_len;
>  		walk_size += af->sockaddr_len;
> +		remaining -= af->sockaddr_len;
>  	}
> 
>  	/* Do the work. */
> @@ -984,6 +993,7 @@ static int __sctp_connect(struct sock* s
>  	void *addr_buf;
>  	unsigned short port;
>  	unsigned int f_flags = 0;
> +	unsigned int remaining = addrs_size;
> 
>  	sp = sctp_sk(sk);
>  	ep = sp->ep;
> @@ -1002,6 +1012,13 @@ static int __sctp_connect(struct sock* s
>  	/* Walk through the addrs buffer and count the number of addresses. */
>  	addr_buf = kaddrs;
>  	while (walk_size < addrs_size) {
> +
> +		/* Don't read out-of-bounds memory */
> +		if (remaining < sizeof(union sctp_addr)) {
> +			err = -EINVAL;
> +			goto out_free;
> +		}
> +
>  		sa_addr = (union sctp_addr *)addr_buf;
>  		af = sctp_get_af_specific(sa_addr->sa.sa_family);
>  		port = ntohs(sa_addr->v4.sin_port);
> @@ -1101,6 +1118,7 @@ static int __sctp_connect(struct sock* s
>  		addrcnt++;
>  		addr_buf += af->sockaddr_len;
>  		walk_size += af->sockaddr_len;
> +		remaining -= af->sockaddr_len;
>  	}
> 
>  	/* In case the user of sctp_connectx() wants an association
> 

