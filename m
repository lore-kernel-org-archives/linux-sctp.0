From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 18 May 2010 10:08:33 +0000
Subject: Re: [PATCH CLEANUP] sctp: fix the comment of  sctp_sf_violation_paramlen()
Message-Id: <4BF26721.8070608@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BF0DD56.70105@cn.fujitsu.com>
In-Reply-To: <4BF0DD56.70105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote, at 05/17/2010 10:30 PM:
>> @@sctp_verify_asconf()
>> 3045                 if (param.v > chunk_end - length ||
>> 3046                     length < sizeof(sctp_paramhdr_t))
>> 3047                         return 0;
>>
> 
> This doesn't check the 'true' length of the parameter.  It makes sure that
> the length specified is at least as long as sctp_paramhdr_t (minimum length),
> and not longer then the end of the chunk.  It makes no assumptions about
> the actual length of the parameter.

Thanks for your exact description.

How about fixing like this?

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 565a690..32e2c34 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4329,8 +4329,9 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
 
 /*
  * Handle a protocol violation when the parameter length is invalid.
- * "Invalid" length is identified as smaller than the minimal length a
- * given parameter can be.
+ * If the length is smaller than the minimum length of a given parameter,
+ * or accumulated length in multi parameters exceeds the end of the chunk,
+ * the length is considered as invalid.
  */
 static sctp_disposition_t sctp_sf_violation_paramlen(
 				     const struct sctp_endpoint *ep,

-- 
Best Regards
-----
Shan Wei


> 
> -vlad
> 
> 
> 


