From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 04 Jul 2018 14:19:13 +0000
Subject: Re: Possible bug: Association always uses the primary source address in replies
Message-Id: <CADvbK_dhUY8QFZXUVFFLhd2TfKwR-6bxm1Qcx7_VbRv8d+mHUA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
In-Reply-To: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Wed, Jul 4, 2018 at 9:09 PM, Martin Schr=C3=B6der <martin@oneiros.de> wr=
ote:
> Hi,
> we have a server and a client. Both are connected to two different networ=
ks.
> Betweeen these four networks there is a complex routing structure.
> Due to an outage we have an outage from the primary interface of the serv=
er
> to all networks of the client; there is still a route with the secondary
> interface.
>
> And then this happens:
> 1. The server is listening, the client is starting.
> 2. Client begins to start Init to the reachable (secondary) interface of
>    the server
> 3. Server answers with Init ACK from his *primary* interface, which of
>    course does not reach the client
>
> Why does the server not answer on his secondary interface when there is
> still a route on this interface to the client but uses the primary interf=
ace
> which has no route?
This is up to the src IP of your INIT packet, which INIT_ACK from server
will use as the primary transport path to select the out route.

Can you provide the interface addresses, the INIT and INIT ACK
packet info, and the route info on the server? Thanks.


>
> Tested with 4.9 and 4.18.rc1.
>
> Best
>    Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
