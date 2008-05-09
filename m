From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 09 May 2008 19:14:41 +0000
Subject: [PATCH next-2.6] [SCTP] New SCTP functionality
Message-Id: <1210360481-16599-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net


The following is a short summary of the new SCTP functionality

* Update implementation of SCTP_DELAYD_ACK to conform to the latest
  spec.  We now implement SACK frequency in the number of packets as well
  as time.

* Support the new sctp_connectx() functionality that returns the
  established association id.

* Implement the remote address table OID for the SCTP MIB.

-vlad
