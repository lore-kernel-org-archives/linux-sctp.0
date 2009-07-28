From: "Doug Graham" <dgraham@nortel.com>
Date: Tue, 28 Jul 2009 22:49:49 +0000
Subject: Re: Do piggybacked ACKs work?
Message-Id: <20090728224949.GB10007@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090725020953.GA17581@nortel.com>
In-Reply-To: <20090725020953.GA17581@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 28, 2009 at 06:31:08PM -0400, Doug Graham wrote:
> The client just sends a request to the server, and then
> waits for a reply.

Ummm, I lied about this.  In this iteration of my test program,
the client doesn't actually wait for or read the reply.  But that
doesn't affect the analysis, since it's what the server does that
matters here.  Even if the client does wait for and read the reply,
the packets exchanged are exactly the same.

--Doug
