From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jul 2019 12:48:49 +0000
Subject: Re: Support for RFC 6951 (UDP encapsulation for SCTP)
Message-Id: <20190708124849.GA3454@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <044c9c5b-a7a2-effa-7a07-8bea5edcb9c3@patfab.net>
In-Reply-To: <044c9c5b-a7a2-effa-7a07-8bea5edcb9c3@patfab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 08, 2019 at 01:21:20AM +0200, Patrick Schultz wrote:
> Hello all,
> 
> are there already plans to support UDP encapsulation in lksctp-tools according to RFC6951?

Hi,

Not that I'm aware of. As it goes over UDP, you may be able to use
usrsctp instead.

https://github.com/sctplab/usrsctp
https://github.com/sctplab/usrsctp/blob/master/Manual.md#using-udp-encapsulation

  Marcelo
