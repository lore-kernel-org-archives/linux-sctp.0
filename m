From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 08 Sep 2017 17:04:18 +0000
Subject: Re: Multiple connections from the same source address.
Message-Id: <20FAF522-F247-4698-8244-8074C45A0F2F@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD0071271@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 8. Sep 2017, at 17:42, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Michael Tuexen
>> Sent: 08 September 2017 16:29
> ..
>> OK, I see. I just double checked. If Linux follows RFC 6458,
>> it should be possible to do
>> fd = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
>> setsockopt(fd, IPPROTO_SCTP, SCTP_REUSE_PORT, &on, sizeof(int));
>> and then call bind().
>> 
>> I can run this kind of program on FreeBSD multiple times in
>> parallel, each one talking to a different end-point.
>> I'm not sure if Linux supports SCTP_REUSE_PORT.
> 
> Are you binding to a local address as well as a port?
Yes. In the test program I wrote, I was binding to a public
IPv4 address. But again: This was a userland program on FreeBSD.
Just to make sure that something you want to do should work, if
the SCTP socket API is implemented as specified in RFC 6458...
I have not tested if Linux supports the SCTP_REUSE_PORT socket option.

Best regards
Michael
> 
> 	David
> 

