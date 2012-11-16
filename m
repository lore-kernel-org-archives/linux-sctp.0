From: Thomas Graf <tgraf@suug.ch>
Date: Fri, 16 Nov 2012 21:47:42 +0000
Subject: Re: [PATCH v2 net-next] sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STA
Message-Id: <20121116214742.GH10831@casper.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1352991680-12289-1-git-send-email-michele@acksyn.org>
 <20121116163922.GA9722@hmsreliant.think-freely.org>
In-Reply-To: <20121116163922.GA9722@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Michele Baldessari <michele@acksyn.org>, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>

On 11/16/12 at 11:39am, Neil Horman wrote:
> Yes, I think this is good, I still don't like the idea of having to do these via
> an ioctl, but I suppose it fits well enough.

I'm with you on this. I have started scribbling notes on paper for
a netlink based stats retriever. We should discuss this at some
point making sure we get everyone on board with interests in this
and solve this nice and clean for everyone to enjoy.

I guess the ioctl is the best we can do as long as we don't have
the above.
