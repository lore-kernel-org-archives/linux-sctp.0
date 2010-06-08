From: Patrick McHardy <kaber@trash.net>
Date: Tue, 08 Jun 2010 12:16:08 +0000
Subject: Re: [IPTABLES][PATCH 1/2] xt_sctp: Trace DATA chunk that supports
Message-Id: <4C0E3488.6040402@trash.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C0BE408.7070606@cn.fujitsu.com>
In-Reply-To: <4C0BE408.7070606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org

On 06.06.2010 20:08, Shan Wei wrote:
> SACK-IMMEDIATELY extension has defined in: 
> http://tools.ietf.org/html/draft-tuexen-tsvwg-sctp-sack-immediately-03.
> 
> And the latest kernel has added a I flag in DATA chunk to support this extension.
> So let iptables/netfilter can trace it.

Applied, thanks.
