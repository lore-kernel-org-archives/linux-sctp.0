Return-Path: <SRS0=mF4i=DP=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F252C433E7
	for <linux-sctp@archiver.kernel.org>; Thu,  8 Oct 2020 09:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19B120725
	for <linux-sctp@archiver.kernel.org>; Thu,  8 Oct 2020 09:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzBJBqe4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgJHJsb (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 8 Oct 2020 05:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHJsb (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 8 Oct 2020 05:48:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC23C061755;
        Thu,  8 Oct 2020 02:48:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a200so3531786pfa.10;
        Thu, 08 Oct 2020 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=hzBJBqe4rmJX0tiZtVjW9rIjMEM62SW041XFnCMWvj6WSsiU/+L1j0BsSgovh1wRBK
         D3KN39TjpNcxUfbxcufxdtxrBplBsofLC79dl2QnlJ3DzOCle1cD6jrz53RpOBpYGJMV
         i5yuoe/6PiouA46+XFgikEu9jC+oO5P+lggG4HKnM9vl15HEc4NPSy+dQB9XkEcbbgrx
         fcw8zwvO2cYiViV5Lbw/xUWn2wx/ubgNHVwtmVEtKQGbOUeHeAvUFM8dKbH+WaopNy3o
         nXhsP5Yq9q/tOV09v/IkePR7+qdQLwGQkw4+DVyix8exYaChqrn83UfOIb8zmSRviKvU
         8NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=kN9L2ZRZVFGIB5RVmblhVWK5YZ7TlQWZvJUzE+UlkXrgapulq/XbAkyAESC0u4cv8E
         JsBgDYPD0Ci8MPrgTnDkqdhFYgfY+2RrzO1NLjQhOfqr8xIbds3hBPmtmMMCTb52wivw
         AGvnOPvm7AdX1FScUVSVy58XEDEreoRfcLOwjoNFNfVhik+AuD6IUDle8lt8ysFT2Q7N
         qtrxH09o7rfYSMO1cdTppBPPzO0CzWlGqSqfoZ62wJyURKZm67W8R5wKDU6F0/Msi7LV
         sbdhnjzj1irMXu8/wVfR4ure2tQ3BOdyIicnb7CpLjC9xqC4SfX1T2WAQESC2RhSNySm
         Pemg==
X-Gm-Message-State: AOAM5334hEJVSWDXDoZON8ZzbGCYl+AxjDxkvUQ+iY0fhdzsrCKznX2g
        xWlKa9hvX2X+0gYalZgFaYl9g5FlS9U=
X-Google-Smtp-Source: ABdhPJwWJfnr7fXR6dgM6yJwKuBryT6QXeufM70v3RxqBnctun1GnaU/D/JnoYkPBoHfABHrNGnO1A==
X-Received: by 2002:a63:f74a:: with SMTP id f10mr6968293pgk.263.1602150510254;
        Thu, 08 Oct 2020 02:48:30 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mt2sm6284496pjb.17.2020.10.08.02.48.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:48:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 01/17] udp: check udp sock encap_type in __udp_lib_err
Date:   Thu,  8 Oct 2020 17:47:57 +0800
Message-ID: <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20201008094757.RrxhU3qOjK6IVY7DhU7TGGf-7T9UBX_CYYKKKiYFquU@z>

There is a chance that __udp4/6_lib_lookup() returns a udp encap
sock in __udp_lib_err(), like the udp encap listening sock may
use the same port as remote encap port, in which case it should
go to __udp4/6_lib_err_encap() for more validation before
processing the icmp packet.

This patch is to check encap_type in __udp_lib_err() for the
further validation for a encap sock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..ca04a8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -702,7 +702,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..cde9b88 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -560,7 +560,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-- 
2.1.0

