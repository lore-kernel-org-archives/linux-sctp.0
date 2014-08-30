From: David Miller <davem@davemloft.net>
Date: Sat, 30 Aug 2014 03:31:57 +0000
Subject: Re: [PATCH net] net: sctp: fix ABI mismatch through sctp_assoc_to_state helper
Message-Id: <20140829.203157.2160456466066148505.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1409232506-16598-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1409232506-16598-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 28 Aug 2014 15:28:26 +0200

> Since SCTP day 1, that is, 19b55a2af145 ("Initial commit") from lksctp
> tree, the official <netinet/sctp.h> header carries a copy of enum
> sctp_sstat_state that looks like (compared to the current in-kernel
> enumeration):
 ...
> This header was later on also placed into the uapi, so that user space
> programs can compile without having <netinet/sctp.h>, but the shipped
> with <linux/sctp.h> instead.
> 
> While RFC6458 under 8.2.1.Association Status (SCTP_STATUS) says that
> sstat_state can range from SCTP_CLOSED to SCTP_SHUTDOWN_ACK_SENT, we
> nevertheless have a what it appears to be dummy SCTP_EMPTY state from
> the very early days.
> 
> While it seems to do just nothing, commit 0b8f9e25b0aa ("sctp: remove
> completely unsed EMPTY state") did the right thing and removed this dead
> code. That however, causes an off-by-one when the user asks the SCTP
> stack via SCTP_STATUS API and checks for the current socket state thus
> yielding possibly undefined behaviour in applications as they expect
> the kernel to tell the right thing.
> 
> The enumeration had to be changed however as based on the current socket
> state, we access a function pointer lookup-table through this. Therefore,
> I think the best way to deal with this is just to add a helper function
> sctp_assoc_to_state() to encapsulate the off-by-one quirk.
> 
> Reported-by: Tristan Su <sooqing@gmail.com>
> Fixes: 0b8f9e25b0aa ("sctp: remove completely unsed EMPTY state")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Oh well, applied and queued up for -stable, thanks!
