From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Jun 2013 18:24:04 +0000
Subject: Re: [PATCH net-next stable] sctp: fully initialize sctp_outq in sctp_outq_init
Message-Id: <20130612182404.GG13059@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371041959-17697-1-git-send-email-nhorman@tuxdriver.com>
 <51B87CCC.4030200@cogentembedded.com>
In-Reply-To: <51B87CCC.4030200@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, davem@davemloft.net

On Wed, Jun 12, 2013 at 05:51:08PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 12-06-2013 16:59, Neil Horman wrote:
> 
> >In commit 2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86, we modified
> 
>     Please also specify that commit's summary line in parens.
> 
I don't really think thats necessecary, as it just clutters the commit log, but
sure, I can add that in.

> >sctp_outq_teardown to use sctp_outq_init to fully re-initalize the outq
> >structure.  Steve West recently asked me why I removed the q->error = 0
> >initalization from sctp_outq_teardown.  I did so because I was operating under
> >the impression that sctp_outq_init would properly initalize that value for us,
> >but it doesn't.  sctp_outq_init operates under the assumption that the outq
> >struct is all 0's (as it is when called from sctp_association_init), but using
> >it in __sctp_outq_teardown violates that assumption. We should do a memset in
> >sctp_outq_init to ensure that the entire structure is in a known state there
> >instead.
> 
> >Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >Reported-by: "West, Steve (NSN - US/Fort Worth)" <steve.west@nsn.com>
> >CC: Vlad Yasevich <vyasevich@gmail.com>
> >CC: netdev@vger.kernel.org
> >CC: davem@davemloft.net
> >---
> >  net/sctp/outqueue.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> >diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> >index 32a4625..d8b6958 100644
> >--- a/net/sctp/outqueue.c
> >+++ b/net/sctp/outqueue.c
> >@@ -206,6 +206,9 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
> >   */
> >  void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
> >  {
> >+
> 
>    Why empty line here?
I prefer and empty line after the open brace, but I suppose thats not in keeping
with the style of the surrounding code.  I'll remove it.

> 
> >+	memset(q, 0, sizeof(struct sctp_outq));
> >+
> 
>    sizeof(*q) would have been shorter...
sizeof(struct sctp_outq) is in keeping with the way the rest of the module is
coded.

Neil

> 
> WBR, Sergei
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
