From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 19 Jan 2010 02:42:54 +0000
Subject: Question regarding handling of ootb packets
Message-Id: <20100119024254.GA2161@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hey all-
	I'm having a bit of trouble understanding the implementation of
sctp_rcv_ootb.  Specifically I'm wondering why we allow packets checked in
sctp_rcv_ootb with malformed chunks into the receive queue.  For instance, if a
chunk in an ootb packet has a zero length, we break out of the loop and return
0, which lets us eventually call sctp_inq_push to put it on the receive queue,
from which point on we seem to assume the chunk header length field is valid and
correct.  Am I missing something, or is this a bug?

Thanks!
Neil

