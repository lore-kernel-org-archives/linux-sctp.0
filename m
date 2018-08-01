From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 01 Aug 2018 16:33:04 +0000
Subject: [PATCH lksctp-tools] nagle_snd: silence false-positive compiler warning
Message-Id: <6530f05626614250e2c5257356c52d180326147c.1533140085.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

I'm getting:
nagle_snd.c: In function ‘main’:
nagle_snd.c:275:3: warning: ‘strncpy’ output truncated before terminating nul copying 10 bytes from a string of the same length [-Wstringop-truncation]
   strncpy(message+i, "1234567890", 10);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Turns out the code is doing that on purpose. To silence it, lets use
memcpy() instead.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 src/apps/nagle_snd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/apps/nagle_snd.c b/src/apps/nagle_snd.c
index 1fc788d56c6e4dd99e89f73c8eafc829efc76dc5..bc960cca04bbc3d8e22a1757daf5fce7b76a95ce 100644
--- a/src/apps/nagle_snd.c
+++ b/src/apps/nagle_snd.c
@@ -272,7 +272,7 @@ main(int argc, char *argv[])
 	message = test_malloc((size + 1) * sizeof(u_int8_t));
 
 	for(i=0; i + 10 < size; i+= 10)
-		strncpy(message+i, "1234567890", 10);
+		memcpy(message+i, "1234567890", 10);
 	strncpy(message+i, "1234567890", size-i);
 	*(message+size) = 0;
 
-- 
2.17.1

