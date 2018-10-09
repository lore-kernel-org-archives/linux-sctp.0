From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 09 Oct 2018 08:40:06 +0000
Subject: RE: [PATCH 1/1] sctp: fix align sctp_assoc_stats to run on x86_64 in compat IA32
Message-Id: <824785f4cfb84379b831295631c0cf67@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <C23DDB3F-AE59-49F1-9B45-4205B61668E4@wp.pl>
In-Reply-To: <C23DDB3F-AE59-49F1-9B45-4205B61668E4@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Krzysztof Grzywocz
> Sent: 08 October 2018 20:07
>
> Problem:
> On 64bit kernel ELF32bit gets improper value of `SCTP_GET_ASSOC_STATS` (call `getsockopt` on SCTP
> socket) due to different `struct sctp_assoc_stats` aligment (mostly because of different
> `_K_SS_ALIGNSIZE`).
...
> -----
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index ce620e87..73963062 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -6685,6 +6685,65 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
>  	return 0;
>  }
> 
> +#ifdef CONFIG_COMPAT
> +
> +struct __kernel_sockaddr_storage_compat32 {
> +	__kernel_sa_family_t	ss_family;		/* address family */
> +	/* Following field(s) are implementation specific */
> +	char		__data[_K_SS_MAXSIZE - sizeof(unsigned short)];
> +				/* space to achieve desired size, */
> +				/* _SS_MAXSIZE value minus size of ss_family */
> +} __attribute__ ((packed,aligned(4)));	/* force desired alignment */

I don't think you need the attribute here.
You could also use an unnamed union. probably:
struct __kernel_sockaddr_storage_compat32 {
	union {
		__kernel_sa_family_t	ss_family;		/* address family */
		char		__data[_K_SS_MAXSIZE];		/* Pad to correct size */
	}
};

> +struct sctp_assoc_stats_compat32 {
> +	int32_t	sas_assoc_id;    /* Input */
> +					 /* Transport of observed max RTO */
> +	struct __kernel_sockaddr_storage_compat32 sas_obs_rto_ipaddr;
> +	uint64_t		sas_maxrto;      /* Maximum Observed RTO for period */
> +	uint64_t		sas_isacks;	 /* SACKs received */
> +	uint64_t		sas_osacks;	 /* SACKs sent */
> +	uint64_t		sas_opackets;	 /* Packets sent */
> +	uint64_t		sas_ipackets;	 /* Packets received */
> +	uint64_t		sas_rtxchunks;   /* Retransmitted Chunks */
> +	uint64_t		sas_outofseqtsns;/* TSN received > next expected */
> +	uint64_t		sas_idupchunks;  /* Dups received (ordered+unordered) */
> +	uint64_t		sas_gapcnt;      /* Gap Acknowledgements Received */
> +	uint64_t		sas_ouodchunks;  /* Unordered data chunks sent */
> +	uint64_t		sas_iuodchunks;  /* Unordered data chunks received */
> +	uint64_t		sas_oodchunks;	 /* Ordered data chunks sent */
> +	uint64_t		sas_iodchunks;	 /* Ordered data chunks received */
> +	uint64_t		sas_octrlchunks; /* Control chunks sent */
> +	uint64_t		sas_ictrlchunks; /* Control chunks received */
> +} __attribute__ ((packed,aligned(4)));

Isn't there a 'uint64_t with the alignment needed for 32bit apps'
that can be used for the uint64_t structure members?
It will be needed for a lot of compat fields.
Then you don't need the attribute here either.
It would then be right for any 32bit architectures where u64 is 8
byte aligned.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
