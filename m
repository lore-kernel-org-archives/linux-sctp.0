From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 24 Feb 2014 14:07:16 +0000
Subject: RE: [PATCH net-next] loopback: sctp: add NETIF_F_SCTP_CSUM to device features
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D0F6C9A35@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1393074113-9922-1-git-send-email-dborkman@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C96DE@AcuExch.aculab.com>
 <530B1F93.4010308@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C9802@AcuExch.aculab.com>
 <530B34D3.2050307@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6C99F9@AcuExch.aculab.com>
 <530B4AC3.2040903@redhat.com>
In-Reply-To: <530B4AC3.2040903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Daniel Borkmann' <dborkman@redhat.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Daniel Borkmann
> > Which architecture and which version of crc32_le() does your kernel use?
> 
> It's using slice-by-8 algorithm, and my machine is [only]
> a core i7 (x86_64). Apparently, it is not using the crypto
> version that is accelerated.

I still can't imagine it being that slow.
The sctp code isn't known for its fast paths, although these are
per-message, not per byte I'd have thought they'd still be significant.

Having looked at the code, try compiling with CRC_LE_BITS = 8.
I suspect the much smaller data cache footprint will help, and
the number of instructions won't be that many less (due to all
the shifts).

What may help is to have a 'double shift' table and compute
the crc's of the odd and even bytes separately, then xor them
together at the end. That might improve the dependency chains
and let all the cpu execute more instructions in parallel.

Another improvement is to read the next byte from the buffer
before processing the previous one (possibly with a slight
loop unroll).

As has been noted elsewhere, using a 16 entry lookup table
can be faster than the 256 entry one.
What I don't know is whether the crc32 can be analysed down do
a small number of shifts and xors (crc16 reduces quite nicely)
that might easily execute faster than the lookup table.

	David



