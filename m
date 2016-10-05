From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 05 Oct 2016 15:38:49 +0000
Subject: Re: 64000 simultaneous connections
Message-Id: <20161005153849.GA2958@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
In-Reply-To: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Oct 05, 2016 at 11:33:24AM -0400, Al Gambardella wrote:
> Is there a how-to on what linux parameters and resources to check and
> or modify to support 64000 simultaneous SCTP connections.
> 
> Its for a load test scenario. Each connection would only have to
> exchange one message with the remote side then just do keep alives.

Seems at least sysctl net.ipv4.ip_local_port_range on client would have
to be changed, or you would have to have tons of client IP addresses.
Nothing else comes to mind, tough.

  Marcelo

