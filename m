From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 09 Jan 2017 02:30:23 +0000
Subject: Re: Problem on SCTP
Message-Id: <CAFXGftKPb-2jBKx7Eh_iDuFdmyD86SCfdSUvQtKNGrOwC1Jwgg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
 <20170106123711.GA15139@hmsreliant.think-freely.org> <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
In-Reply-To: <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

OK. I actually verified the connectivity using SSH to port 22. it
works. so I do not have any idea why it has problem on SCTP.

need more help on this.  is there anyway to enable debug? the version
that I am using is lksctp-tools-1.0.10-7



On Mon, Jan 9, 2017 at 10:08 AM, Sun Paul <paulrbk@gmail.com> wrote:
> Hi
>
> the INIT chunk arrive on the SERVER, but then no response. the
> application that using in SERVER is the same as the other test.
>
> I noticed one thing in Ethernet frame of the incoming packet on the
> SERVER compared to the one captured from the client is the LG bit on
> the source address.
>
> The LG bit is set to 0 on the request packet received in the
> SERVER,but it is 0 from the one originated on the client. willl it be
> the root cause?
>
>
>
> On Fri, Jan 6, 2017 at 8:37 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Fri, Jan 06, 2017 at 05:34:47PM +0800, Sun Paul wrote:
>>> Hi
>>>
>>> I am setting up a lab where the SCTP traffics from  client is passing
>>> through a linux router before reaching to the SCTP server running
>>> LKSCTP.
>>>
>>> The linux router did not change the source address of the client, so
>>> when it arrived to the SCTP server, the source address is the oriingal
>>> one.
>>>
>>> however, I found that there is no response from the SCTP server, any
>>> idea on this?
>>>
>>> if I connect the client directly to the SCTP server, it do not have any issue.
>>>
>>> help pls
>>>
>>> rbk
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Start with a tcpdump on the client and the server and attempt a connection,
>> check to see if the INIT and INIT-ACK chunks are arriving appropriately.
>>
>> Neil
>>
