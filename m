From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Sep 2016 13:45:20 +0000
Subject: Re: [PATCH net] sctp: fix SSN comparision
Message-Id: <20160916134520.GE3200@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 16, 2016 at 10:40:47AM -0300, Marcelo Ricardo Leitner wrote:
> On Fri, Sep 16, 2016 at 01:33:47PM +0000, David Laight wrote:
> > > > -static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
> > > > +static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
> > > >  {
> > > >  	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
> > > >  }
> > 
> > Does gcc manage to compile that to (s32)((t) - (s)) <= 0 ?
> 
> I have no idea but I have a patch in the works for updating it to this
> form, to be more like time_after(). Will probably post it by next week.

Just for reference, this should be it. Not realy tested yet.

commit b52575533dfefa1908c7bbe35bde0fa8359dd1a3
Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Tue Aug 9 14:45:35 2016 -0300

    sctp: improve how SSN, TSN and ASCONF serial are compared
    
    Make it similar to time_before() macros instead.
    
    This patch also removes SSN_lte as it is not used.

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index bafe2a0ab908..d30cfb6d0480 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -335,19 +335,15 @@ static inline __u16 sctp_data_size(struct sctp_chunk *chunk)
  * Number Arithmetic as defined in [RFC1982] where SERIAL_BITS = 32.
  */
 
-enum {
-	TSN_SIGN_BIT = (1<<31)
-};
+#define TSN_lt(a,b)	\
+	(typecheck(__u32, a) && \
+	 typecheck(__u32, b) && \
+	 ((__s32)((a) - (b)) < 0))
 
-static inline int TSN_lt(__u32 s, __u32 t)
-{
-	return ((s) - (t)) & TSN_SIGN_BIT;
-}
-
-static inline int TSN_lte(__u32 s, __u32 t)
-{
-	return ((s) = (t)) || (((s) - (t)) & TSN_SIGN_BIT);
-}
+#define TSN_lte(a,b)	\
+	(typecheck(__u32, a) && \
+	 typecheck(__u32, b) && \
+	 ((__s32)((a) - (b)) <= 0))
 
 /* Compare two SSNs */
 
@@ -356,36 +352,22 @@ static inline int TSN_lte(__u32 s, __u32 t)
  *  1.6 Serial Number Arithmetic
  *
  * Comparisons and arithmetic on Stream Sequence Numbers in this document
- * SHOULD use Serial Number Arithmetic as defined in [RFC1982] where
- * SERIAL_BITS = 16.
+ * SHOULD use Serial Number Arithmetic as defined in [RFC1982]
  */
-enum {
-	SSN_SIGN_BIT = (1<<15)
-};
-
-static inline int SSN_lt(__u16 s, __u16 t)
-{
-	return ((s) - (t)) & SSN_SIGN_BIT;
-}
-
-static inline int SSN_lte(__u16 s, __u16 t)
-{
-	return ((s) = (t)) || (((s) - (t)) & SSN_SIGN_BIT);
-}
+#define SSN_lt(a,b)		\
+	(typecheck(__u16, a) && \
+	 typecheck(__u16, b) && \
+	 ((__s16)((a) - (b)) < 0))
 
 /*
  * ADDIP 3.1.1
  * The valid range of Serial Number is from 0 to 4294967295 (2**32 - 1). Serial
  * Numbers wrap back to 0 after reaching 4294967295.
  */
-enum {
-	ADDIP_SERIAL_SIGN_BIT = (1<<31)
-};
-
-static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
-{
-	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
-}
+#define ADDIP_SERIAL_gte(a,b)	\
+	(typecheck(__u32, a) && \
+	 typecheck(__u32, b) && \
+	 ((__s32)((b) - (a)) <= 0))
 
 /* Check VTAG of the packet matches the sender's own tag. */
 static inline int
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 72e54a416af6..6612d52599ae 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1747,7 +1747,7 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 {
 	int i;
 	sctp_sack_variable_t *frags;
-	__u16 gap;
+	__u16 gap, blocks;
 	__u32 ctsn = ntohl(sack->cum_tsn_ack);
 
 	if (TSN_lte(tsn, ctsn))
@@ -1767,9 +1767,10 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 
 	frags = sack->variable;
 	gap = tsn - ctsn;
-	for (i = 0; i < ntohs(sack->num_gap_ack_blocks); ++i) {
-		if (TSN_lte(ntohs(frags[i].gab.start), gap) &&
-		    TSN_lte(gap, ntohs(frags[i].gab.end)))
+	blocks = ntohs(sack->num_gap_ack_blocks);
+	for (i = 0; i < blocks; ++i) {
+		if (TSN_lte((__u32)ntohs(frags[i].gab.start), (__u32)gap) &&
+		    TSN_lte((__u32)gap, (__u32)ntohs(frags[i].gab.end)))
 			goto pass;
 	}
 
