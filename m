From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 09 May 2008 19:06:57 +0000
Subject: [RFC PATCH] [SCTP] Fast retransmit patches
Message-Id: <1210360020-15853-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

As was previousely discussed, there are multiple problems with SCTP
fast retransmit implementation.

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

The following series fixes all of the above issues.  Please review.

Thanks
-vlad
