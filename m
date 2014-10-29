From: Stephen Hemminger <stephen@networkplumber.org>
Date: Wed, 29 Oct 2014 23:07:38 +0000
Subject: [PATCH net-next] sctp: spelling fixes
Message-Id: <20141029160738.51e79b9a@urahara>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/net/sctp/bind_addr.c	2014-02-12 08:21:56.844855761 -0800
+++ b/net/sctp/bind_addr.c	2014-10-27 20:31:26.734947629 -0700
@@ -212,7 +212,7 @@ int sctp_del_bind_addr(struct sctp_bind_
 }
 
 /* Create a network byte-order representation of all the addresses
- * formated as SCTP parameters.
+ * formatted as SCTP parameters.
  *
  * The second argument is the return value for the length.
  */
--- a/net/sctp/sm_make_chunk.c	2014-10-26 10:43:41.766315430 -0700
+++ b/net/sctp/sm_make_chunk.c	2014-10-27 20:31:04.078833733 -0700
@@ -3153,7 +3153,7 @@ bool sctp_verify_asconf(const struct sct
 				return false;
 			break;
 		default:
-			/* This is unkown to us, reject! */
+			/* This is unknown to us, reject! */
 			return false;
 		}
 	}
@@ -3214,7 +3214,7 @@ struct sctp_chunk *sctp_process_asconf(s
 
 	/* Process the TLVs contained within the ASCONF chunk. */
 	sctp_walk_params(param, addip, addip_hdr.params) {
-		/* Skip preceeding address parameters. */
+		/* Skip preceding address parameters. */
 		if (param.p->type = SCTP_PARAM_IPV4_ADDRESS ||
 		    param.p->type = SCTP_PARAM_IPV6_ADDRESS)
 			continue;
