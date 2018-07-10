From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Jul 2018 18:01:06 +0000
Subject: Re: Possible bug: Association always uses the primary source address in replies
Message-Id: <CADvbK_cErPTSGSAFtWqdxJ=pX7R6ETE8Yzy9st8MqkOmVsWdPQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
In-Reply-To: <CAP7DCDdyeJZAhthTbPdr1TCnpSO5KTw55S6HzX35J2rgSLUAbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On Mon, Jul 9, 2018 at 7:38 PM, Martin Schr=C3=B6der <martin@oneiros.de> wr=
ote:
> 2018-07-06 18:34 GMT+02:00 Xin Long <lucien.xin@gmail.com>:
>> Make sense?
>
> Yes, but it doesn't make us happy. :-)
>
> So we can get our setup working (but will be able to test that only in
> some weeks).
>
> The biggest problem for us is that we only control one side and can not
> really prevent such a cross connection.
OK, I understand what you really want. But I think it should be
something from the route, like some route's multipath policy that
could detect one route gw failure and change to another gw.
SCTP should not decide the route's out dev according to the
incoming INIT packet only for "INIT_ACK". Sorry about that.

>
> Btw: Why is there a primary address (local) AND a primary peer address
> (remote) if only one path is possible as primary and the local and the
> remote address is fixed?
There's no so-called "a primary local", but only "a primary peer" (remote)
address named "a primary path or transport", the local address is always
selected among the bind_addr_list, but the one also on the outdev of the
route has the higher priority to be used as the src IP of the outgoing
packets like INIT_ACK.

Like, it got the route for the path "178.23.31.130":
  178.23.31.130/25 via 195.219.193.97 dev eth0 [A]

In the bind_addr_list, there are two addrs:
  195.219.193.90, 195.219.193.122

If 195.219.193.122 is on eth0, which is the outdev of route [A],
195.219.193.122 will be select for this path's src IP.
