From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 25 May 2016 20:21:59 +0000
Subject: Re: [PATCH net] sctp: sctp_diag should dump sctp socket type
Message-Id: <1464207719.5939.73.camel@edumazet-glaptop3.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
In-Reply-To: <53ebf63eb6de080418949f52d0d3556af2a371e1.1464203668.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, phil@nwl.cc

On Thu, 2016-05-26 at 03:14 +0800, Xin Long wrote:
> Now we cannot distinguish that one sk is a udp or sctp style when
> we use ss to dump sctp_info. it's necessary to dump it as well.
> 
> For sctp_diag, ss support is not officially available, thus there
> are no official users of this yet, so we can add this field in the
> middle of sctp_info without breaking user API.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/sctp.h | 1 +
>  net/sctp/socket.c    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/linux/sctp.h b/include/linux/sctp.h
> index dacb5e7..3a406af 100644
> --- a/include/linux/sctp.h
> +++ b/include/linux/sctp.h
> @@ -761,6 +761,7 @@ struct sctp_info {
>  	__u32	sctpi_s_autoclose;
>  	__u32	sctpi_s_adaptation_ind;
>  	__u32	sctpi_s_pd_point;
> +	__u32	sctpi_s_type;

Well, this is also adding a 4-byte padding at the end of the structure.


Basically, because of the 8-byte alignment cause by the __u64 fields,
adding a single __u32 adds a padding.

Don't you have another u32 info you'd like to publish ?



