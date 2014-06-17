From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 17 Jun 2014 12:35:16 +0000
Subject: RE: [PATCH net-next 1/6] Support for SCTP_RECVRCVINFO socket option
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1725DC57@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403006273-27859-1-git-send-email-geirola@gmail.com>
 <1403006273-27859-2-git-send-email-geirola@gmail.com>
In-Reply-To: <1403006273-27859-2-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Geir Ola Vaagland' <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Vlad Yasevich <vyasevich@gmail.com>

From: Geir Ola Vaagland
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 0a248b3..75c598a 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -216,6 +216,7 @@ struct sctp_sock {
>  	__u8 frag_interleave;
>  	__u32 adaptation_ind;
>  	__u32 pd_point;
> +	__u8 recvrcvinfo;

This adds a lot of padding.
Possibly it should also be a 'bool'

...
> +static int sctp_setsockopt_recvrcvinfo(struct sock *sk,
> +		char __user *optval,
> +		unsigned int optlen){
> +
> +	int val;
> +
> +	if(optlen < sizeof(int))
> +		return -EINVAL;
> +
> +	if(get_user(val, (int __user*)optval)){
> +		return -EFAULT;
> +	}

I suspect the above code is quite common, and should be put into
a separate function.

> +	sctp_sk(sk)->recvrcvinfo = (val = 0) ? 0 : 1;

See 'bool'

...
> +static int sctp_getsockopt_recvrcvinfo(struct sock *sk,
> +		int len,
> +		char __user *optval,
> +		int __user *optlen){
> +
> +	int val;
> +
> +	if (len < sizeof(int))
> +		return -EINVAL;
> +
> +	len = sizeof(int);
> +	val = (sctp_sk(sk)->recvrcvinfo = 1);
> +	if (put_user(len, optlen))
> +		return -EFAULT;
> +	if (copy_to_user(optval, &val, len))
> +		return -EFAULT;

This wants factoring out as well.

...
	David



