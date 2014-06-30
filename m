From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 30 Jun 2014 13:00:57 +0000
Subject: [PATCH net-next 0/3] net: sctp: Optimisations to sctp command queue code
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1726977C@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Network Development <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>

These 3 patches optimise the code that processes sctp's command queue.
(A list of 'tasks' to be performed after the rest of the chunk processing.)

1) Inline all the functions from command.c
2) Remove the memset() calls used to zero a word-sized union.
3) Use pointers instead of array indexes.

The combined changes reduce the code size (amd64) by a few kb.

I'm not 100% convinced that the zeroing done in patch 2 is needed at all.
On BE systems it is likely to generate more code than on LE ones.
In fact it might be best to change the union to only contain 'long' sized
items.

	David



