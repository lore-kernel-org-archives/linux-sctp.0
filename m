From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 13 Feb 2018 12:37:41 +0000
Subject: Re: [PATCHv2 net] sctp: fix some copy-paste errors for file comments
Message-Id: <20180213123741.GC26100@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <d71c6c3b35ae661526aa93ff4404eb77b925725a.1518521353.git.lucien.xin@gmail.com>
In-Reply-To: <d71c6c3b35ae661526aa93ff4404eb77b925725a.1518521353.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Tue, Feb 13, 2018 at 07:29:13PM +0800, Xin Long wrote:
> This patch is to fix the file comments in stream.c and
> stream_interleave.c
> 
> v1->v2:
>   rephrase the comment for stream.c according to Neil's suggestion.
> 
> Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
> Fixes: 0c3f6f655487 ("sctp: implement make_datafrag for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/stream.c            | 2 +-
>  net/sctp/stream_interleave.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index cedf672..f799043 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -6,7 +6,7 @@
>   *
>   * This file is part of the SCTP kernel implementation
>   *
> - * These functions manipulate sctp tsn mapping array.
> + * This file contains sctp stream maniuplation primitives and helpers.
>   *
>   * This SCTP implementation is free software;
>   * you can redistribute it and/or modify it under the terms of
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index 86c26ec..65ac03b 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -3,7 +3,8 @@
>   *
>   * This file is part of the SCTP kernel implementation
>   *
> - * These functions manipulate sctp stream queue/scheduling.
> + * These functions implement sctp stream message interleaving, mostly
> + * including I-DATA and I-FORWARD-TSN chunks process.
>   *
>   * This SCTP implementation is free software;
>   * you can redistribute it and/or modify it under the terms of
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
