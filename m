From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat, 22 Feb 2014 11:57:47 +0000
Subject: Re: [PATCH net v2] net: sctp: rework multihoming retransmission path selection to rfc4960
Message-Id: <530890BB.3030005@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1392925866-11084-1-git-send-email-dborkman@redhat.com> <20140222.002707.1190648987229222908.davem@davemloft.net>
In-Reply-To: <20140222.002707.1190648987229222908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, guijianfeng@cn.fujitsu.com

On 02/22/2014 06:27 AM, David Miller wrote:
> This does not apply cleanly to the current net tree, please
> respin.

Oh, I have seen you've already applied it. I thought it would
have been conflict-free as Matija's patch only touched
net/sctp/sm_sideeffect.c. Anyway, thanks for fixing it up and
sorry for any inconvenience.

Thanks,

Daniel

  [1] https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?idL47af4d5eb2c2f78f886079a3920a7078a6f0a0
