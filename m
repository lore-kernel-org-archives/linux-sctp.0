From: "Yla-Outinen, Petteri (NSN - FI/Espoo)" <petteri.yla-outinen@nsn.com>
Date: Wed, 14 Aug 2013 10:38:07 +0000
Subject: RE: SCTP rwnd issues [0/2]
Message-Id: <40C3BCF85BC0F44FAEA60320BCFDC3AF0F81C6DA@DEMUMBX006.nsn-intra.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <520B44BB.9030603@nsn.com>
In-Reply-To: <520B44BB.9030603@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi.

Problem of the current algorithm is that if pressure hits due to memory allocation limit ( not by user bytes filling a_rwnd ) algorithm stores free portion of receive window to rwnd_press. 

Later when recovery starts it compares bytes read from buffer to rwnd_press, which is doomed to fail as comparison should be made to filled portion.

Below one way to do it with help of new variable rwnd_press_threshold.


Sippet from structs.h which introduces rwnd_press_threshold to assoc structure:

	/* This is the last advertised value of rwnd over a SACK chunk. */
	__u32 a_rwnd;

	/* Number of bytes by which the rwnd has slopped.  The rwnd is allowed
	 * to slop over a maximum of the association's frag_point.
	 */
	__u32 rwnd_over;

	/* Keeps treack of rwnd pressure.  This happens when we have
	 * a window, but not recevie buffer (i.e small packets).  This one
	 * is releases slowly (1 PMTU at a time ).
	 */
	__u32 rwnd_press;
	__u32 rwnd_press_threshold; /*PYO*/



Increase and decrease functions using rwnd_press_threshold.

/* Increase asoc's rwnd by len and send any window update SACK if needed. */
void sctp_assoc_rwnd_increase(struct sctp_association *asoc, unsigned len)
{
	struct sctp_chunk *sack;
	struct timer_list *timer;

	if (asoc->rwnd_over) {
		if (asoc->rwnd_over >= len) {
			asoc->rwnd_over -= len;
		} else {
			asoc->rwnd += (len - asoc->rwnd_over);
			asoc->rwnd_over = 0;
		}
	} else {
		asoc->rwnd += len;
	}

	/* If we had window pressure, start recovering it
	 * once our rwnd had reached the accumulated pressure
	 * threshold.  The idea is to recover slowly, but up
	 * to the initial advertised window.
	 */
	if (asoc->rwnd_press_threshold && asoc->rwnd >= asoc->rwnd_press_threshold) {
		int change = min(asoc->pathmtu, asoc->rwnd_press);
		asoc->rwnd += change;
		asoc->rwnd_press -= change;
		if ( asoc->rwnd_press = 0 )
			asoc->rwnd_press_threshold = 0;
	}

	SCTP_DEBUG_PRINTK("%s: asoc %p rwnd increased by %d to (%u, %u) "
			  "- %u\n", __func__, asoc, len, asoc->rwnd,
			  asoc->rwnd_over, asoc->a_rwnd);

	/* Send a window update SACK if the rwnd has increased by at least the
	 * minimum of the association's PMTU and half of the receive buffer.
	 * The algorithm used is similar to the one described in
	 * Section 4.2.3.3 of RFC 1122.
	 */
	if (sctp_peer_needs_update(asoc)) {
		asoc->a_rwnd = asoc->rwnd;
		SCTP_DEBUG_PRINTK("%s: Sending window update SACK- asoc: %p "
				  "rwnd: %u a_rwnd: %u\n", __func__,
				  asoc, asoc->rwnd, asoc->a_rwnd);
		sack = sctp_make_sack(asoc);
		if (!sack)
			return;

		asoc->peer.sack_needed = 0;

		sctp_outq_tail(&asoc->outqueue, sack);

		/* Stop the SACK timer.  */
		timer = &asoc->timers[SCTP_EVENT_TIMEOUT_SACK];
		if (timer_pending(timer) && del_timer(timer))
			sctp_association_put(asoc);
	}
}

/* Decrease asoc's rwnd by len. */
void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned len)
{
	int rx_count;
	int over = 0;

	SCTP_ASSERT(asoc->rwnd, "rwnd zero", return);
	SCTP_ASSERT(!asoc->rwnd_over, "rwnd_over not zero", return);

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
			asoc->rwnd_press_threshold = asoc->base.sk->sk_rcvbuf/2 - asoc->rwnd_press; /* something else than div by 2 shall be used as it may not be forever true that a_rwnd is half of memory allocation limit */
			asoc->rwnd = 0;
		}
	} else {
		asoc->rwnd_over = len - asoc->rwnd;
		asoc->rwnd = 0;
	}
	SCTP_DEBUG_PRINTK("%s: asoc %p rwnd decreased by %d to (%u, %u, %u)\n",
			  __func__, asoc, len, asoc->rwnd,
			  asoc->rwnd_over, asoc->rwnd_press);
}

Br, Petteri

-----Original Message-----
From: linux-sctp-owner@vger.kernel.org [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of ext Alexander Sverdlin
Sent: Wednesday, August 14, 2013 11:50 AM
To: linux-sctp@vger.kernel.org
Cc: Glavinic-Pecotic, Matija (EXT-Other - DE/Ulm)
Subject: SCTP rwnd issues [0/2]

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
--
To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
