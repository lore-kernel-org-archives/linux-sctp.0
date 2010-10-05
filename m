From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 05 Oct 2010 13:23:30 +0000
Subject: Re: [PATCH] Error in calculation of RTTvar
Message-Id: <4CAB26D2.10007@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20101005063636.4x0vgeefesckcs0s@webmail.tuwien.ac.at>
In-Reply-To: <20101005063636.4x0vgeefesckcs0s@webmail.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/05/2010 12:36 AM, Christian Schoch wrote:
> The problem is inside the calculation of RTTVAR, which could last in very high values for RTO. This wrong result exists when RTT is rising and is bigger than SRTT (the subtraction goes negative).
> With this patch it should be possible to set RTOmin = 1 and the RTO has its minimum of 4 times the clock granularity - if the connection is fast enough like a LAN connection.
>
> abs() takes two long as argument and the output is long.
> srtt, rtt and rttvar are __u32.
>
> Subtraction of two unsigned values results in a value, that is not the same as it would be if the arguments are two signed values and the casted back.
> Without typecasting the result is the one's complement +1 for carry.
>
> This patch should eliminate the problem.

All that missing is a sign off.  Can you add
Signed-off-by: name <email>

to this patch, or reply with your sign-off.

Thanks
-vlad
>
> Schoch Christian
>
> -----------------------------------------------------------------------
>
> --- a/net/sctp/transport.c 2010-10-05 06:04:17.000000000 +0200
> +++ b/net/sctp/transport.c 2010-10-05 06:09:09.000000000 +0200
> @@ -334,7 +334,7 @@
> * 1/8, rto_alpha would be expressed as 3.
> */
> tp->rttvar = tp->rttvar - (tp->rttvar >> sctp_rto_beta)
> - + ((abs(tp->srtt - rtt)) >> sctp_rto_beta);
> + + (((__u32)abs((long)tp->srtt - (long)rtt)) >> sctp_rto_beta);
> tp->srtt = tp->srtt - (tp->srtt >> sctp_rto_alpha)
> + (rtt >> sctp_rto_alpha);
> } else {
>
> ---------------------------------------------
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

