From: "Doug Graham" <dgraham@nortel.com>
Date: Fri, 31 Jul 2009 13:39:43 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <20090731133942.GA7759@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Jul 31, 2009 at 08:59:29AM -0400, Doug Graham wrote:
> This patch seems to do the job.  I applied it in a UML instance and ran
> my server in that.  The client is still unpatched.  I see this:
> 
>  13 2.002638    10.0.0.15    10.0.0.249    DATA (1452 bytes data)
>  14 2.204041    10.0.0.249   10.0.0.15     SACK 
>  15 2.204090    10.0.0.15    10.0.0.249    DATA (2 bytes data)
>  16 2.204428    10.0.0.249   10.0.0.15     SACK 
>  17 2.204822    10.0.0.249   10.0.0.15     DATA (1452 bytes data)
>  18 2.204856    10.0.0.249   10.0.0.15     DATA (2 bytes data)
>  19 2.204890    10.0.0.15    10.0.0.249    SACK 
> 
> So 10.0.0.249 (the patched UML server) did send back-to-back data
> packets without waiting for the SACK,
> 
> I have not applied your MTU patch yet, so the server also sent a
> separate SACK immediately.  This is less than ideal, since it could have
> piggybacked the SACK on the second DATA fragment (frame 18), which has
> lots of room.  I think your MTU patch might accomplish that.

Here's what it looks like after I apply your V2 MTU patch:

 12 2.002750    10.0.0.15      10.0.0.249    DATA 
 13 2.204164    10.0.0.249     10.0.0.15     SACK 
 14 2.204204    10.0.0.15      10.0.0.249    DATA 
 15 2.204926    10.0.0.249     10.0.0.15     DATA 
 16 2.204950    10.0.0.249     10.0.0.15     SACK DATA 
 17 2.204974    10.0.0.15      10.0.0.249    SACK 

Starting to look pretty good!

--Doug
