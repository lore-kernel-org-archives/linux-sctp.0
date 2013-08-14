From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Date: Wed, 14 Aug 2013 08:50:03 +0000
Subject: SCTP rwnd issues [0/2]
Message-Id: <520B44BB.9030603@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello!

Basing on the field observations we have carried some tests and figured out that
current algorithm of rwnd calculation has several issues. They occur when small
packets are transmitted and are connected to the "memory pressure" condition.

While we will try to come up with some patches for this, I want to prepare a
basis for the discussion, therefore, I've prepared a couple of test programs.
They intentionally send smallest-possible packets (1 byte) to show the situation
in most-dramatical way. Both of them were tested with LKSCTP of 2.6.32 and
3.10.6 and show absolutely no difference (no surprise -- the same algorithm).

First test case shows, that after "memory pressure" condition, rwnd never
restores to it's initial state if small packets were used to trigger this
condition. The program opens two sockets locally and intentionally fills one
input buffer to trigger memory pressure. After rwnd drops to 0, program reads
everything from the read buffer, but it stays at 985 bytes for the rest of the
time. If the situation repeats, rwnd goes again to 0 and restores to 985, so no
further degradation. But already this decrease has major performance impact. We
found no workaround for this problem.

The problem is that sctp_assoc_rwnd_decrease() detects memory pressure using the
real memory consumption including overhead, but stores current rwnd that was only
accounted for payload:

	if (asoc->rwnd >= len) {
		asoc->rwnd -= len;
		if (over) {
			asoc->rwnd_press += asoc->rwnd;
			asoc->rwnd = 0;
		}


Unfortunately, desired condition will never happen in sctp_assoc_rwnd_increase()
with small packets:

		asoc->rwnd += len;
	}

	/* If we had window pressure, start recovering it
	 * once our rwnd had reached the accumulated pressure
	 * threshold.  The idea is to recover slowly, but up
	 * to the initial advertised window.
	 */
	if (asoc->rwnd_press && asoc->rwnd >= asoc->rwnd_press) {
		int change = min(asoc->pathmtu, asoc->rwnd_press);
		asoc->rwnd += change;
		asoc->rwnd_press -= change;
	}

i.e. asoc->rwnd will grow only up to 985 and will never reach asoc->rwnd_press,
which is about (60000-985) for 1-byte packets.

The program which demonstrates this effect will go as separate email.

Even worse could be the situation if two associations share the same socket.
If rcvbuf_policy=0 (default), both associations will share the same memory
limits. If input queue will be full of packets just for one of the associations
it will trigger memory pressure condition. Then, just one small packet for
second association will also close it's rwnd:

	if (asoc->ep->rcvbuf_policy)
		rx_count = atomic_read(&asoc->rmem_alloc);
	else
		rx_count = atomic_read(&asoc->base.sk->sk_rmem_alloc);

	/* If we've reached or overflowed our receive buffer, announce
	 * a 0 rwnd if rwnd would still be positive.  Store the
	 * the pottential pressure overflow so that the window can be restored
	 * back to original value.
	 */
	if (rx_count >= asoc->base.sk->sk_rcvbuf)
		over = 1;

	if (asoc->rwnd >= len) {
		asoc->rwnd -= len;
		if (over) {
			asoc->rwnd_press += asoc->rwnd;
			asoc->rwnd = 0;
		}

After that, sctp_assoc_rwnd_increase() will try to restore rwnd for second
association, but as there is only one small packet in the input queue,
rwnd will only increase by the payload size of this packet and will stay
at this level forever! In case of 1-byte packet, rwnd of the second association
will stay as low as 1 byte. The workaround for this could be rcvbuf_policy=1,
but the default policy is really dangerous because of above...

The program that demonstrates this will go as third email.

All of the above demonstrates how important is it to adapt TCP rwnd algorithm
also in SCTP... Once again, we will try to come with the patches, but in the
mean time, all ideas, code snippets etc are appreciated!

-- 
Best regards,
Alexander Sverdlin.
