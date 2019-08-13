From: zhengbin <zhengbin13@huawei.com>
Date: Tue, 13 Aug 2019 14:05:50 +0000
Subject: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Message-Id: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: yi.zhang@huawei.com, zhengbin13@huawei.com

If the stream outq is not empty, need to kfree nstr_list.

Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 net/sctp/stream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 2594660..e83cdaa 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -316,6 +316,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 		nstr_list[i] = htons(str_list[i]);

 	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
+		kfree(nstr_list);
 		retval = -EAGAIN;
 		goto out;
 	}
--
2.7.4
