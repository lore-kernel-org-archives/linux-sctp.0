From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 15:39:55 +0000
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
Message-Id: <20200521153955.GA19160@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com> <20200521153729.GB74252@localhost.localdomain>
In-Reply-To: <20200521153729.GB74252@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: David Laight <David.Laight@aculab.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, Christoph Hellwig <hch@lst.de>

On Thu, May 21, 2020 at 12:37:29PM -0300, 'Marcelo Ricardo Leitner' wrote:
> On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> 
> I wish we could split this patch into multiple ones. Like, one for
> each sockopt, but it doesn't seem possible. It's tough to traverse
> trough 5k lines long patch. :-(

I have a series locally that started this, I an try to resurrect and
finish it.
