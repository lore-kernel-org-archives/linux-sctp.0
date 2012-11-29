From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 29 Nov 2012 20:49:52 +0000
Subject: Re: SCTP sysctl /proc/sys/net/sctp/rto_min/initial/max variables
Message-Id: <50B7CA70.9070409@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1354221337.6915.107.camel@pro6455b.example.com>
In-Reply-To: <1354221337.6915.107.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 11/29/2012 03:35 PM, Dilip Daya wrote:
> Hi,
>
> Testing kernel 3.2.32 x86_64 environment show the sctp sysctl variables:
>
>   - net.sctp.rto_initial,
>   - net.sctp.rto_min,
>   - net.sctp.rto_max
>
> are not overriding the hard-coded recommended values of:
> - http://lxr.linux.no/linux+v3.2.34/include/net/sctp/constants.h#L276
>
> I've confirmed the following values are correct to what I need modified:
>   - /proc/sys/net/sctp/rto_initial
>   - /proc/sys/net/sctp/rto_min
>   - /proc/sys/net/sctp/rto_max
>
> If I change the hard-coded values and rebuild sctp they take effect. Is
> this an issue on my end or is this a sctp sysctl issue?
>
> Thanks,
> -DilipD.
>

Dilip

I am not sure what you mean...   Are you saying that issuing
	sysctl -w net.sctp.rto_initial0
doesn't change the value of rto_initial shown in /proc/sys/net/sctp?

-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

