From: David Miller <davem@davemloft.net>
Date: Fri, 15 Oct 2010 16:59:40 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl() (take 3 bis)
Message-Id: <20101015.095940.39172218.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100930.173557.108787840.davem@davemloft.net>
	<1285926965-5130-1-git-send-email-flameeyes@gmail.com>
	<1287152557.465.24.camel@yamato.local>
In-Reply-To: <1287152557.465.24.camel@yamato.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: flameeyes@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Diego Elio Petten=F2 <flameeyes@gmail.com>
Date: Fri, 15 Oct 2010 16:22:37 +0200

> Il giorno ven, 01/10/2010 alle 11.56 +0200, Diego Elio Petten=F2 ha
> scritto:
>>=20
>>=20
>> This simple patch copies the current approach for SIOCINQ ioctl() from
>> DCCP
>> into SCTP so that the userland code working with SCTP can use a
>> similar
>> interface across different protocols to know how much space to
>> allocate for
>> a buffer.=20
>=20
> Any news on getting this one in? Pretty please? :)

I'm pretty sure it's in the net-next-2.6, is it not?
