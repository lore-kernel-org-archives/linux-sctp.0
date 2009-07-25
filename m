From: "Doug Graham" <dgraham@nortel.com>
Date: Sat, 25 Jul 2009 02:09:53 +0000
Subject: Do piggybacked ACKs work?
Message-Id: <20090725020953.GA17581@nortel.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I have a little test that simply has a client send 32 bytes of data to
server, which then replies back with the same data.  What doesn't look
right to me is that I never see piggybacked ACKs.  I see the client
send 32 bytes, then the server reply in a packet containing a single
DATA chunk of 32 bytes, and then 200ms later both SACKs are sent.

Looking at the code in net/sctp/output.c I see this:

        /* If sending DATA and haven't aleady bundled a SACK, try to
         * bundle one in to the packet.
         */
        if (sctp_chunk_is_data(chunk) && !pkt->has_sack &&
            !pkt->has_cookie_echo) {
                if (asoc->a_rwnd > asoc->rwnd)
                    <append the SACK chunk to the DATA>

The test that is failing is the "a_rwnd > rwnd" test, and I don't
understand that test at all.  As far as I know, a_rwnd is the last value
of rwnd that was advertised to the peer, and rwnd is the current receive
window.  What's happening is that after the association has settled,
a_rwnd and rwnd are equal.  The client then sends 32 bytes to the peer
SCTP on the server.  The server SCTP receives these 32 bytes and decreases
its rwnd.  Then the userspace server process reads the 32 bytes from the
socket, thus freeing up the buffer space, causing SCTP to increase rwnd back
to where it was initially.  When the server process echoes the data,
SCTP constructs a DATA chunk and then runs the above code to see whether
it needs to append a SACK.  But since rwnd is no longer less than a_rwnd,
no SACK is sent.

I think this logic is wrong.  I don't think the decision as to whether
or not to piggyback a SACK on a DATA packet should have anything to do
with the receive window.  If there is unacknowledged data, then the
SACK should be sent, regardless of the state of the receive window.
Am I right about this?

Thanks,
Doug.
