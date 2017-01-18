From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 18 Jan 2017 21:49:09 +0000
Subject: Re: Fragmented ordered user messages with inconsistent stream sequence numbers are accepted and deli
Message-Id: <20170118214843.GL3781@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117131311.GF6494@aomx-netbook>
In-Reply-To: <20170117131311.GF6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Jan 18, 2017 at 03:08:14PM +0800, Xin Long wrote:
> On Wed, Jan 18, 2017 at 3:15 AM, Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Jan 18, 2017 at 2:57 AM, Julian Cordes <julian.cordes@gmail.com> wrote:
> >> 2017-01-17 19:49 GMT+01:00 Xin Long <lucien.xin@gmail.com>:
> >>> On Tue, Jan 17, 2017 at 9:13 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
> >>>> When fragmented ordered user messages are sent to the linux kernel user
> >>>> messages with inconsistent stream sequence numbers are accepted and
> >>>> delivered to the application. Take for example an look at the following test case:
> >>>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/error-cases/packet-loss/ordered/ordered-packet-loss-2.pkt
> >>>>
> >>>> Here I first inject two DATA-Chunks with sid/ssn 1/1, 2/1 into the
> >>>> kernel with packetdrill:
> >>>> line 67: +0.0 < sctp: DATA[flgs=E, len16, tsn=2, sid=1, ssn=1,
> >>>> ppid=0]
> >>>> line 69: +0.1 < sctp: DATA[flgs=E, len16, tsn=4, sid=2, ssn=1,
> >>>> ppid=0]
> >>>>
> >>>> After 0.1 seconds i then inject an FORWARD-TSN with cum_tsn=2 bundled
> >>>> with an DATA-Chunk that looks like this:
> >>>> DATA[flgs=B, len16, tsn=3, sid=2, ssn=0, ppid=0]
> >>>>
> >>>> This "looks" like the first segment of the user message where already a
> >>>> fragment (tsn=4) was received. But the ssn-values are  not consistent.
> >>>> The DATA-Chunk with tsn=3 has ssn=0 and the ssn=1 therefore they should
> >>>> be ignored by the IUT and not be delivered to the userland application when
> >>>> calling sctp_recvmsg. Unfortunatly the linux kernel implementation does
> >>>> currently deliver these inconsistent user messages.
> >>> sorry, I may misunderstand you.
> >>>
> >>> after FORWARD-TSN, "DATA[flgs=E, len16, tsn=2, sid=1, ssn=1"
> >>> should be received, then only "sctp: DATA[flgs=E, len16, tsn=4,
> >>> sid=2, ssn=1" is in the queue, then "DATA[flgs=B, len16, tsn=3,
> >>> sid=2, ssn=0, ppid=0]" is processed, these two chunks (tsn=3 and
> >>> tsn=4) should be recvmsg, as their sid are the same and ssn are
> >>> consistent (ssn=0 and ssn=1).
> >>> and your sctp_recvmsg is after above, so it should be right.
> >>>
> >>> did I miss something?
> >>>
> >>>
> >> Shouldnt the ssn be 0 for both DATA-Chunks with sid=2, because they
> >> consistent to the same first fragmented user message of stream with
> >> sid=2?
> > ahh, got you now, will look into it tomorrow,  thanks.
> >
> linux sctp now doesn't yet support "interleave", it believes the chunks /
> fragmenteds from the same msg have continuous / consistent TSNs.
> That's why it can ignore the ssn and only care about tsn and flag
> when reasm fragmenteds.

Interleaving is a feature, but what is happening here is that we are not
validating the ssn in this case, and it allows an attacker to corrupt
the messages once necessary knowledge is obtained (such as knowing
vtag).

line 67: +0.0 < sctp: DATA[flgs=E, len16, tsn=2, sid=1, ssn=1, ppid=0]
line 69: +0.1 < sctp: DATA[flgs=E, len16, tsn=4, sid=2, ssn=1, ppid=0]
After 0.1 seconds i then inject an FORWARD-TSN with cum_tsn=2 bundled
with an DATA-Chunk that looks like this:
DATA[flgs=B, len16, tsn=3, sid=2, ssn=0, ppid=0]

Simplifying, looks like:
                                         v----------.
DATA[flgs=B, len16, tsn=3, sid=2, ssn=0, ppid=0] |
DATA[flgs=E, len16, tsn=4, sid=2, ssn=1, ppid=0] |
                                         ^----------+-- doesn't match

https://tools.ietf.org/html/rfc4960#section-6.9
   2)  The transmitter MUST then assign, in sequence, a separate TSN to
       each of the DATA chunks in the series.  The transmitter assigns
       the same SSN to each of the DATA chunks. ....

A draft, just to illustrate an initial fix for this:
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index aa3624d50278..273abcf631ef 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -419,6 +419,7 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
 	size_t pd_len = 0;
 	struct sctp_association *asoc;
 	u32 pd_point;
+	u16 cssn;
 
 	/* Initialized to 0 just to avoid compiler warning message.  Will
 	 * never be used with this value. It is referenced only after it
@@ -461,10 +462,12 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
 
 			first_frag = pos;
 			next_tsn = ctsn + 1;
+			cssn = cevent->ssn;
 			break;
 
 		case SCTP_DATA_MIDDLE_FRAG:
-			if ((first_frag) && (ctsn = next_tsn)) {
+			if (first_frag && ctsn = next_tsn &&
+			    cssn = cevent->ssn) {
 				next_tsn++;
 				if (pd_first) {
 				    pd_last = pos;
@@ -475,7 +478,8 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_reassembled(struct sctp_ulpq *ul
 			break;
 
 		case SCTP_DATA_LAST_FRAG:
-			if (first_frag && (ctsn = next_tsn))
+			if (first_frag && ctsn = next_tsn &&
+			    cssn = cevent->ssn)
 				goto found;
 			else
 				first_frag = NULL;

Though the real fix is more complicated than this because in such case
the fragments have to be discarded and this is not going to happen with
the above.

> 
> we will improve it when implementing "interleave" soon, thanks for reporting.
> 
> >>>>
> >>>> There are many test-cases that all reproduce this
> >>>> issue. Just take a look at the README at
> >>>> https://github.com/nplab/PR_SCTP_Testsuite/tree/master/forward-tsn/error-cases/packet-loss/ordered.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
