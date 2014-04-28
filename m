From: David Miller <davem@davemloft.net>
Date: Mon, 28 Apr 2014 03:41:50 +0000
Subject: Re: [PATCH v4 net] net: sctp: Don't transition to PF state when transport has exhausted 'Path.Max.Re
Message-Id: <20140427.234150.128600841189069583.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1398450390-23630-1-git-send-email-kheiss@gmail.com>
In-Reply-To: <1398450390-23630-1-git-send-email-kheiss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kheiss@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Karl Heiss <kheiss@gmail.com>
Date: Fri, 25 Apr 2014 14:26:30 -0400

> Don't transition to the PF state on every strike after 'Path.Max.Retrans'.
> Per draft-ietf-tsvwg-sctp-failover-03 Section 5.1.6:
> 
>    Additional (PMR - PFMR) consecutive timeouts on a PF destination
>    confirm the path failure, upon which the destination transitions to the
>    Inactive state.  As described in [RFC4960], the sender (i) SHOULD notify
>    ULP about this state transition, and (ii) transmit heartbeats to the
>    Inactive destination at a lower frequency as described in Section 8.3 of
>    [RFC4960].
> 
> This also prevents sending SCTP_ADDR_UNREACHABLE to the user as the state
> bounces between SCTP_INACTIVE and SCTP_PF for each subsequent strike.
> 
> Signed-off-by: Karl Heiss <kheiss@gmail.com>

Applied and queued up for -stable, thanks.
