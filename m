From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 24 Feb 2014 13:36:03 +0000
Subject: Re: [PATCH net-next] loopback: sctp: add NETIF_F_SCTP_CSUM to device features
Message-Id: <530B4AC3.2040903@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393074113-9922-1-git-send-email-dborkman@redhat.com> <063D6719AE5E284EB5DD2968C1650D6D0F6C96DE@AcuExch.aculab.com> <530B1F93.4010308@redhat.com> <063D6719AE5E284EB5DD2968C1650D6D0F6C9802@AcuExch.aculab.com> <530B34D3.2050307@redhat.com> <063D6719AE5E284EB5DD2968C1650D6D0F6C99F9@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6C99F9@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

On 02/24/2014 02:24 PM, David Laight wrote:
...
> Which architecture and which version of crc32_le() does your kernel use?

It's using slice-by-8 algorithm, and my machine is [only]
a core i7 (x86_64). Apparently, it is not using the crypto
version that is accelerated.

> (I'd guess there are several lurking).
> Whichever function you are using wants killing.
>
> 	David
