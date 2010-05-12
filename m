From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 12 May 2010 09:24:25 +0000
Subject: [PATCH CLEANUP] sctp: remove redundant check when walking through
Message-Id: <4BEA73C9.6090909@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


When  pos.v <= (void *)chunk + end - ntohs(pos.p->length) and 
ntohs(pos.p->length) >= sizeof(sctp_paramhdr_t) these two expressions are all true,
pos.v <= (void *)chunk + end - sizeof(sctp_paramhdr_t) *must* be true.

This patch removes this kind of redundant check.
It's same to  _sctp_walk_errors macro.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 include/net/sctp/sctp.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 5915155..a9b4584 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -518,7 +518,6 @@ _sctp_walk_params((pos), (chunk), ntohs((chunk)->chunk_hdr.length), member)
 
 #define _sctp_walk_params(pos, chunk, end, member)\
 for (pos.v = chunk->member;\
-     pos.v <= (void *)chunk + end - sizeof(sctp_paramhdr_t) &&\
      pos.v <= (void *)chunk + end - ntohs(pos.p->length) &&\
      ntohs(pos.p->length) >= sizeof(sctp_paramhdr_t);\
      pos.v += WORD_ROUND(ntohs(pos.p->length)))
@@ -529,7 +528,6 @@ _sctp_walk_errors((err), (chunk_hdr), ntohs((chunk_hdr)->length))
 #define _sctp_walk_errors(err, chunk_hdr, end)\
 for (err = (sctp_errhdr_t *)((void *)chunk_hdr + \
 	    sizeof(sctp_chunkhdr_t));\
-     (void *)err <= (void *)chunk_hdr + end - sizeof(sctp_errhdr_t) &&\
      (void *)err <= (void *)chunk_hdr + end - ntohs(err->length) &&\
      ntohs(err->length) >= sizeof(sctp_errhdr_t); \
      err = (sctp_errhdr_t *)((void *)err + WORD_ROUND(ntohs(err->length))))
--
1.6.3.3 
