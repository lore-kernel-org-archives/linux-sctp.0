From: Joe Perches <joe@perches.com>
Date: Mon, 16 Dec 2013 15:03:53 +0000
Subject: Re: [PATCH] SCTP: Reduce log spamming for sctp setsockopt
Message-Id: <1387206233.18217.21.camel@joe-AO722>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org

On Mon, 2013-12-16 at 09:44 -0500, Neil Horman wrote:
> During a recent discussion regarding some sctp socket options, it was noted that
> we have several points at which we issue log warnings that can be flooded at an
> unbounded rate by any user.  Fix this by converting all the pr_warns in the
> sctp_setsockopt path to be pr_warn_ratelimited.

trivial note:

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
[]
> @@ -2579,8 +2579,8 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
[]
> +		pr_warn_ratelimited("Use of struct sctp_assoc_value in delayed_ack socket option deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_sack_info instead\n");
[]
> @@ -2995,8 +2995,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> +		pr_warn_ratelimited("Use of int in maxseg socket option deprecated\n");
[]
> @@ -3253,8 +3253,8 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
[]
> +		pr_warn_ratelimited("Use of int in max_burst socket option deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_assoc_value instead\n");
[]
> @@ -4574,8 +4574,8 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
[]
> +		pr_warn_ratelimited("Use of struct sctp_assoc_value in delayed_ack socket option deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_sack_info instead\n");
[]
> @@ -5219,8 +5219,8 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
[]
> +		pr_warn_ratelimited("Use of int in maxseg socket option deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_assoc_value instead\n");
[]
> @@ -5311,8 +5311,8 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
[]
> +		pr_warn_ratelimited("Use of int in max_burst socket option deprecated\n");
> +		pr_warn_ratelimited("Use struct sctp_assoc_value instead\n");

Perhaps a dedicated "deprecated" warning function
to centralize these?

void _sctp_warn_deprecated(const char *func, const char *from, const char *to);
{
	etc.
}
#define sctp_warn_deprecated(from, to)		\
	_sctp_warn_deprecated(__func__, from, to)

and use

		sctp_warn_deprecated("struct sctp_assoc_value", "struct sctp_sack_info");
		sctp_warn_deprecated("int", "");
		sctp_warn_deprecated("int", "struct sctp_assoc_value");
		sctp_warn_deprecated("struct sctp_assoc_value", "struct sctp_sack_info");
		sctp_warn_deprecated("int", "struct sctp_assoc_value");
		sctp_warn_deprecated("int", "struct sctp_assoc_value");


