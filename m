From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 09 Jan 2017 10:00:36 +0000
Subject: Re: Problem on SCTP
Message-Id: <CAFXGftJkR75OjWOKZhF_jgv_W1ysFky-msMj1asCU5MQMFE43w@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+weUFodkkiY=kgHMX+t4fECQhB+PKg2dBKxCBeU7w7MA@mail.gmail.com>
 <20170106123711.GA15139@hmsreliant.think-freely.org> <CAFXGftLc1Oi9yN-J2UdQxN4MALDhEHieZdGp5JCkOp6Ar+r4Qg@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB025A97E@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi

the linux router just change the destination, so it can arrive on the
the SERVER.

On Mon, Jan 9, 2017 at 5:51 PM, David Laight <David.Laight@aculab.com> wrote:
> From: Sun Paul
>> Sent: 09 January 2017 02:08
>
>> >> I am setting up a lab where the SCTP traffics from  client is passing
>> >> through a linux router before reaching to the SCTP server running
>> >> LKSCTP.
>> >>
>> >> The linux router did not change the source address of the client, so
>> >> when it arrived to the SCTP server, the source address is the oriingal
>> >> one.
>>
>> the INIT chunk arrive on the SERVER, but then no response. the
>> application that using in SERVER is the same as the other test.
>>
>> I noticed one thing in Ethernet frame of the incoming packet on the
>> SERVER compared to the one captured from the client is the LG bit on
>> the source address.
>>
>> The LG bit is set to 0 on the request packet received in the
>> SERVER,but it is 0 from the one originated on the client. willl it be
>> the root cause?
>
> Which addresses are you talking about, and what do you mean by the LG bit?
>
> Is your linux 'router' just routing (ie IP forwarding) or is it doing NAT?
> If it is changing the IP addresses then the addresses inside some SCTP
> chunks also need changing.
>
>         David
>
