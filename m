From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Date: Fri, 06 Mar 2015 17:09:18 +0000
Subject: Re: unexpected notification
Message-Id: <20150306170918.GA2305@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADV_2PSg0XQ9BT6fci=k9zXvzHC2gOp7Q7UEhu80oxG+mXa=yg@mail.gmail.com>
In-Reply-To: <CADV_2PSg0XQ9BT6fci=k9zXvzHC2gOp7Q7UEhu80oxG+mXa=yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Hi D=E1vid,

> Hi,
>=20
> I have written an application which is based an one-to-many sctp applicat=
ion.
> In the first phase I tested my socket which one represents multiple
> associations .
> So I connected to different servers from the same socket with multiple
> calling of connect function. (addresses were different)
> Then I got messages from all servers and it worked fine.
> When I started to answer a to the servers, I mean I extended my code
> with sending, I got SCTP_PARTIAL_DELIVERY_EVENT from servers. It comes
> continuously.
> What can be the reason behind of this?
> I have checked this with messages which can be checked visually and it
> seems to work perfectly.

What do you mean with 'checked visually'? Did you check traffic
captures? If possible, please share a capture (binary).

> It is like the reverse of the first situation, not from different
> servers to one socket, but from one socket to all servers. The later
> one works, I mean the message go well, but there are those
> notifications
>=20
> I am using sctp_sendmsg/recmsg functions.

There isn't many ways to trigger such event, and one of them is when
there is an issue with the association. As far as I understood, you're
having issue with tx path only and it's possible that the traffic
capture will shed some light.

  Marcelo

