From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 11 Aug 2017 02:23:49 +0000
Subject: [PATCH net-next 05/14] sctp: remove the typedef sctp_dbg_objcnt_entry_t
Message-Id: <77692e0783b8134d97fd4c15e37cf0b6e4fa643e.1502417340.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1502417340.git.lucien.xin@gmail.com>
 <e15322cc52e110730f2bcb77973222b687717369.1502417340.git.lucien.xin@gmail.com>
 <67dec3f4936413e5bf596dc0ce9be0b9aa15a444.1502417340.git.lucien.xin@gmail.com>
 <5031dc5f40135c4ede57452bc61a1b29dfc76d89.1502417340.git.lucien.xin@gmail.com>
 <58f1f86286c91cf55e9d6eb9395e59e9f1fd4519.1502417340.git.lucien.xin@gmail.com>
In-Reply-To: <58f1f86286c91cf55e9d6eb9395e59e9f1fd4519.1502417340.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to remove the typedef sctp_dbg_objcnt_entry_t, and
replace with struct sctp_dbg_objcnt_entry in the places where it's
using this typedef.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 4 ++--
 net/sctp/objcnt.c          | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index e171d3a..b6d75b3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1992,9 +1992,9 @@ struct sctp_cmsgs {
 };
 
 /* Structure for tracking memory objects */
-typedef struct {
+struct sctp_dbg_objcnt_entry {
 	char *label;
 	atomic_t *counter;
-} sctp_dbg_objcnt_entry_t;
+};
 
 #endif /* __sctp_structs_h__ */
diff --git a/net/sctp/objcnt.c b/net/sctp/objcnt.c
index 105ac33..aeea6da 100644
--- a/net/sctp/objcnt.c
+++ b/net/sctp/objcnt.c
@@ -57,7 +57,7 @@ SCTP_DBG_OBJCNT(keys);
 /* An array to make it easy to pretty print the debug information
  * to the proc fs.
  */
-static sctp_dbg_objcnt_entry_t sctp_dbg_objcnt[] = {
+static struct sctp_dbg_objcnt_entry sctp_dbg_objcnt[] = {
 	SCTP_DBG_OBJCNT_ENTRY(sock),
 	SCTP_DBG_OBJCNT_ENTRY(ep),
 	SCTP_DBG_OBJCNT_ENTRY(assoc),
-- 
2.1.0

