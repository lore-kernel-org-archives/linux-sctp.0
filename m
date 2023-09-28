Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E549E732C8
	for <linux-sctp@archiver.kernel.org>; Thu, 28 Sep 2023 12:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjI1MRz (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 28 Sep 2023 08:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjI1MRy (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 28 Sep 2023 08:17:54 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C3D139
        for <linux-sctp@vger.kernel.org>; Thu, 28 Sep 2023 05:17:51 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:e207:8adb:af22:7f1e])
        by laurent.telenet-ops.be with bizsmtp
        id rQHp2A00L3w8i7m01QHpbZ; Thu, 28 Sep 2023 14:17:50 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1qlpxN-004mRZ-6w;
        Thu, 28 Sep 2023 14:17:49 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1qlpxl-001OCa-NE;
        Thu, 28 Sep 2023 14:17:49 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] [net-next] sctp: Spelling s/preceeding/preceding/g
Date:   Thu, 28 Sep 2023 14:17:48 +0200
Message-Id: <663b14d07d6d716ddc34482834d6b65a2f714cfb.1695903447.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Fix a misspelling of "preceding".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 08527d882e56ef79..f80208edd6a5c67d 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3303,7 +3303,7 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 
 	/* Process the TLVs contained within the ASCONF chunk. */
 	sctp_walk_params(param, addip) {
-		/* Skip preceeding address parameters. */
+		/* Skip preceding address parameters. */
 		if (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		    param.p->type == SCTP_PARAM_IPV6_ADDRESS)
 			continue;
-- 
2.34.1

