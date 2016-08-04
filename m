From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 04 Aug 2016 12:36:17 +0000
Subject: Re: [PATCH v3 0/3] sctp_diag: A bunch of fixes for upcoming 'ss' support
Message-Id: <20160804123617.GG2967@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1470305517-31880-1-git-send-email-phil@nwl.cc>
In-Reply-To: <1470305517-31880-1-git-send-email-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Phil Sutter <phil@nwl.cc>
Cc: David Miller <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, Aug 04, 2016 at 12:11:54PM +0200, Phil Sutter wrote:
> The following series contains a number of fixes necessary to make my yet
> unpublished 'ss' support patch functional.
> 
> Changes since v1:
> - Fixed patch 2/3
> - Rebased whole series onto current net-next/master
> 
> Changes since v2:
> - Improved description of patch 2/3
> 
> Phil Sutter (3):
>   sctp: Export struct sctp_info to userspace
>   sctp_diag: Fix T3_rtx timer export
>   sctp_diag: Respect ss adding TCPF_CLOSE to idiag_states
> 

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks!

