From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 17 Apr 2008 13:08:35 +0000
Subject: Re: [Lksctp-developers] Dose lksctp suport ECMP route?
Message-Id: <48074BD3.4060803@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Li, Zongjun wrote:
> Hellow expert 
>  
> How dose LKSCTP work when there are ECMP routes? How dose the heart beat
> send?
>  
>       +------------+           *~~~~~~~~~*            +------------+
>       | Endpoint A |          *   Cloud   *           | Endpoint B |
>       |      1.2   +---------+ 1.1<--->3.1 +----------+ 3.2        |
>       |            |         |             |          |            |
>       |      2.2   +---------+ 2.1<--->4.1 +----------+ 4.2        |
>       |            |          *           *           |            |
>       +------------+           *~~~~~~~~~*            +------------+
>     Endpoint A                              Endpoint B
>     Destination     Gateway                 Destination      Gateway
>     ------------------------                -------------------------
>     3.0             1.1                     1.0              3.1
>     3.0             2.1                     1.0              4.1
>     4.0             2.1                     2.0              4.1
>      4.0             1.1                    2.0              3.1
>  

That all depends on how ECMP routes are set up and if there is support for
them.  SCTP itself has no in-depth knowledge of routing.  It simply
uses the routes provided to it by the route table lookups.

So, when associations are being established, we will attempt to lookup up and
cache routes to all the destinations provided in the INIT/INIT-ACK exchange.
The only restriction is that the source address from the routes belongs to a set
of addresses bound by the endpoint.

As a result, it is possible for the kernel to give you routes to different destinations
using the same source.  There has never really been an elegant solution to this,
since brute forcing a route lookup for every bound source address can be extremely
time consuming and there is no guarantee that you would get a better result on
subsequent lookups.

-vlad

> Best Regards,
> Jerry Li
> Field Consulting Engineer
> Wind River Bejing Office
> Tel:+86-10-64398185/86/87/88 Ext. 33
> Fax:+86-10-64398189
> Mobile:+86-13910514391
> zongjun.li@windriver.com
>  
> -------------------------------------------------------------------------
> This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
> Don't miss this year's exciting event. There's still time to save $100. 
> Use priority code J8TL2D2. 
> http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
> 

