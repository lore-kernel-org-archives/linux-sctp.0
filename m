From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Apr 2019 14:23:05 +0000
Subject: Re: [PATCH] sctp_recvmsg man update
Message-Id: <20190430142305.GA15616@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190426193943.30628-1-damir.franusic@gmail.com>
In-Reply-To: <20190426193943.30628-1-damir.franusic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Apr 26, 2019 at 09:39:43PM +0200, damir.franusic@gmail.com wrote:
> From: Damir Franusic <damir.franusic@gmail.com>
> 
> * fixes issue #31
> ---
>  man/sctp_recvmsg.3 | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/man/sctp_recvmsg.3 b/man/sctp_recvmsg.3
> index a7dede1..7854aec 100644
> --- a/man/sctp_recvmsg.3
> +++ b/man/sctp_recvmsg.3
> @@ -44,7 +44,16 @@ message.
>  .I msg_flags
>  is a pointer to a integer that is filled with any message flags like
>  .B MSG_NOTIFICATION or
> -.B MSG_EOR.
> +.B MSG_EOR. 
> +The value of 
> +.I msg_flags 
> +pointer should be initialized to 0 to avoid unexpected behavior;
> +.I msg_flags
> +is also used as an input 
> +.I flags 
> +argument to 
> +.I recvmsg
> +function.
>  .SH "RETURN VALUE"
>  On success,
>  .BR sctp_recvmsg
> -- 
> 2.21.0
> 

Applied, thanks Damir.
