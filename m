From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 29 Nov 2012 21:07:41 +0000
Subject: Re: [Lksctp-developers] SCTP sysctl /proc/sys/net/sctp/rto_min/initial/max variables
Message-Id: <20121129210741.GB28038@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Nov 29, 2012 at 03:35:37PM -0500, Dilip Daya wrote:
> Hi,
> 
> Testing kernel 3.2.32 x86_64 environment show the sctp sysctl variables:
> 
>  - net.sctp.rto_initial,
>  - net.sctp.rto_min,
>  - net.sctp.rto_max
> 
> are not overriding the hard-coded recommended values of:
> - http://lxr.linux.no/linux+v3.2.34/include/net/sctp/constants.h#L276
> 
> I've confirmed the following values are correct to what I need modified:
>  - /proc/sys/net/sctp/rto_initial
>  - /proc/sys/net/sctp/rto_min
>  - /proc/sys/net/sctp/rto_max
> 
> If I change the hard-coded values and rebuild sctp they take effect. Is
> this an issue on my end or is this a sctp sysctl issue?
> 
> Thanks,
> -DilipD.
> 
Sounds like you created an sctp socket before you changed the sysctl values
above.  You need to change the values before creating the socket, or you need to
use the sockopt interface to change a particular sockets value dynamically after
its been created
Neil

> 
> ------------------------------------------------------------------------------
> Keep yourself connected to Go Parallel: 
> VERIFY Test and improve your parallel project with help from experts 
> and peers. http://goparallel.sourceforge.net
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
> 
