From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sat, 14 Dec 2013 17:23:15 +0000
Subject: Re: undetected closed apps
Message-Id: <419FB274-F220-4A0A-A8E8-BD1A6FE1DF3A@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Dec 14, 2013, at 6:21 PM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> On 12/14/13 12:06, Michael Tuexen wrote:
> 
>> What does this mean? Do you call close() or shutdown()? Do you
>> kill the client?
>> 
> 
> Clean shutdown.
> shutdown(fd, SHUT_RDWR);
OK. This should trigger the SHUTDOWN procedure, but leave the socket alive.
Any reason why you can't try close() instead?

Best regards
Michael
> 
> cheers,
> jamal
> 

