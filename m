From: "Boiteux Frederic" <fboiteux@prosodie.com>
Date: Mon, 01 Dec 2014 17:27:48 +0000
Subject: RE: sctp with multi-homing : PEER_ADDR_CHANGE event for each address ?
Message-Id: <B8F3375A902A0648BD5D9A5ADDE687B005625E57@cadine.france.prosodie.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
In-Reply-To: <B8F3375A902A0648BD5D9A5ADDE687B00555F41F@cadine.france.prosodie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

   Hello Michael,

> You get only a PEER_ADDR_CHANGE notification, if the status of a peer add=
ress changes.
> For example from unconfirmed to confirmed. If you call connect(addr), the=
 addr is already confirmed. So you don't get a PEER_ADDR_CHANGE notificatio=
n.

I don't use connect(addr), but the message -oriented ' sctp_sendmsg()' func=
tion with one target address... And then I=A0get a COMM_UP when the corresp=
onding association is going up.   On the receiving host, I get the COMM_UP =
notification with the message...

	Fred.

