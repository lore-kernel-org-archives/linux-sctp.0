From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 06 Jun 2015 12:55:33 +0000
Subject: Re: [PATCH] sctp: Simplify and make the function sctp_assoc_lookup_laddr bool
Message-Id: <20150606125533.GB6438@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1433526062-2364-1-git-send-email-xerofoify@gmail.com>
 <20150605191610.GC29877@hmsreliant.think-freely.org>
 <55721B11.9020303@gmail.com>
In-Reply-To: <55721B11.9020303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrej Manduch <amanduch@gmail.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 05, 2015 at 05:56:33PM -0400, Andrej Manduch wrote:
> Hi Neil,
> 
>   I would like to kindly ask you to always put full patch in reply when
> you are replying to Nicks patch. Because he's banned from vger and only
> people on cc are able to see his patches and this is only way for rest
> of us to see what is in his patch.
> 
>   Thanks.
Sure, though that begs the question, why is he banned from vger?  Is it his
gmail address, or something more directed?

Neil

> 
> On 06/05/2015 03:16 PM, Neil Horman wrote:
> >> This makes the function sctp_assoc_lookup_laddr bool due to it
> >> only returning either one or zero as its return value. Further
> >> more this function can we simplified to return the if statement
> >> as part of this function directly and thus remove the no longer
> >> required if statement due to this function now being declared
> >> as bool.
> >> 
> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> 
> -- 
> Kind regards,
> b.
> 
