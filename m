From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 05 Jun 2015 19:16:10 +0000
Subject: Re: [PATCH] sctp: Simplify and make the function sctp_assoc_lookup_laddr bool
Message-Id: <20150605191610.GC29877@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1433526062-2364-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1433526062-2364-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicholas Krause <xerofoify@gmail.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 05, 2015 at 01:41:02PM -0400, Nicholas Krause wrote:
> This makes the function sctp_assoc_lookup_laddr bool due to it
> only returning either one or zero as its return value. Further
> more this function can we simplified to return the if statement
> as part of this function directly and thus remove the no longer
> required if statement due to this function now being declared
> as bool.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Acked-by: Neil Horman <nhorman@tuxdriver.com>

