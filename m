From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 18 Jul 2014 17:36:14 +0000
Subject: [PATCH v3 net-next 0/3] net: sctp: Add MSG_MORE support to SCTP
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D17278F54@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
Cc: 'David Miller' <davem@davemloft.net>

If an application has disabled Nagle then it is almost impossible
to get more than one DATA chunk into an ethernet packet even if
the application has more than one data chunk ready to transmit.

This could be fixed by adding an SCTP_CORK socket option - but
using that requires a lot of system calls (and much the same code).
An alternative is to honour MSG_MORE - using it to mean that
another chunk will be sent soon.
(There isn't much point using MSG_MORE to allow a chunk be extended,
sendv() can be used for fragmented data.)

The expectation is that an application will only use MSG_MORE when
is has additional data to send - so it will be followed by a later
sendmsg() with MSG_MORE clear. If the application doesn't do this
the data remains buffered until bundled with a heartbeat chunk.

sendmmsg() can be used to send multiple bundled data chunks in
a single system call (sctp sees them as separate requests).

It is only really necessary to remember the MSG_MORE flag from the last
sendmdsg() call (for each association on a 1-many udp-lke socket).
This does mean that if data (sent with MSG_MORE clear) is unsent
due to flow control, more data is being sent with MSG_MORE set,
and an ack is received that doesn't allow a full packet be sent
that the data won't be sent until a send is done with MSG_MORE clear.

(Similar strange things might also happen if the transmit window is less
than the size of an ethernet packet!)

It might be nicer to have a timer (configurable per-socket) that
would send the final data. But that is for further study.

Because of the way Nagle is implemented in SCTP, the change is very similar
to enabling and disabling Nagle prior to each send - except that the 'first'
packet is also unsent.

The patch is split into 3 parts:
Parts 1 and 2 do not affect the logic.
1) Splits out the 6-clause condition (all of which must be true)
   for Nagle to delay sends into 6 if statements.
   This allows each condition to have its own comment.
2) Renames an internal return value.
3) Renames the 'nodelay' field to 'tx_delay' and defines separate bits for 'Nagle'
   and MSG_MORE (an extra bit could be used for SCTP_CORKED).
   So 'tx_delay' contains the 'reason(s) why a transmit should be delayed'.
   Copy the tx_delay Nagle value into each association.
   Save the MSG_MORE bit from the last send in 'tx_delay', apply much the same
   delay rules as if Nagle were enabled.

Changes for v2:
Parts 1 and 2 added, constants replaced by defines.

Changes for v3:
- Removed 'Partial' from the subject.
- Fix inverted test in part 1.
- Part 2 unchanged.
- Save MSG_MORE on the association, not the socket.
- Don't send a data chunk if MSG_MORE was set and unacked is 0.
  (So the first 2 chunks can be bundled.)

	David


