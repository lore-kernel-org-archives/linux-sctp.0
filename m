From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 09:51:18 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A716D16.7090908@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
>> This patch corrects the conditions under which a SACK will be piggybacked
>> on a DATA packet.  The previous condition was incorrect due to a
>> misinterpretation of RFC 4960 and/or RFC 2960.  Specifically, the
>> following paragraph from section 6.2 had not been implemented correctly:
>>
>>    Before an endpoint transmits a DATA chunk, if any received DATA
>>    chunks have not been acknowledged (e.g., due to delayed ack), the
>>    sender should create a SACK and bundle it with the outbound DATA
>>    chunk, as long as the size of the final SCTP packet does not exceed
>>    the current MTU.  See Section 6.2.
>>   
>>     
>
> The above text said that SACK is create when the size of the final SCTP
> packet
> does not exceed  the current MTU. With the patch, what will happend?
> If the packet is too large for bundle with SACK, the packet sequence will
> like this:
>
> Endpoint A                         Endpoint B
>
> DATA            ------------->
>                 <-------------     SACK
>                 <-------------     DATA (size52)
> SACK            ------------->
> DATA (size52)------------->
>                 <-------------     SACK
>                 <-------------     DATA (size52)
>
> The behavior is the same as no delayed ack support. So I think
> you also need to check the packet size before append the SACK.

The patch should be like this:

[PATCH] sctp: Do not create SACK chunk if the final packet size exceed current MTU

The sender should create a SACK only if the size of the final SCTP
packet does not exceed the current MTU. Base on RFC 4960:

  6.1.  Transmission of DATA Chunks

    Before an endpoint transmits a DATA chunk, if any received DATA
    chunks have not been acknowledged (e.g., due to delayed ack), the
    sender should create a SACK and bundle it with the outbound DATA
    chunk, as long as the size of the final SCTP packet does not exceed
    the current MTU.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/output.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 94c110d..1aa3c6e 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -274,16 +274,19 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
 	if (retval != SCTP_XMIT_OK)
 		goto finish;
 
-	/* Try to bundle SACK chunk */
-	retval = sctp_packet_bundle_sack(packet, chunk);
-	if (retval != SCTP_XMIT_OK)
-		goto finish;
-
 	psize = packet->size;
 	pmtu  = ((packet->transport->asoc) ?
 		 (packet->transport->asoc->pathmtu) :
 		 (packet->transport->pathmtu));
 
+	/* Try to bundle SACK chunk if not exceed the current MTU */
+	if (psize + chunk_len + sizeof(struct sctp_sack_chunk) <= pmtu) {
+		retval = sctp_packet_bundle_sack(packet, chunk);
+		if (retval != SCTP_XMIT_OK)
+			goto finish;
+		psize = packet->size;
+	}
+
 	too_big = (psize + chunk_len > pmtu);
 
 	/* Decide if we need to fragment or resubmit later. */
-- 
1.6.2.2





