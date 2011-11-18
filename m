From: <yongjun_wei@trendmicro.com.cn>
Date: Fri, 18 Nov 2011 02:31:42 +0000
Subject: RE: Per association statistics
Message-Id: <13B81B9DDD69EC4DB30F266136B6832501D40566@CDCEXMAIL02.tw.trendnet.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <79C4240C13B4C84B910850B96B1B4312035355F2@DEMUEXC035.nsn-intra.net>
In-Reply-To: <79C4240C13B4C84B910850B96B1B4312035355F2@DEMUEXC035.nsn-intra.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



On 11/02/2011 01:34 PM, Kiss, Zoltan (NSN - HU/Budapest) wrote:
> Hi,
> 
> I've recently tried an application on 2.6.34.6, and I had to realize, 
> that SCTP_GET_ASSOC_STATS getsockopt works no longer anymore, like in 
> 2.6.21. I couldn't find any source why it was removed from stack, and 
> is there anything to replace it. I've especially need in/out 
> byte/packet counters, but as I see I can find it on a per process 
> basis, but I need these counters for one specific association/socket. 
> I've only found the old retrans counter, but it also cumbersome as it 
> is available only through /proc filesystem.
> Why was this feature removed, and how can I workaround its lack?

> Not sure.  I remember it being added.  I'll have to check the history to see what happened.

If I am right, nobody has added the SCTP_GET_ASSOC_STATS option for linux,
and no spec has defined this option. It seems that just solaris using this option.
LKSCTP does not support count the in/out bytes by asoc. I think your application
should know the in/out bytes, why you need to get them from kernel?

Regards,
Wei Yongjun

> 
> Regards,
> 
> Zoltan Kiss
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-sctp" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidential and may be subject to copyright or other intellectual property protection. If you are not the intended recipient, you are not authorized to use or disclose this information, and we request that you notify us by reply mail or telephone and delete the original message from your mail system.

