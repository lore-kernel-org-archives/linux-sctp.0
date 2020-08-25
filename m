From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Tue, 25 Aug 2020 15:41:27 +0000
Subject: Re: [PATCH 00/13] lib/generic-radix-tree: genradix bug fix and optimisations.
Message-Id: <20200825154127.GB2444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <21289d79b0474811b21ed8478c465159@AcuMS.aculab.com>
In-Reply-To: <21289d79b0474811b21ed8478c465159@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

On Tue, Aug 25, 2020 at 02:52:34PM +0000, David Laight wrote:
> The genradix code is used by SCTP for accessing per-stream data.
> This means there are quite a lot of lookups but the code wasn't
> really optimised at all.

My test box is down for the moment and will bring it on later today or
tomorrow, so I can't test it yet. What should we expect as performance
gains here?

  Marcelo
