From: David Miller <davem@davemloft.net>
Date: Fri, 01 Oct 2010 00:35:57 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl() (take 3)
Message-Id: <20100930.173557.108787840.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1285725095-9860-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1285725095-9860-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: flameeyes@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Diego Elio Petten=F2 <flameeyes@gmail.com>
Date: Wed, 29 Sep 2010 03:51:35 +0200

> +		rc =3D put_user(amount, (int __user *)arg);
> +	}
> +		break;

Please put the break statement inside of the basic block.

The way you have it here the indentation looks not so nice.
