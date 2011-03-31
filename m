From: Max Matveev <makc@redhat.com>
Date: Thu, 31 Mar 2011 07:49:32 +0000
Subject: Per-chunk overhead calculation too aggressive on send side
Message-Id: <19860.12812.188010.838522@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Folks,

The following bit of code in net/sctp/output.c


sctp_packet_append_data

        /* Update our view of the receiver's rwnd. Include sk_buff overhead
         * while updating peer.rwnd so that it reduces the chances of a
         * receiver running out of receive buffer space even when receive
         * window is still open. This can happen when a sender is sending
         * sending small messages.
         */
        datasize += sizeof(struct sk_buff);
        if (datasize < rwnd)
                rwnd -= datasize;
        else
                rwnd = 0;

adds a whole sk_buff overhead for each data chunk in a packet. On
x86_64 sk_buff is 232 bytes, on an interface with 9K MTU sender which
streams 12 byte packets to a receiver with "default" 64K window is
going to run ouf of "space" before it can fill a single MTU-worth of
bytes. It seems (to me) the overhead calculation is too
aggressive. Does it really assume that each data chunk will get its
own sk_buff on the receive side?

max
