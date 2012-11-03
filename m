From: David Miller <davem@davemloft.net>
Date: Sat, 03 Nov 2012 18:55:17 +0000
Subject: Re: [PATCH v3] sctp: Clean up type-punning in sctp_cmd_t union
Message-Id: <20121103.145517.1686027994101913314.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1351535533-23402-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1351535533-23402-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 29 Oct 2012 14:32:13 -0400

> Lots of points in the sctp_cmd_interpreter function treat the sctp_cmd_t arg as
> a void pointer, even though they are written as various other types.  Theres no
> need for this as doing so just leads to possible type-punning issues that could
> cause crashes, and if we remain type-consistent we can actually just remove the
> void * member of the union entirely.
> 
> Change Notes:
> 
> v2)
> 	* Dropped chunk that modified SCTP_NULL to create a marker pattern
> 	 should anyone try to use a SCTP_NULL() assigned sctp_arg_t, Assigning
> 	 to .zero provides the same effect and should be faster, per Vlad Y.
> 
> v3)
> 	* Reverted part of V2, opting to use memset instead of .zero, so that
> 	 the entire union is initalized thus avoiding the i164 speculative load
> 	 problems previously encountered, per Dave M..  Also rewrote
> 	 SCTP_[NO]FORCE so as to use common infrastructure a little more
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com

Applied, thanks.
