From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 08 Apr 2014 11:36:25 +0000
Subject: Re: LKSCTP tuning
Message-Id: <20140408113625.GB26003@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383F7BACEF3F141A39A7AC90F80407E31A774@psmwsonsmbx01.sonusnet.com>
In-Reply-To: <1383F7BACEF3F141A39A7AC90F80407E31A774@psmwsonsmbx01.sonusnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Apr 07, 2014 at 10:14:40PM +0000, Butler, Peter wrote:
> Are the values in /proc/sys/net/sctp/sctp_[rw]mem honored?  Or are they overridden by those in /proc/sys/net/core/[rw]mem_*
> 
sctp_rmem overrides the corresponding core value, sctp_wmem isn't used
currently.

> Furthermore, the kernel documentation states that sctp_wmem has no effect, but makes no such mention for sctp_mem and sctp_rmem.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
