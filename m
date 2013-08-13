From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 13 Aug 2013 10:47:05 +0000
Subject: Re: Socket buffer autotuning
Message-Id: <520A0EA9.7070706@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
In-Reply-To: <CAGugRbWZMasbRMkt01VU7OOU2N0C_YaE7orkwALPrFa+yBCDPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 08/13/2013 12:23 PM, Michael Welzl wrote:
> On 13. aug. 2013, at 12:09, Daniel Borkmann wrote:
>> On 08/12/2013 02:33 PM, Michael Tuexen wrote:
>>> On Aug 12, 2013, at 2:23 PM, Karl Heiss <kheiss@gmail.com> wrote:
>>>
>>>> All,
>>>>
>>>> A recent post to the netdev mailing list made it clear that SCTP
>>>> doesn't support socket buffer autotuning.  All of a sudden, many of
>>>> our benchmarks start to make sense...  Has there been any
>>>> work/investigation to support this?  I suspect that there might be
>>>> some difficulty due to the multihoming nature of SCTP, but I haven't
>>>> taken the time to really investigate this avenue...  Any insight it
>>>> greatly appreciated.
>>> I think some work was already done:
>>> http://heim.ifi.uio.no/michawe/research/projects/new-transport/implementing-sctp-auto-buffer-tuning.html
>>> Not sure about the current status.
>>> I'm CCing Michael as he most likely knows.
>>
>> Thanks for sharing this link Michael!
>>
>> I'm currently on vacation, but when I'm back, I'll also take a look
>> at it and see what we can do with buffer autotuning on Linux. I already
>> started end of last week to do some experimenting.
>
> Cool! Getting Linux SCTP up to speed would be a wonderful thing!
>
> In case you're interested, Michael Tuexen and I once sat down to create a list of issues that we believe Linux SCTP could have, and it's on these slides:
> http://heim.ifi.uio.no/~michawe/research/publications/caia-feb11.pdf
> no. 28 - 30
>
> Note that this was a few years ago... still, one or two of the issues might still exist?!
>
> Besides, Morten Hustveit has also began with pluggable congestion control in the SCTP in which he also did the auto-buffer tuning work:
> http://heim.ifi.uio.no/~michawe/research/projects/new-transport/implementing-sctp-pluggable-congestion-control.html
>
> but from the look of the graphs at this page, it never really worked. Still, this is probably a cleanly done starting point.

Thanks for all the links.

I will most certainly have a look at those i.e. pluggable cong.control
and auto buffer tuning and also open issues from the slides when I'm
back from vacation!

Cheers,
Daniel
