From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Jan 2018 09:01:19 +0000
Subject: [PATCH net] sctp: reinit stream if stream outcnt has been change by sinit in sendmsg
Message-Id: <1330acc7e606c50a26e7f972eb9875da82ad8ce9.1516006879.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

After introducing sctp_stream structure, sctp uses stream->outcnt as the
out stream nums instead of c.sinit_num_ostreams.

However when users use sinit in cmsg, it only updates c.sinit_num_ostreams
in sctp_sendmsg. At that moment, stream->outcnt is still using previous
value. If it's value is not updated, the sinit_num_ostreams of sinit could
not really work.

This patch is to fix it by updating stream->outcnt and reiniting stream
if stream outcnt has been change by sinit in sendmsg.

Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9b01e99..15ae018 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1883,8 +1883,14 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		 */
 		if (sinit) {
 			if (sinit->sinit_num_ostreams) {
-				asoc->c.sinit_num_ostreams -					sinit->sinit_num_ostreams;
+				__u16 outcnt = sinit->sinit_num_ostreams;
+
+				asoc->c.sinit_num_ostreams = outcnt;
+				/* outcnt has been changed, so re-init stream */
+				err = sctp_stream_init(&asoc->stream, outcnt, 0,
+						       GFP_KERNEL);
+				if (err)
+					goto out_free;
 			}
 			if (sinit->sinit_max_instreams) {
 				asoc->c.sinit_max_instreams -- 
2.1.0

