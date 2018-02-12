From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Feb 2018 10:30:34 +0000
Subject: [PATCH net] sctp: fix some copy-paste errors for file comments
Message-Id: <f799a5c7adc78c16bed32ac7601453b832f8a554.1518431434.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patch is to fix the file comments in stream.c and
stream_interleave.c

Fixes: a83863174a61 ("sctp: prepare asoc stream for stream reconf")
Fixes: 0c3f6f655487 ("sctp: implement make_datafrag for sctp_stream_interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c            | 2 +-
 net/sctp/stream_interleave.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index cedf672..0850e2a 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -6,7 +6,7 @@
  *
  * This file is part of the SCTP kernel implementation
  *
- * These functions manipulate sctp tsn mapping array.
+ * These functions work for sctp stream basic operation and reconfig.
  *
  * This SCTP implementation is free software;
  * you can redistribute it and/or modify it under the terms of
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 8c7cf8f..c19fd42 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -3,7 +3,8 @@
  *
  * This file is part of the SCTP kernel implementation
  *
- * These functions manipulate sctp stream queue/scheduling.
+ * These functions implement sctp stream message interleaving, mostly
+ * including I-DATA and I-FORWARD-TSN chunks process.
  *
  * This SCTP implementation is free software;
  * you can redistribute it and/or modify it under the terms of
-- 
2.1.0

