From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 04 Dec 2019 18:27:03 +0000
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-Id: <20191204182703.GA5057@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain>
 <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain>
 <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
In-Reply-To: <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Linux NetDev <netdev@vger.kernel.org>, Sean Tranchetti <stranche@codeaurora.org>, Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>, Eric Dumazet <edumazet@google.com>, Linux SCTP <linux-sctp@vger.kernel.org>

On Fri, Nov 29, 2019 at 09:00:19PM +0100, Maciej =C5=BBenczykowski wrote:
...
> I'm of the opinion that SELinux and other security policy modules
> should be reserved for things related to system wide security policy.
> Not for things that are more along the lines of 'functionality'.

Makes sense.

>=20
> Also selinux has 'permissive' mode which causes the system to ignore
> all selinux access controls (in favour of just logging) and this is
> what is commonly used during development (because it's such a pain to
> work with).

Agree, this would be a big problem.
IOW, "you don't have permission to access to this" !=3D "you just can't use=
 this, no
matter what"

FWIW, I rest my case :-)

Thanks,
Marcelo
