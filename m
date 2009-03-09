From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 09 Mar 2009 18:43:46 +0000
Subject: Re: [PATCH 1/6] sctp: implement protocol definitions for STREAM-RESET
Message-Id: <49B56362.3040200@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <49B489A1.5030602@cn.fujitsu.com>
In-Reply-To: <49B489A1.5030602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> This patch implement the protocol definitions for STREAM-RESET
> extension.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
>  include/linux/sctp.h |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 101 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sctp.h b/include/linux/sctp.h
> index c2731bf..5a12eb0 100644
> --- a/include/linux/sctp.h
> +++ b/include/linux/sctp.h
> @@ -111,6 +111,9 @@ typedef enum {
>  	/* Use hex, as defined in ADDIP sec. 3.1 */
>  	SCTP_CID_ASCONF			= 0xC1,
>  	SCTP_CID_ASCONF_ACK		= 0x80,
> +
> +	/* STREAM-RESET Extension Section 3.1 */
> +	SCTP_CID_STREAM_RESET		= 0x82,
>  } sctp_cid_t; /* enum */
>  
>  
> @@ -202,6 +205,12 @@ typedef enum {
>  	SCTP_PARAM_SUCCESS_REPORT	= cpu_to_be16(0xc005),
>  	SCTP_PARAM_ADAPTATION_LAYER_IND = cpu_to_be16(0xc006),
>  
> +	/* STREAM-RESET Extension Section 3.2 */
> +	SCTP_PARAM_RESET_OUT_REQUEST	= cpu_to_be16(0x000d),
> +	SCTP_PARAM_RESET_IN_REQUEST	= cpu_to_be16(0x000e),
> +	SCTP_PARAM_RESET_TSN_REQUEST	= cpu_to_be16(0x000f),
> +	SCTP_PARAM_RESET_RESPONSE	= cpu_to_be16(0x0010),
> +	SCTP_PARAM_ADD_STREAM		= cpu_to_be16(0x0011),
>  } sctp_param_t; /* enum */
>  
>  
> @@ -707,4 +716,96 @@ typedef struct sctp_auth_chunk {
>  	sctp_authhdr_t auth_hdr;
>  } __attribute__((packed)) sctp_auth_chunk_t;
>  
> +/* STREAM-RESET Extension Section 3.1 STREAM RESET Chunk
> + *
> + * The chunk has the following format:
> + *      0                   1                   2                   3
> + *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *     | Type = 0x82   |  Chunk Flags  |      Chunk Length             |
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *     |                    Stream Reset Parameter                     |
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + *     |                    Stream Reset Parameter (optional)          |
> + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> + */
> +typedef struct sctp_strrst_chunk {
> +        sctp_chunkhdr_t chunk_hdr;
> +        __u8 params[0];
> +} __attribute__((packed)) sctp_strrst_chunk_t;
> +
> +/* STREAM-RESET Extension Section 3.2.1 Outgoing SSN Reset Request Parameter
> + *
> + * This parameter is used by the sender to request some outgoing streams
> + * to be reset.
> + */
> +typedef struct sctp_reset_out_req {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 request_seq;
> +	__be32 response_seq;
> +	__be32 send_reset_at_tsn;
> +	__be16 stream[0];
> +} __attribute__((packed)) sctp_reset_out_req_t;
> +
> +/* STREAM-RESET Extension Section 3.2.2 Incoming SSN Reset Request Parameter
> + *
> + * This parameter is used by the sender to request that the peer
> + * requests some of its outgoing streams to be reset.
> + */
> +typedef struct sctp_reset_in_req {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 request_seq;
> +	__be16 stream[0];
> +} __attribute__((packed)) sctp_reset_in_req_t;
> +
> +/* STREAM-RESET Extension Section 3.2.3 SSN/TSN Reset Request Parameter
> + *
> + * This parameter is used by the sender to request to reset the TSN and
> + * SSN numbering of all streams.
> + */
> +typedef struct sctp_reset_tsn_req {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 request_seq;
> +} __attribute__((packed)) sctp_reset_tsn_req_t;
> +
> +/* STREAM-RESET Extension Section 3.2.4 Stream Reset Response Parameter
> + *
> + * This parameter is used by the receiver of a stream reset request
> + * parameter to respond to the stream reset request.
> + */
> +typedef struct sctp_reset_res {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 response_seq;
> +	__be32 result;
> +} __attribute__((packed)) sctp_reset_res_t;
> +
> +typedef struct sctp_reset_tsn_res {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 response_seq;
> +	__be32 result;
> +	__be32 senders_next_tsn;
> +	__be32 receivers_next_tsn;
> +} __attribute__((packed)) sctp_reset_tsn_res_t;
> +
> +/* STREAM-RESET Extension Section 3.2.5 Add Streams
> + *
> + * This parameter is used by the sender to request that the peer add the
> + * requested number of streams to the association.
> + */
> +typedef struct sctp_add_stream {
> +	sctp_paramhdr_t	param_hdr;
> +	__be32 request_seq;
> +	__be16 num_streams;
> +	__be16 reserved;
> +} __attribute__((packed)) sctp_add_stream_t;
> +
> +typedef enum {
> +	SCTP_STREAM_RESET_NOTHING	= cpu_to_be32(0x00),
> +	SCTP_STREAM_RESET_PERFORMED	= cpu_to_be32(0x01),
> +	SCTP_STREAM_RESET_DENIED	= cpu_to_be32(0x02),
> +	SCTP_STREAM_RESET_WRONG_SSN	= cpu_to_be32(0x03),
> +	SCTP_STREAM_RESET_TRY_LATER	= cpu_to_be32(0x04),
> +	SCTP_STREAM_RESET_BAD_SEQNO	= cpu_to_be32(0x05),
> +} sctp_stream_reset_result_t;
> +

It a bit more logical to put these next to sctp_reset_res as these
indicate possible result values.

-vlad
>  #endif /* __LINUX_SCTP_H__ */

