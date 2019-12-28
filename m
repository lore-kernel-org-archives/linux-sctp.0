From: David Miller <davem@davemloft.net>
Date: Sat, 28 Dec 2019 00:36:13 +0000
Subject: Re: [PATCHv3 net-next] sctp: do trace_sctp_probe after SACK validation and check
Message-Id: <20191227.163613.94954890256147556.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191225082725.1251-1-qdkevin.kou@gmail.com>
In-Reply-To: <20191225082725.1251-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: qdkevin.kou@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Wed, 25 Dec 2019 08:27:25 +0000

> The function sctp_sf_eat_sack_6_2 now performs the Verification
> Tag validation, Chunk length validation, Bogu check, and also
> the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> this patch is to do the trace_sctp_probe after the chunk sanity
> tests, but keep doing trace if the SACK received is out of order,
> for the out-of-order SACK is valuable to congestion control
> debugging.
> 
> v1->v2:
>  - keep doing SCTP trace if the SACK is out of order as Marcelo's
>    suggestion.
> v2->v3:
>  - regenerate the patch as v2 generated on top of v1, and add
>    'net-next' tag to the new one as Marcelo's comments.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>

Applied.
