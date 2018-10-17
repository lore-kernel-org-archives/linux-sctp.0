From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 17 Oct 2018 18:00:10 +0000
Subject: Re: [PATCH net] sctp: fix the data size calculation in sctp_data_size
Message-Id: <20181017180010.GH6761@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <c407b682a424f0441d9b9a29ef6296c8e9824b64.1539781887.git.lucien.xin@gmail.com>
In-Reply-To: <c407b682a424f0441d9b9a29ef6296c8e9824b64.1539781887.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Wed, Oct 17, 2018 at 09:11:27PM +0800, Xin Long wrote:
> sctp data size should be calculated by subtracting data chunk header's
> length from chunk_hdr->length, not just data header.
> 
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/sctp/sm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 5ef1bad..9e3d327 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -347,7 +347,7 @@ static inline __u16 sctp_data_size(struct sctp_chunk *chunk)
>  	__u16 size;
>  
>  	size = ntohs(chunk->chunk_hdr->length);
> -	size -= sctp_datahdr_len(&chunk->asoc->stream);
> +	size -= sctp_datachk_len(&chunk->asoc->stream);
>  
>  	return size;
>  }
> -- 
> 2.1.0
> 
