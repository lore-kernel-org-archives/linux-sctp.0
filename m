From: David Miller <davem@davemloft.net>
Date: Thu, 30 Oct 2014 23:40:37 +0000
Subject: Re: [net-next 1/2] sctp: add transport state in /proc/net/sctp/remaddr
Message-Id: <20141030.194037.985317768601307127.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1414661356-17255-1-git-send-email-michele@acksyn.org>
In-Reply-To: <1414661356-17255-1-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: michele@acksyn.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Michele Baldessari <michele@acksyn.org>
Date: Thu, 30 Oct 2014 10:29:15 +0100

> It is often quite helpful to be able to know the state of a transport
> outside of the application itself (for troubleshooting purposes or for
> monitoring purposes). Add it under /proc/net/sctp/remaddr.
> 
> Signed-off-by: Michele Baldessari <michele@acksyn.org>

Applied.
