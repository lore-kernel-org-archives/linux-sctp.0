From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 30 Jul 2018 11:54:20 +0000
Subject: Re: [PATCH] github: block pull requests
Message-Id: <20180730115420.GB14421@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4bba9a0dd59fd01eee44d383ee278b4dafdbb830.1532817091.git.marcelo.leitner@gmail.com>
In-Reply-To: <4bba9a0dd59fd01eee44d383ee278b4dafdbb830.1532817091.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sat, Jul 28, 2018 at 07:32:06PM -0300, Marcelo Ricardo Leitner wrote:
> Pull requests evade the reviews we usually do on mailing list. For this
> reason, which is big enough already, lets not accept them anymore.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  .github/pull_request_template.md | 3 +++
>  1 file changed, 3 insertions(+)
>  create mode 100644 .github/pull_request_template.md
> 
> diff --git a/.github/pull_request_template.md b/.github/pull_request_template.md
> new file mode 100644
> index 0000000000000000000000000000000000000000..ba219a68a29e12ea27101f44948c323186dd2c2f
> --- /dev/null
> +++ b/.github/pull_request_template.md
> @@ -0,0 +1,3 @@
> +We don't use pull requests anymore.  Please follow Linux netdev community patch
> +posting standard instead. Post your patches to linux-sctp@vger.kernel.org and
> +they will be very welcomed. Thanks!
> -- 
> 2.17.1
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
