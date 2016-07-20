From: Fabian Bergmark <fabian.bergmark@gmail.com>
Date: Wed, 20 Jul 2016 15:30:15 +0000
Subject: Re: packet->transport->asoc = NULL in sctp_packet_transmit
Message-Id: <CAG=SMqZTByi4H0Sez3vZfR0uuz8caH3D0GvcLJcn7FbaM8Zr8A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAG=SMqbHGWu8eg4+ufcz5m2zbozjBGnvOPmvkTCMwWZbk5x8fA@mail.gmail.com>
In-Reply-To: <CAG=SMqbHGWu8eg4+ufcz5m2zbozjBGnvOPmvkTCMwWZbk5x8fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I'm now working on support for multi-homing. I noticed that when the
client has multiple interfaces, the client would treat the HEARTBEAT
sent by the server as ootb and abort. When I tried to compare to the
vanilla SCTP version I saw the same behavior.
My setup is a laptop with two network interfaces (192.168.2.64,
192.168.2.168) acting as the client, a router (192.168.2.1) that
forwards protocol 132 to my stationary. My stationary has one
interface (192.168.2.9). The client connects on the routers external
IP (178.16.218.41)
Server log: http://pastebin.com/FE667m6t
Clientl log: http://pastebin.com/vu2YYkWJ

Is this a bug, and if so, is it fixed in a recent commit? Both
computers are running recent kernels (client 4.5.4-1 and server
4.6.3-1)

2016-07-19 16:42 GMT+02:00 Fabian Bergmark <fabian.bergmark@gmail.com>:
> Thanks. I solved the issue by having a per-transport tunnel.
>
> The code can be found here:
> https://github.com/fabianbergmark/linux-sctp/tree/v4.6-sctp-over-udp/net/sctp
>
> As this is the first time i write kernel code, I would really
> appreciate if someone looked at it.
> The encapsulation seems to work fine (inspected in wireshark), but I'm
> not sure if I close/free everything correctly.
>
> 2016-07-19 14:31 GMT+02:00 Neil Horman <nhorman@tuxdriver.com>:
>> On Tue, Jul 19, 2016 at 12:15:47PM +0200, Fabian Bergmark wrote:
>>> I'm adding experimental support for UDP encapsulation of SCTP packets.
>>> I got most of if working well. However, I noticed a NULL pointer
>>> dereference in sctp_packet_transmit as I assumed that
>>> packet->transport->asoc weren't NULL so I tried to access tunneling
>>> information that I store in packet->transport->asoc->ep->base. In what
>>> circumstances is asoc NULL in sctp_packet_transmit?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> There may be others, but the case that comes immediately to mind is when you
>> have an error in the construction of a new association (e.g. a state cookie, or
>> an abort during setup).  In those cases we call sctp_ootb_pkt_new, which sends a
>> packet with no assoction associated.
>>
>> Neil
>>
