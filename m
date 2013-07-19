From: Fabian Bergmark <fabian.bergmark@gmail.com>
Date: Fri, 19 Jul 2013 11:35:26 +0000
Subject: Re: UDP encapsulation of SCTP packages
Message-Id: <CAG=SMqYiJnj6trk2i=M+j2pQZaS0UmavWPZPq0Q-rVegau0hEw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAG=SMqaUdvB_ducuzbcFE0XtjP7vdi5ZRSB8mrua3yuZebbN+g@mail.gmail.com>
In-Reply-To: <CAG=SMqaUdvB_ducuzbcFE0XtjP7vdi5ZRSB8mrua3yuZebbN+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I found that I had made the false assumption that only the source port
had to be changed in the SCTP header. The UDP receive handler thus
passed the endpoint packets that was with the wrong destination port,
which caused the panic. With both source and destination port properly
updated, I am able to send SCTP packets over UDP.
As this will never happen in the original implementation I don't
consider it a bug.

-- Fabian Bergmark

2013/7/19 Neil Horman <nhorman@tuxdriver.com>:
> On Thu, Jul 18, 2013 at 08:47:09PM +0200, Fabian Bergmark wrote:
>> Im working on implementing UDP encapsulation of SCTP packages.
>>
>> I have tried to implement  the encapsulation/decapsulation in a way
>> that is transparent to the logic of the current implementation.
>>
>> Currently I'am able to send and recieve data over localhost or over
>> intranet. However, when trying to communicate over NAT I ran in to
>> problems. Because of port remapping of the UDP source port I included
>> as a final step to update the source port of the SCTP header and
>> recalculate the checksum.
>>
>> This however, causes a kernel panic somewhere between receiving the
>> UDP packet and replying the INIT_ACK, that I am unable to understand.
>> Is there anything, besides the source port and checksum in the SCTP
>> header that needs to be updated?
>>
>> I have included a packet capture of the INIT-packages that causes the panic.
>>
>> As I am new to kernel development, general advice on how to debug this
>> issue is appreciated.
>>
>> -- Fabian Bergmark
>
> The backtrace of the panic would be useful here, please.
> Regards
> Neil
>
