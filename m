From: Joe Perches <joe@perches.com>
Date: Wed, 30 Oct 2013 15:14:54 +0000
Subject: Re: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
Message-Id: <1383146094.9435.3.camel@joe-AO722>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
	 <1383130252-1515-2-git-send-email-dborkman@redhat.com>
	 <1383141418.12439.76.camel@joe-AO722>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73C8@saturn3.aculab.com>
	 <52711481.8030003@redhat.com>
In-Reply-To: <52711481.8030003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 15:15 +0100, Daniel Borkmann wrote:
> On 10/30/2013 03:10 PM, David Laight wrote:
> >>> +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> >> these could be
> >> +	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> > Or even:
> > #define X(a, b, c, d, e, f) {0x##a, 0x##b, 0x##c, 0x##d, 0x##e. 0x##f}
> > 	X(674bf11d, 38, 542, 0af6d466, d8b6e4c1, f6e93d6c),
> > ...
> > #undef X
> 
> Sure, sounds good to me. We could do that as a follow-up.

I personally don't care for that sort of token-pasting macro
but, <shrug> if you want, I've no real objection either.

