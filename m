From: Fabian Bergmark <fabian.bergmark@gmail.com>
Date: Thu, 21 Jul 2016 23:28:41 +0000
Subject: Re: packet->transport->asoc = NULL in sctp_packet_transmit
Message-Id: <CAG=SMqaCM6OqZZ5=aPyE154FsukDwa7z+un1wjYnqD2=oDVbwA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAG=SMqbHGWu8eg4+ufcz5m2zbozjBGnvOPmvkTCMwWZbk5x8fA@mail.gmail.com>
In-Reply-To: <CAG=SMqbHGWu8eg4+ufcz5m2zbozjBGnvOPmvkTCMwWZbk5x8fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I tried using virtual box nat networks but couldn't get it to work. It
seemed like the host answered with ICMP port unreachable on the INIT
ACK.

Regarding multihoming. My setup will be a server with one interface
and a client with several. I was hoping to achieve load balancing. Is
CMP implemented in lksctp? If not, is there anyone working on that? I
read that it's recently implemented in BSD. Is failover implemented in
lksctp?

Both interfaces of the client can reach the server IP. I could maybe
create a secondary interface for the server and force traffic to that
IP on the secondary IF. Is this necessary for failover/CMP to work?


2016-07-21 19:12 GMT+02:00 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
> Please don't top post..
>
> On Thu, Jul 21, 2016 at 02:49:56PM +0200, Fabian Bergmark wrote:
>> Indeed the issue was solved by using virtual machines. The client no
>> longer treats the HEARTBEATS as OOTB.
>
> Ok good.
>
>> My current setup is one VM (the server) which is bridged to my LAN. My
>> router is setup to forward all UDP traffic on port 5000 to the VM.
>> A second VM (the client) has two bridged interfaces (two tethering
>> mobile phones). The client connects to the server via the external IP
>> of the router.
>
> Ok. Yet, why don't you do it with 2 VMs, each with 2 NICs on distinct
> subnets?
>
>> This works fine. However, I noticed that the client only seems to use
>> one interface (probably the one with the lowest metric?). Looking
>> trough the debug log
>> of the client, it only mentions one IP (the one of the lower metric
>> interface). I thought SCTP would use all client interfaces? Is there
>> some configuration to achieve
>
> Take a traffic capture and check INIT and INIT_ACK packets, they will
> contain which addresses the peer is announced.
>
>> this or doesn't SCTP support multi-homing in this setup?
>
> But yeah, as you are doing it, it looks more like multi-path than
> multi-homing and it protects only part of your connection, as there is
> some part of the path that is common to both routes. As I'm
> understanding, both interfaces on the guest have a default route that
> can reach the same IP address of the server.
>
> I couldn't get to a root cause on why but I didn't have much luck with
> this setup either. If you manage to have 2 IPs for each peer, it should
> work.
>
>>
>> 2016-07-20 18:42 GMT+02:00 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
>> > On Wed, Jul 20, 2016 at 05:30:15PM +0200, Fabian Bergmark wrote:
>> >> I'm now working on support for multi-homing. I noticed that when the
>> >> client has multiple interfaces, the client would treat the HEARTBEAT
>> >> sent by the server as ootb and abort. When I tried to compare to the
>> >> vanilla SCTP version I saw the same behavior.
>> >> My setup is a laptop with two network interfaces (192.168.2.64,
>> >> 192.168.2.168) acting as the client, a router (192.168.2.1) that
>> >> forwards protocol 132 to my stationary. My stationary has one
>> >> interface (192.168.2.9). The client connects on the routers external
>> >> IP (178.16.218.41)
>> >
>> > First of all, such setup requires some other adjustments on ip
>> > routes/rules/arp sysctl so you can actually use the two interfaces on
>> > the same subnet, otherwise Linux will end up issuing packets with src
>> > 192.168.2.64 on the interface with 192.168.2.168, or vice-versa. Same
>> > thing will happen on input, as it will reply ARP request on the first
>> > interface to receive the ARP request.
>> >
>> > I'd recommend you to switch to a true multi-homed situation, it's easier
>> > to get right and more alike to real world situations.
>> >
>> > You may even use netns for this, or virtual machines. Both would work.
>> >
>> >> Server log: http://pastebin.com/FE667m6t
>> >> Clientl log: http://pastebin.com/vu2YYkWJ
>> >>
>> >> Is this a bug, and if so, is it fixed in a recent commit? Both
>> >> computers are running recent kernels (client 4.5.4-1 and server
>> >> 4.6.3-1)
>> >
>> > The heartbeat was sent using 192.168.2.9 addr and not the external IP.
>> > Was this address negotiated on INIT handshake? It's the first hit of it
>> > on client log. If you don't bind the socket to a single IP address, it
>> > will use all addresses available on the host.
>> >
>> > Note that, if you are binding the socket to specific interfaces, what I
>> > mentioned in the beginning may also be affecting it, as sctp_rcv() will
>> > enforce that the packet came in through the right interface.
>> >
>> >   Marcelo
>> >
>> >>
>> >> 2016-07-19 16:42 GMT+02:00 Fabian Bergmark <fabian.bergmark@gmail.com>:
>> >> > Thanks. I solved the issue by having a per-transport tunnel.
>> >> >
>> >> > The code can be found here:
>> >> > https://github.com/fabianbergmark/linux-sctp/tree/v4.6-sctp-over-udp/net/sctp
>> >> >
>> >> > As this is the first time i write kernel code, I would really
>> >> > appreciate if someone looked at it.
>> >> > The encapsulation seems to work fine (inspected in wireshark), but I'm
>> >> > not sure if I close/free everything correctly.
>> >> >
>> >> > 2016-07-19 14:31 GMT+02:00 Neil Horman <nhorman@tuxdriver.com>:
>> >> >> On Tue, Jul 19, 2016 at 12:15:47PM +0200, Fabian Bergmark wrote:
>> >> >>> I'm adding experimental support for UDP encapsulation of SCTP packets.
>> >> >>> I got most of if working well. However, I noticed a NULL pointer
>> >> >>> dereference in sctp_packet_transmit as I assumed that
>> >> >>> packet->transport->asoc weren't NULL so I tried to access tunneling
>> >> >>> information that I store in packet->transport->asoc->ep->base. In what
>> >> >>> circumstances is asoc NULL in sctp_packet_transmit?
>> >> >>> --
>> >> >>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> >>> the body of a message to majordomo@vger.kernel.org
>> >> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> >>>
>> >> >>
>> >> >> There may be others, but the case that comes immediately to mind is when you
>> >> >> have an error in the construction of a new association (e.g. a state cookie, or
>> >> >> an abort during setup).  In those cases we call sctp_ootb_pkt_new, which sends a
>> >> >> packet with no assoction associated.
>> >> >>
>> >> >> Neil
>> >> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
