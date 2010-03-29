From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 04:11:21 +0000
Subject: Re: connect() hangs after binding to three IP addresses and auth_enable
Message-Id: <4BB02869.4030604@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <001701cacc68$d6bb1390$84313ab0$@com>
In-Reply-To: <001701cacc68$d6bb1390$84313ab0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

George Cheimonidis wrote:
> Hi Vlad!
>
> I have recompiled the 2.6.33 kernel with your debug patch. I have also
> enabled SCTP debugging with with CONFIG_SCTP_DBG_MSG=y.
> You can find the log messages in the attached file. Hope it helps!
>
> Best regards
Hi George

With your description, I can reproduct this problem now.
can your check whether this PATCH can fix this BUG?

[PATCH] sctp: fix to calc the init chunk length correctly

When calc the init chunk length, we should not only calc
the length of parameters, but also plus the parameters
zero padding length, such as AUTH HMACS parameter and
CHUNKS parameter. Without the parameters zero padding
length will cause oops.

Reported-by: George Cheimonidis <gchimon@gmail.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9e73291..c199cc8 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -237,14 +237,14 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		/* Add HMACS parameter length if any were defined */
 		auth_hmacs = (sctp_paramhdr_t *)asoc->c.auth_hmacs;
 		if (auth_hmacs->length)
-			chunksize += ntohs(auth_hmacs->length);
+			chunksize += WORD_ROUND(ntohs(auth_hmacs->length));
 		else
 			auth_hmacs = NULL;
 
 		/* Add CHUNKS parameter length */
 		auth_chunks = (sctp_paramhdr_t *)asoc->c.auth_chunks;
 		if (auth_chunks->length)
-			chunksize += ntohs(auth_chunks->length);
+			chunksize += WORD_ROUND(ntohs(auth_chunks->length));
 		else
 			auth_chunks = NULL;
 
-- 
1.6.5.2




