From: Karl Heiss <kheiss@gmail.com>
Date: Fri, 09 Aug 2013 12:39:43 +0000
Subject: Quick failover question
Message-Id: <CAGugRbVL1S1Am7qoz7LK4T3cqpR7-UGXkKvyRxq5AbBrz7tTWA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I happened to be perusing the SCTP code in Linus' tree and noticed
that the following is happening in net/sctp/associola.c,
sctp_assoc_control_transport():

/* Don't inform ULP about transition from PF to
 * active state and set cwnd to 1, see SCTP
 * Quick failover draft section 5.1, point 5
 */
if (transport->state = SCTP_PF) {
    ulp_notify = false;
    transport->cwnd = 1;
}

From the quick failover draft, I see that the cwnd should be 1*MTU.
This doesn't seem correct as other places set the cwnd as:

transport->cwnd = asoc->pathmtu;

Am I missing something or is this just a simplification?

Thanks,
Karl
