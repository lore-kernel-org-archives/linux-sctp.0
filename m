From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 24 Feb 2014 13:24:58 +0000
Subject: RE: [PATCH net-next] loopback: sctp: add NETIF_F_SCTP_CSUM to device features
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D0F6C99F9@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393074113-9922-1-git-send-email-dborkman@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C96DE@AcuExch.aculab.com>
 <530B1F93.4010308@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C9802@AcuExch.aculab.com>
 <530B34D3.2050307@redhat.com>
In-Reply-To: <530B34D3.2050307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Daniel Borkmann' <dborkman@redhat.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Daniel Borkmann
> On 02/24/2014 11:42 AM, David Laight wrote:
> ...
> > I'm sure it shouldn't be that expensive, you are implying that it spent
> > about 70% of the time doing crc32.
> 
> In this scenario, the following perf log I get that shows where cycles
> are being spent on my machine:
> 
>   65.95%       netperf  [kernel.kallsyms]  [k] __crc32c_le

WTF is that function doing!
Even doing the crc naively bit by bit shouldn't manage to use 65%.

Maybe the _le has something to do with it.
Could it be bit-reversing the crc and data bytes all the time?
The packet will (one would hope) want the crc in the same bit-order
as the data, so no bit reversal is needed - just the correct logic
and lookup table.

Which architecture and which version of crc32_le() does your kernel use?
(I'd guess there are several lurking).
Whichever function you are using wants killing.

	David



