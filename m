From: Fan Du <fan.du@windriver.com>
Date: Fri, 11 Jan 2013 07:22:41 +0000
Subject: [PATCH] sctp_xconnect: memory leak when malloc big buffer
Message-Id: <1357888961-1546-1-git-send-email-fan.du@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

CLIENT repeatly call process_ready_sockets, which malloc without free,
so sctp_xconnect exit unexpectly.

Signed-off-by: Fan Du <fan.du@windriver.com>
---
 apps/sctp_xconnect.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/apps/sctp_xconnect.c b/apps/sctp_xconnect.c
index 5874c33..4e33040 100644
--- a/apps/sctp_xconnect.c
+++ b/apps/sctp_xconnect.c
@@ -573,6 +573,7 @@ void process_ready_sockets(int client_socket[], int assoc_num, fd_set *rfds) {
 			}
 		}
 	}
+	free(big_buffer); 
 }
 
 int main(int argc, char *argv[]) {
-- 
1.7.1

