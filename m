From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 15:17:45 +0000
Subject: Re: EAGAIN
Message-Id: <5F3CF6C8-1FE3-48C5-8E6C-2EC35E0E2FBF@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 16:04, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Michael Tuexen
>> Sent: 07 June 2020 13:48
> ...
>> If you killed the peer, I would assume that there is an SCTP message containing an
>> ABORT chunk in the wire. Is that true? If that is true, you could subscribe to
>> SCTP_ASSOC_CHANGE notification, which should tell you.
> 
> Actually for TCP-style 1-1 connections you must subscribe to
> SCTP_ASSOC_CHANGE.
I guess you are referring to UDP (1-to-many) style sockets.
For 1-to-1 style sockets, the normal error handling should
work, like it does for TCP (returning -1 in a system call
and errno being ETIMEDOUT or ECONNRESET). At least this is
the way intended by the specification and I think Linux
does it that way.

Best regards
Michael
> 
> If you don't and the far end is killed (eg kernel crash) and
> restarts with the same port number pair then you get no
> indication that everything has disconnected and reconnected.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
