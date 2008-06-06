From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 06 Jun 2008 14:36:21 +0000
Subject: Re: [PATCH] SCTP: Validate initiate tag and chunk type if
Message-Id: <20080606143621.GD2349@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4848E5FE.7080309@cn.fujitsu.com>
In-Reply-To: <4848E5FE.7080309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jun 06, 2008 at 10:31:17AM -0400, Vlad Yasevich wrote:
> Neil Horman wrote:
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> I see that the the above comments relate specifically to ICMP6, but
>> sctp_err_lookup is common between ipv4 and ipv6 sctp.  I assume the same
>
> Neil,  ICMP6 is the just bullet 6 from the ICMP processing, not a reference to
> ICMPv6 protocol.
>
> -vlad
>
Ahh, my fault, that makes much more sense.  Thanks!

Acked-by: Neil Horman <nhorman@tuxdriver.com> 


>> verification requirement is common to v4 and v6 as well (despite the comment).
>> I don't see how it can hurt to check in both cases, but I wanted to be certain.
>>
>> Regards
>> Neil
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
