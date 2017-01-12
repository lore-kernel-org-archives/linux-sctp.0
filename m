From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Thu, 12 Jan 2017 10:53:17 +0000
Subject: Re: Problem on SCTP
Message-Id: <4163FC71-3A20-4484-8CDC-FA22D4FA72CF@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170106123711.GA15139@hmsreliant.think-freely.org>
 <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
 <CAFXGftJkR75OjWOKZhF_jgv_W1ysFky-msMj1asCU5MQMFE43w@mail.gmail.com>
 <20170109122408.GA20973@hmswarspite.think-freely.org>
 <CAFXGftLY1ywdRj79RMHW57oLa9_HNEEcUYRAiM=zs6YHHGVFzw@mail.gmail.com>
 <20170109191823.GC20973@hmswarspite.think-freely.org>
 <CAFXGft+C9Wf0Xgq0n-cw+ffeq-maDWoP=6dUV0c=zt80ugZLJQ@mail.gmail.com>
 <20170110143351.GA10195@hmswarspite.think-freely.org>
 <CAFXGft+XA_r+R2hxJU2qYvFJbS+avQ7TTOQ50xkTXm8q8KpDtg@mail.gmail.com>
 <20170111125708.GA1518@hmswarspite.think-freely.org>
 <CAFXGftLSFgPpxD6Oak8h1Y5y11-zXWLj0v4ziMFkjX8eZ4ZJgA@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025F9FD@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB025F9FD@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: Sun Paul <paulrbk@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> On 12 Jan 2017, at 10:51, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Sun Paul [mailto:paulrbk@gmail.com]
>> Sent: 12 January 2017 09:31
>> Let me clear the understanding. below is the flow.
>> 
>> 1. Client sends to Linux Router: 192.168.206.83 -> 192.168.206.56,
>> 2. Linux router sends to SERVER where the source IP is unchanged:
>> 192.168.206.83 -> 192.168.206.66
>> 
>> My question here is why SERVER cannot response this INIT chunk?
> 
> Probably because the IP addresses embedded in the SCTP packet
> don't match the ones in the IP header.
I don't know if it matters on the linux implementation, but it shouldn't.
An SCTP endpoint should consider the source address of the packet containing
the INIT chunk and all the addresses listed in the INIT chunk as valid peer
addresses.

Could we get a .pcap file of the packet containing the INIT chunk captured
at the server? I would expect an INIT-ACK or and ABORT. If that is not sent,
the checksum was wrong or some kind of packet filtering is active on the
server...

Best regards
Michael
> 
> 	David
> 
> N§ēæėrļyúčØbēXŽķĮ§vØ^)Þš{.nĮ+·Ĩ{ąąËi{ayšĘÚë,j­ĒfĢĒ·hāzđŪwĨĒļĒ·Ķj:+vĻwčjØmķĸūŦęįzZ+ųÝĒj"ú!

