From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 27 Apr 2009 13:32:25 +0000
Subject: Re: [PATCH 0/2] Fix two kernel panic after we removed transport by
Message-Id: <49F5B3E9.9090204@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <49F478E6.8020906@cn.fujitsu.com>
In-Reply-To: <49F478E6.8020906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> This patchset fix two kernel panic after we removed transport by
> ASCONF.
> 
> [PATCH 1/2] sctp: fix panic when T2-shutdown timer expire on removed transport
> [PATCH 2/2] sctp: fix panic when T4-rto timer expire on removed transport
> 
> 

Thanks, both applied.

-vlad
