From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 19 Jan 2011 08:17:07 +0000
Subject: Re: [PATCH] sctp: user perfect name for Delayed SACK Timer option
Message-Id: <4D369E03.2000109@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D3693CA.40508@cn.fujitsu.com> <20110118.233932.91327830.davem@davemloft.net>
In-Reply-To: <20110118.233932.91327830.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

David Miller wrote, at 01/19/2011 03:39 PM:
> From: Shan Wei <shanwei@cn.fujitsu.com>
> Date: Wed, 19 Jan 2011 15:33:30 +0800
>=20
>> The option name of Delayed SACK Timer should be SCTP_DELAYED_SACK,
>> not SCTP_DELAYED_ACK.
>>
>> Reference:
>> 8.1.19.  Get or Set Delayed SACK Timer (SCTP_DELAYED_SACK)
>> =EF=BC=88http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-25)
>>
>>
>> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
>=20
> You can't make this change, you'll break applications using the
> existing definition.

No documents guide user to use SCTP_DELAYED_ACK option.
I double that there is no applications using this option.

If, there be. How about keeping this be concomitant with SCTP_DELAYED_SACK?

--=20
Best Regards
-----
Shan Wei
