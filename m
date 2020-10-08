Return-Path: <SRS0=mF4i=DP=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3487C433E7
	for <linux-sctp@archiver.kernel.org>; Thu,  8 Oct 2020 09:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56DF620725
	for <linux-sctp@archiver.kernel.org>; Thu,  8 Oct 2020 09:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYyZcJf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgJHJss (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 8 Oct 2020 05:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgJHJsr (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 8 Oct 2020 05:48:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B802CC061755;
        Thu,  8 Oct 2020 02:48:47 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r21so471320pgj.5;
        Thu, 08 Oct 2020 02:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=BDJ5qrxqVkEtVGtt8cqpeRGleZ89sZlJyVe+mDuXBNQ=;
        b=AYyZcJf1NDVnQNjulcZ25HYIi9gGmt70b2+h/Iyth+lp4EXmFHKLOTxtiAK30+j6zf
         UN6ws5x+04NBbp9g/nZ1hhEYBMB7y7Mk7MCm3506pCVHs/PWx+qN0JlyB9lbdUEQ/ejy
         Vw1VdIgSWR5CMaSlgGxs7Jnr0w4zlgXuWRGTR0lnONpAuM8DOAPfqMzKaCgZl5an/2a2
         LVmpvG0jcL39Wa59DJndfp/pbUsfYbrVqdpv2HxcMHQKmMvk+SSlo6x6gUfLU3mvd2Z0
         i1i14/73TTYECnbemJV/LfH1/aSZgV4moUMWxfiR6wndu4RZY0cqhQrrr4XWkZIjFylC
         v6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=BDJ5qrxqVkEtVGtt8cqpeRGleZ89sZlJyVe+mDuXBNQ=;
        b=Tt2+HJNVNg2BLeF9jQp4E5MCBvaciH/SoOtaUmGw29hkZAvd9JyaLukM5/hSUh1adg
         oIDBK0TA0FuCmkLcqeFKs8LR7MwOYIDlz6gC6W1a0Cy70J21U4+hbSx1F0IISbBXdYgB
         wRs2j8EivD5J9iIqjPxT2XxTQw5YPdkkJKXfKSFSc2d7+wtxOg3mxPaEOtT8kjYw+VDL
         4cE122ZND3THN3ecQq9sCOTxwgOX6xihZ5RsWt39l1SoOlJw34ltiiLJsackofrbZTpT
         hbAjhX8IJpBDV9XJUnV36ljseAfAgUzdGV8Nxdh9ryI91ehPCjDhcz22TrxMENzXXdaK
         g8lA==
X-Gm-Message-State: AOAM530GDwYzgg0NmZEXgK7RA3zm+0ZlPh5BAjWPe7VUv/NfkV5wvYeq
        cBomuedMGJZHQpRYRRe3n+AF94i8wkE=
X-Google-Smtp-Source: ABdhPJyPRVVWQMCY6LSVJPfeVQ2yAj8vaHIwaqp+yY+Ys6OQoM2sxRkofrVT4hwWGFrTFgdcjuYw+A==
X-Received: by 2002:a05:6a00:23cc:b029:142:2501:35cf with SMTP id g12-20020a056a0023ccb0290142250135cfmr6950258pfc.47.1602150526918;
        Thu, 08 Oct 2020 02:48:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v10sm6104307pjf.34.2020.10.08.02.48.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:48:46 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 03/17] udp: do checksum properly in skb_udp_tunnel_segment
Date:   Thu,  8 Oct 2020 17:47:59 +0800
Message-ID: <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20201008094759.P20cJbrkHzWa3O8yXqVqKDlcTCAAsbMDNDsVOQr_cJs@z>

This patch fixes two things:

  When skb->ip_summed == CHECKSUM_PARTIAL, skb_checksum_help() should be
  called do the checksum, instead of gso_make_checksum(), which is used
  to do the checksum for current proto after calling skb_segment(), not
  after the inner proto's gso_segment().

  When offload_csum is disabled, the hardware will not do the checksum
  for the current proto, udp. So instead of calling gso_make_checksum(),
  it should calculate checksum for udp itself.

Cc: Tom Herbert <tom@herbertland.com>
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

