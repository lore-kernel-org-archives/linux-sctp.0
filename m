From: David Miller <davem@davemloft.net>
Date: Thu, 30 Oct 2014 23:40:43 +0000
Subject: Re: [net-next 2/2] sctp: replace seq_printf with seq_puts
Message-Id: <20141030.194043.767828738171481168.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1414661356-17255-1-git-send-email-michele@acksyn.org>
	<1414661356-17255-2-git-send-email-michele@acksyn.org>
In-Reply-To: <1414661356-17255-2-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: michele@acksyn.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Michele Baldessari <michele@acksyn.org>
Date: Thu, 30 Oct 2014 10:29:16 +0100

> Fixes checkpatch warning:
> "WARNING: Prefer seq_puts to seq_printf"
> 
> Signed-off-by: Michele Baldessari <michele@acksyn.org>

Applied.
