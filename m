From: David Miller <davem@davemloft.net>
Date: Mon, 29 Aug 2011 22:15:20 +0000
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
Message-Id: <20110829.181520.933815499847625814.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
	<1314654209.2563.7.camel@edumazet-laptop>
	<1314654681.2563.10.camel@edumazet-laptop>
In-Reply-To: <1314654681.2563.10.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: eric.dumazet@gmail.com
Cc: joe@perches.com, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 29 Aug 2011 23:51:21 +0200

> Le lundi 29 ao=FBt 2011 =E0 23:43 +0200, Eric Dumazet a =E9crit :
>=20
>> Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
>> message, is it ?
>=20
> It currently displays a message without context :
>=20
> vmap allocation for size XXXXXX failed: use vmalloc=3D<size> to increase
> size.
>=20
> So we dont know which part of the kernel asked this allocation.
>=20
> Please dont remove existing error messages after failed vmalloc() calls.

Indeed.

Joe, these vmalloc() and also the __GFP_NOWARN cases will need to be
attended to and this series resubmitted as such.

Thanks.
