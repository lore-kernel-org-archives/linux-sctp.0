From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Sun, 20 Feb 2011 03:07:37 +0000
Subject: Re: [PATCH][RFC] sctp: fix reporting of unknown parameters
Message-Id: <4D608579.7000900@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110217231208.GA28281@midget.suse.cz>
In-Reply-To: <20110217231208.GA28281@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Hi vald:

Vladislav Yasevich wrote, at 02/18/2011 10:43 PM:
> Hi Jiri
> 
> I agree.  Good catch.  If we can not add the error header to that packet, then we definitely
> should not be adding the error payload either.

I also agree this part.
 
> We also don't want to abort as Shan Wei suggested.  It is allowed, when exceeding the MTU to
> drop errors that would not otherwise fit into the packet.  It just may so happen that we
> can report subsequent unknown parameters, but not this one in particular.

RFC said that about Parameter Types' encode:
3.2.1.  Optional/Variable-Length Parameter Format
      11 -  Skip this parameter and continue processing but report the
            unrecognized parameter in an 'Unrecognized Parameter', as
            described in Section 3.2.2.

and

3.2.2.  Reporting of Unrecognized Parameters

   If the receiver of an INIT chunk detects unrecognized parameters and
   *has to* report them according to Section 3.2.1, it MUST put the
   'Unrecognized Parameter' parameter(s) in the INIT ACK chunk sent in
   response to the INIT chunk.

So, For unrecognized parameter can't fit into the packet, so droping the parameter.
This may not be consistent with the RFC.

If i have missed something, please tell me. Thanks.

> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> -vlad
> 
> 
> 
> 


-- 

Best Regards
-----
Shan Wei
