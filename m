Return-Path: <SRS0=K7oZ=DG=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBFEC47423
	for <linux-sctp@archiver.kernel.org>; Tue, 29 Sep 2020 13:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A0512145D
	for <linux-sctp@archiver.kernel.org>; Tue, 29 Sep 2020 13:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKKUR2ow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgI2Ntq (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730501AbgI2Ntp (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Tue, 29 Sep 2020 09:49:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527CAC061755;
        Tue, 29 Sep 2020 06:49:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so4596807pff.6;
        Tue, 29 Sep 2020 06:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=F9gzu4ux1/gIDa9kBXORz7PWDK9PRGfbQUFqQq4SV/k=;
        b=TKKUR2owYbVnPKq6L/2bqdFncahUX2SllZzrr+291d644txwI6k5PJcACFDEuJChyP
         bgQHIPv1epPp+Coc5axdDjeXhsVvgEhB7mZuJjrUkRcqBYsDsV1BVF8HwQtkw9rgw40E
         MPyLZs/NE9NQePSC8g0I8siYQGBjoO7NAGAQcMen9V4cwk+oewNG1MHmWlLRNsWyFB2f
         VDUyMfZFfQzU/5y5GD3GKOAKYBVZ9PrTRTU8nbMN/yLH3i5ZZBjdO1SdUZugl2TPKdCh
         BGpyQ028YVkg86mefK+6nFaI5uC0RQEy20bqk8Ulxxdbmu4BLtNrQOzYJZQO6JDSQKf5
         s67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=F9gzu4ux1/gIDa9kBXORz7PWDK9PRGfbQUFqQq4SV/k=;
        b=Q9yMafJ/RkqT4MoXWhJ6aZ4LXHpnF4Skw6fSv8aN+2D7DoclFtLbPji6D4nnnNDehe
         at9nnIeWuKwBm9CH0tmwKreSwPCQT1pRWk3wN48tWzY7VNyybOmdauK4+Tq/dBYuNpne
         EH4raToUjriMcczWUwXgK6Z2GuRnD5O/wyMjqo3XYTBBYQi18+n569Xsf5YGUgcDE3Mm
         yQyM3WssO8gp9uSrkTow8EVhi4aSIWJQqZwlZ5PbI3eFlBc6urAKB6Ry7F3PTE3oFirE
         C/ghdHOU/AESqwFALCE1+iWgSBiXqWsoiER9BA1VXiEhLnVvX5CxXrzDZ8J8vqOB//sJ
         FMbA==
X-Gm-Message-State: AOAM5328DCvQokSYUtfcRx1DpPginGWXQPCPibFFl4YKbnG3w1a+8Bub
        YsMQ27CEBjRylPpDWeHPZRIyRPEkjko=
X-Google-Smtp-Source: ABdhPJxPP4YAHkG6xMFycUU8aMW8/TXDPNMrEtXWDIzd5xgH5MWAHr3LfzHxBNbEcwji7bt08YHozA==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr3217268pgm.82.1601387384298;
        Tue, 29 Sep 2020 06:49:44 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h12sm5393320pfo.68.2020.09.29.06.49.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:49:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 03/15] udp: do checksum properly in skb_udp_tunnel_segment
Date:   Tue, 29 Sep 2020 21:48:55 +0800
Message-ID: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20200929134855.Z3GcEu8P3cSC74yivbUeLQxXAAz1f-hdGtVASn7Cy5Q@z>

This patch fixes two things:

  When skb->ip_summed == CHECKSUM_PARTIAL, skb_checksum_help() should be
  called do the checksum, instead of gso_make_checksum(), which is used
  to do the checksum for current proto after calling skb_segment(), not
  after the inner proto's gso_segment().

  When offload_csum is disabled, the hardware will not do the checksum
  for the current proto, udp. So instead of calling gso_make_checksum(),
  it should calculate checksum for udp itself.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66f..c0b010b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -131,14 +131,15 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 		uh->check = ~csum_fold(csum_add(partial,
 				       (__force __wsum)htonl(len)));
 
-		if (skb->encapsulation || !offload_csum) {
-			uh->check = gso_make_checksum(skb, ~uh->check);
-			if (uh->check == 0)
-				uh->check = CSUM_MANGLED_0;
-		} else {
+		if (skb->encapsulation)
+			skb_checksum_help(skb);
+
+		if (offload_csum) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
 			skb->csum_start = skb_transport_header(skb) - skb->head;
 			skb->csum_offset = offsetof(struct udphdr, check);
+		} else {
+			uh->check = csum_fold(skb_checksum(skb, udp_offset, len, 0));
 		}
 	} while ((skb = skb->next));
 out:
-- 
2.1.0

