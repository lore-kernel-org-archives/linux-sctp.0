From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Mon, 12 Aug 2013 12:33:56 +0000
Subject: Re: Socket buffer autotuning
Message-Id: <A3F4D59A-CA2B-4A59-920F-273BC60E4691@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
In-Reply-To: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Aug 12, 2013, at 2:23 PM, Karl Heiss <kheiss@gmail.com> wrote:

> All,
> 
> A recent post to the netdev mailing list made it clear that SCTP
> doesn't support socket buffer autotuning.  All of a sudden, many of
> our benchmarks start to make sense...  Has there been any
> work/investigation to support this?  I suspect that there might be
> some difficulty due to the multihoming nature of SCTP, but I haven't
> taken the time to really investigate this avenue...  Any insight it
> greatly appreciated.
I think some work was already done:
http://heim.ifi.uio.no/michawe/research/projects/new-transport/implementing-sctp-auto-buffer-tuning.html
Not sure about the current status.
I'm CCing Michael as he most likely knows.

Best regards
Michael
> 
> Thanks,
> Karl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

