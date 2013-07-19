From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 19 Jul 2013 10:55:26 +0000
Subject: Re: UDP encapsulation of SCTP packages
Message-Id: <20130719105526.GA12938@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAG=SMqaUdvB_ducuzbcFE0XtjP7vdi5ZRSB8mrua3yuZebbN+g@mail.gmail.com>
In-Reply-To: <CAG=SMqaUdvB_ducuzbcFE0XtjP7vdi5ZRSB8mrua3yuZebbN+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Jul 18, 2013 at 08:47:09PM +0200, Fabian Bergmark wrote:
> Im working on implementing UDP encapsulation of SCTP packages.
> 
> I have tried to implement  the encapsulation/decapsulation in a way
> that is transparent to the logic of the current implementation.
> 
> Currently I'am able to send and recieve data over localhost or over
> intranet. However, when trying to communicate over NAT I ran in to
> problems. Because of port remapping of the UDP source port I included
> as a final step to update the source port of the SCTP header and
> recalculate the checksum.
> 
> This however, causes a kernel panic somewhere between receiving the
> UDP packet and replying the INIT_ACK, that I am unable to understand.
> Is there anything, besides the source port and checksum in the SCTP
> header that needs to be updated?
> 
> I have included a packet capture of the INIT-packages that causes the panic.
> 
> As I am new to kernel development, general advice on how to debug this
> issue is appreciated.
> 
> -- Fabian Bergmark

The backtrace of the panic would be useful here, please.
Regards
Neil

