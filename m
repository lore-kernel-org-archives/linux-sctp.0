From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 20 Mar 2014 19:55:08 +0000
Subject: Re: HB.Max.Burst
Message-Id: <532B479C.5000803@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbWm5=S_6Sf2YQ1=0=AYx40yBTt8+cYcL_3UcDpd8O1rNg@mail.gmail.com>
In-Reply-To: <CAGugRbWm5=S_6Sf2YQ1=0=AYx40yBTt8+cYcL_3UcDpd8O1rNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/20/2014 09:31 AM, Karl Heiss wrote:
> I have a question about the HB.Max.Burst parameter for the LKSCTP
> stack.  I notice that there is no explicit parameter for this value
> and the alternative from RFC 5062 (only one HB per RTT) does not
> appear to be implemented either (see excerpt below).  The only
> limiting factor appears to be max.burst.  Am I missing something
> obvious or should there be some other form of limiting heartbeats to
> mitigate some of the issues outlined in RFC 5062?

Not sure what you mean by "there is no explicit parameter".

There is a system tunable /proc/sys/net/sctp/max_burst that can be
changed.

The value may also be controlled by application through the
SCTP_MAX_BURST socket option.

Additionally, lksctp will only send one HB per RTT.

What do you thinks is missing?

Thanks
-vlad

> 
> 6.3.  Mitigation Option
> 
>    To limit the effectiveness of this attack, the new parameter
>    HB.Max.Burst was introduced in [RFC4960] and an endpoint should:
> 
>    1) not allow very large cookie lifetimes, even if they are requested.
> 
>    2) not use larger HB.Max.Burst parameter values than recommended.
>       Note that an endpoint may decide to send only one Heartbeat per
>       RTT instead of the maximum (i.e., HB.Max.Burst).  An endpoint that
>       chooses this approach will however slow down detection of
>       endpoints camping on valid addresses.
> 
>    3) not use large HEARTBEATs for path confirmation.
> 
> 
> Karl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

