From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 14 Dec 2017 18:25:36 +0000
Subject: Re: [PATCHv2 net-next 1/8] sctp: add basic structures and make chunk function for ifwdtsn
Message-Id: <20171214182536.GI3532@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

On Fri, Dec 15, 2017 at 12:41:25AM +0800, Xin Long wrote:
> sctp_ifwdtsn_skip, sctp_ifwdtsn_hdr and sctp_ifwdtsn_chunk are used to
> define and parse I-FWD TSN chunk format, and sctp_make_ifwdtsn is a
> function to build the chunk.
> 
> The I-FORWARD-TSN Chunk Format is defined in section 2.3.1 of RFC8260.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo R. Leitner <marcelo.leitner@gmail.com>

> ---
>  include/linux/sctp.h       | 17 +++++++++++++++++
>  include/net/sctp/sm.h      |  3 +++
>  include/net/sctp/structs.h |  1 +
>  net/sctp/sm_make_chunk.c   | 24 ++++++++++++++++++++++++
>  4 files changed, 45 insertions(+)
> 
> diff --git a/include/linux/sctp.h b/include/linux/sctp.h
> index 38e2cf6..b36c766 100644
> --- a/include/linux/sctp.h
> +++ b/include/linux/sctp.h
> @@ -110,6 +110,7 @@ enum sctp_cid {
>  
>  	/* Use hex, as defined in ADDIP sec. 3.1 */
>  	SCTP_CID_ASCONF			= 0xC1,
> +	SCTP_CID_I_FWD_TSN		= 0xC2,
>  	SCTP_CID_ASCONF_ACK		= 0x80,
>  	SCTP_CID_RECONF			= 0x82,
>  }; /* enum */
> @@ -616,6 +617,22 @@ struct sctp_fwdtsn_chunk {
>  	struct sctp_fwdtsn_hdr fwdtsn_hdr;
>  };
>  
> +struct sctp_ifwdtsn_skip {
> +	__be16 stream;
> +	__u8 reserved;
> +	__u8 flags;
> +	__be32 mid;
> +};
> +
> +struct sctp_ifwdtsn_hdr {
> +	__be32 new_cum_tsn;
> +	struct sctp_ifwdtsn_skip skip[0];
> +};
> +
> +struct sctp_ifwdtsn_chunk {
> +	struct sctp_chunkhdr chunk_hdr;
> +	struct sctp_ifwdtsn_hdr fwdtsn_hdr;
> +};
>  
>  /* ADDIP
>   * Section 3.1.1 Address Configuration Change Chunk (ASCONF)
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 0993b49..2883c43 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -199,6 +199,9 @@ struct sctp_chunk *sctp_make_cwr(const struct sctp_association *asoc,
>  				 const struct sctp_chunk *chunk);
>  struct sctp_chunk *sctp_make_idata(const struct sctp_association *asoc,
>  				   __u8 flags, int paylen, gfp_t gfp);
> +struct sctp_chunk *sctp_make_ifwdtsn(const struct sctp_association *asoc,
> +				     __u32 new_cum_tsn, size_t nstreams,
> +				     struct sctp_ifwdtsn_skip *skiplist);
>  struct sctp_chunk *sctp_make_datafrag_empty(const struct sctp_association *asoc,
>  					    const struct sctp_sndrcvinfo *sinfo,
>  					    int len, __u8 flags, gfp_t gfp);
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 8ef638d..a5c3cf4 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -599,6 +599,7 @@ struct sctp_chunk {
>  		struct sctp_fwdtsn_hdr *fwdtsn_hdr;
>  		struct sctp_authhdr *auth_hdr;
>  		struct sctp_idatahdr *idata_hdr;
> +		struct sctp_ifwdtsn_hdr *ifwdtsn_hdr;
>  	} subh;
>  
>  	__u8 *chunk_end;
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 23a7313..b9b269c 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3536,6 +3536,30 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
>  	return retval;
>  }
>  
> +struct sctp_chunk *sctp_make_ifwdtsn(const struct sctp_association *asoc,
> +				     __u32 new_cum_tsn, size_t nstreams,
> +				     struct sctp_ifwdtsn_skip *skiplist)
> +{
> +	struct sctp_chunk *retval = NULL;
> +	struct sctp_ifwdtsn_hdr ftsn_hdr;
> +	size_t hint;
> +
> +	hint = (nstreams + 1) * sizeof(__u32);
> +
> +	retval = sctp_make_control(asoc, SCTP_CID_I_FWD_TSN, 0, hint,
> +				   GFP_ATOMIC);
> +	if (!retval)
> +		return NULL;
> +
> +	ftsn_hdr.new_cum_tsn = htonl(new_cum_tsn);
> +	retval->subh.ifwdtsn_hdr > +		sctp_addto_chunk(retval, sizeof(ftsn_hdr), &ftsn_hdr);
> +
> +	sctp_addto_chunk(retval, nstreams * sizeof(skiplist[0]), skiplist);
> +
> +	return retval;
> +}
> +
>  /* RE-CONFIG 3.1 (RE-CONFIG chunk)
>   *   0                   1                   2                   3
>   *   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
