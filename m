From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 13 Aug 2013 10:09:31 +0000
Subject: Re: Socket buffer autotuning
Message-Id: <520A05DB.60008@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
In-Reply-To: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 08/12/2013 02:33 PM, Michael Tuexen wrote:
> On Aug 12, 2013, at 2:23 PM, Karl Heiss <kheiss@gmail.com> wrote:
>
>> All,
>>
>> A recent post to the netdev mailing list made it clear that SCTP
>> doesn't support socket buffer autotuning.  All of a sudden, many of
>> our benchmarks start to make sense...  Has there been any
>> work/investigation to support this?  I suspect that there might be
>> some difficulty due to the multihoming nature of SCTP, but I haven't
>> taken the time to really investigate this avenue...  Any insight it
>> greatly appreciated.
> I think some work was already done:
> http://heim.ifi.uio.no/michawe/research/projects/new-transport/implementing-sctp-auto-buffer-tuning.html
> Not sure about the current status.
> I'm CCing Michael as he most likely knows.

Thanks for sharing this link Michael!

I'm currently on vacation, but when I'm back, I'll also take a look
at it and see what we can do with buffer autotuning on Linux. I already
started end of last week to do some experimenting.
