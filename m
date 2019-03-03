From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Mar 2019 09:54:55 +0000
Subject: [PATCH net 3/3] sctp: call sctp_auth_init_hmacs() in sctp_sock_migrate()
Message-Id: <0ed481dc54f3d2339dacc370784219fa623a33a6.1551606805.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
 <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
 <408620556c373e59442bf68f97cba3a03ac3267a.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <408620556c373e59442bf68f97cba3a03ac3267a.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

New ep's auth_hmacs should be set if old ep's is set, in case that
net->sctp.auth_enable has been changed to 0 by users and new ep's
auth_hmacs couldn't be set in sctp_endpoint_init().

It can even crash kernel by doing:

  1. on server: sysctl -w net.sctp.auth_enable=1,
                sysctl -w net.sctp.addip_enable=1,
                sysctl -w net.sctp.addip_noauth_enable=0,
                listen() on server,
                sysctl -w net.sctp.auth_enable=0.
  2. on client: connect() to server.
  3. on server: accept() the asoc,
                sysctl -w net.sctp.auth_enable=1.
  4. on client: send() asconf packet to server.

The call trace:

  [  245.280251] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  [  245.286872] RIP: 0010:sctp_auth_calculate_hmac+0xa3/0x140 [sctp]
  [  245.304572] Call Trace:
  [  245.305091]  <IRQ>
  [  245.311287]  sctp_sf_authenticate+0x110/0x160 [sctp]
  [  245.312311]  sctp_sf_eat_auth+0xf2/0x230 [sctp]
  [  245.313249]  sctp_do_sm+0x9a/0x2d0 [sctp]
  [  245.321483]  sctp_assoc_bh_rcv+0xed/0x1a0 [sctp]
  [  245.322495]  sctp_rcv+0xa66/0xc70 [sctp]

It's because the old ep->auth_hmacs wasn't copied to the new ep while
ep->auth_hmacs is used in sctp_auth_calculate_hmac() when processing
the incoming auth chunks, and it should have been done when migrating
sock.

Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 22adb8d..def3335 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8978,6 +8978,16 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	if (err)
 		return err;
 
+	/* New ep's auth_hmacs should be set if old ep's is set, in case
+	 * that net->sctp.auth_enable has been changed to 0 by users and
+	 * new ep's auth_hmacs couldn't be set in sctp_endpoint_init().
+	 */
+	if (oldsp->ep->auth_hmacs) {
+		err = sctp_auth_init_hmacs(newsp->ep, GFP_KERNEL);
+		if (err)
+			return err;
+	}
+
 	/* Move any messages in the old socket's receive queue that are for the
 	 * peeled off association to the new socket's receive queue.
 	 */
-- 
2.1.0
