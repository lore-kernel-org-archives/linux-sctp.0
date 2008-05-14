From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 May 2008 14:51:59 +0000
Subject: [RFC PATCH v3] [SCTP] Fast retransmit fixes
Message-Id: <1210776722-28244-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Changes from v2
    * remove the call sctp_list_dequeue() so that we don't change the
      retransmit list if we can't add the chunk to the packet.

    * correctly catch the condition when we have to change the fast_retransmit
      state of the chunk.


Changes from v1
    * correclty clear the fast_rtx hint in the outq structure after fast
      retransmission is done.


Background (ver 1):

1.  We don't handle fast recovery correclty.  We reduce our congestion window
every time a new new chunk has to be retransmitted, which violates the fast
recover specification.

2.  We end up effectively fast retransmitting all of the chunks on the
retransmit queue.  This is because we flush the queue twice, once in
sctp_retransmit() and once in the sctp_outq_sack().  The queue must
be flushed only once so that future retransmissions are subject to cwnd.

3. As Wie found, we don't time-out retransmit a chunk that has been
fast-retransmitted.  This is because a fast-retransmitted chunk may
have been send less then rto ago.  To do proper time-outs, we need
to restart the T3 timer after we fast-retransmit the earliest outstanding
TSN.  Then the timer will be set correctly and T3 retransmissions will
happen.


-vlad
