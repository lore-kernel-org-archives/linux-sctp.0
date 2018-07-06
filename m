From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 06 Jul 2018 16:34:49 +0000
Subject: Re: Possible bug: Association always uses the primary source address in replies
Message-Id: <CADvbK_cKYPjZoHTfB3bbtsN822imKVLnOBu_VVp6MU+H6Q20-A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
In-Reply-To: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Thu, Jul 5, 2018 at 9:17 PM, Martin Schr=C3=B6der <martin@oneiros.de> wr=
ote:
> 2018-07-04 16:19 GMT+02:00 Xin Long <lucien.xin@gmail.com>:
>> This is up to the src IP of your INIT packet, which INIT_ACK from server
>> will use as the primary transport path to select the out route.
>>
>> Can you provide the interface addresses, the INIT and INIT ACK
>> packet info, and the route info on the server? Thanks.
>
> -----------------
> MSrv1> ip rule show
> 0: from all lookup local
> 32764: from 195.219.193.96/27 to 178.23.31.0/24 lookup secondary
> 32765: from 195.219.193.64/27 to 178.23.31.0/24 lookup primary
> 32766: from all lookup main
> 32767: from all lookup default
>
> MSrv1>ip r s t all
> 178.23.31.0/24 via 195.219.193.65 dev eth1 table primary
> 178.23.31.0/24 via 195.219.193.97 dev eth0 table secondary
Oh, I got your problem (thanks for your topo file attached):

You were trying to make it be 4 paths, while it's actually 2 paths to SCTP.
From the server side:

  Path1: local IP A -> 178.23.31.30/25
  Path2: local IP B -> 178.23.31.130/25

Then SCTP server will choose local IP according to your routes and out dev
IPs.

After getting the INIT packet with src IP 178.23.31.130, the server would
use this IP as the dst IP of INIT_ACK packet and look up a route:

  # ip route get 178.23.31.130
  178.23.31.0/24 via 195.219.193.65 dev eth1 table primary [1]

I guess route [1] was chosen, then got the out dev 'eth1' from this route.
And also from eth1, 195.219.193.90 was set as the src IP (195.219.193.90)
of INIT_ACK packet

So it means your 'ip rule' never worked as you expected. (Check the packets
in the pcap file, it's impossible that a lookup would match your ip_rules)


Pls try like this, make it 2 paths by removing Path A2 and Path B1 on your
client route side, the paths left are:

  195.219.193.90/27  <--(195.219.193.65)--> 178.23.31.30/25
  195.219.193.122/27 <--(195.219.193.97)--> 178.23.31.130/25

Then on the server side, change to add the routes:

  # ip route add 178.23.31.30/25  via 195.219.193.65 dev eth1 [a]
  # ip route add 178.23.31.130/25 via 195.219.193.97 dev eth0 [b]

With this setup, it will work like this:

The client tries to connect to server by sending INIT packet to the IP
178.23.31.90 when the route (195.219.193.65/27) is down. After failing,
the client then changes to send it to the IP 178.23.31.122, and it will
arrive the server through the route (195.219.193.97).

After the server gets the INIT packet whose src IP must be
178.23.31.130, and the route [b] with out dev eth0 will be chosen when
looking up a route for INIT_ACK packet, which will get out from eth0
with the src IP 195.219.193.122.

Make sense?
