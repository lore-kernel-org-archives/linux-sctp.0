From: David Miller <davem@davemloft.net>
Date: Wed, 08 Sep 2010 20:09:07 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl() (take 3)
Message-Id: <20100908.130907.48489776.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1283521623-1609-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1283521623-1609-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: flameeyes@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Diego Elio Petten=F2 <flameeyes@gmail.com>
Date: Fri,  3 Sep 2010 15:47:03 +0200

> From: Diego Elio 'Flameeyes' Petten=F2 <flameeyes@gmail.com>
>=20
> This simple patch copies the current approach for SIOCINQ ioctl() from DC=
CP
> into SCTP so that the userland code working with SCTP can use a similar
> interface across different protocols to know how much space to allocate f=
or
> a buffer.
>=20
> Signed-off-by: Diego Elio Petten=F2 <flameeyes@gmail.com>

Applied, thank you.
