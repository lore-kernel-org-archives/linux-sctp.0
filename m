From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 02 Sep 2009 15:36:49 +0000
Subject: Re: [PATCH 2/2] sctp: remove no used member from struct sctp_packet
Message-Id: <4A9E9111.3010006@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4A9DFE10.4060600@cn.fujitsu.com>
In-Reply-To: <4A9DFE10.4060600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> member has_auth of struct sctp_packet is defined and
> set, but not used. struct sctp_packet has auth member
> can indicate the packet contains an AUTH chunk. So
> this patch remove it.
> 

No, we should instead be using 'has_auth'.  It will be
especially useful when we update the AUTH api, since it
changes the way DATA is signed.

-vlad

> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  include/net/sctp/structs.h |    3 ---
>  net/sctp/output.c          |    5 -----
>  2 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index edfcacf..9996097 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -817,9 +817,6 @@ struct sctp_packet {
>  	/* This packet contains a SACK chunk. */
>  	__u8 has_sack;
>  
> -	/* This packet contains an AUTH chunk */
> -	__u8 has_auth;
> -
>  	/* This packet contains at least 1 DATA chunk */
>  	__u8 has_data;
>  
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index fbbfbce..c115e8b 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -78,7 +78,6 @@ struct sctp_packet *sctp_packet_config(struct sctp_packet *packet,
>  	packet->vtag = vtag;
>  	packet->has_cookie_echo = 0;
>  	packet->has_sack = 0;
> -	packet->has_auth = 0;
>  	packet->has_data = 0;
>  	packet->ipfragok = 0;
>  	packet->auth = NULL;
> @@ -123,7 +122,6 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
>  	packet->vtag = 0;
>  	packet->has_cookie_echo = 0;
>  	packet->has_sack = 0;
> -	packet->has_auth = 0;
>  	packet->has_data = 0;
>  	packet->ipfragok = 0;
>  	packet->malloced = 0;
> @@ -325,8 +323,6 @@ append:
>  			goto finish;
>  		/* Disallow SACK bundling after DATA. */
>  		packet->has_sack = 1;
> -		/* Disallow AUTH bundling after DATA */
> -		packet->has_auth = 1;
>  		/* Let it be knows that packet has DATA in it */
>  		packet->has_data = 1;
>  		/* timestamp the chunk for rtx purposes */
> @@ -341,7 +337,6 @@ append:
>  		break;
>  
>  	    case SCTP_CID_AUTH:
> -		packet->has_auth = 1;
>  		packet->auth = chunk;
>  		break;
>  	}

