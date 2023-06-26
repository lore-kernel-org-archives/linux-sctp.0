Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94389EB64D9
	for <linux-sctp@archiver.kernel.org>; Mon, 26 Jun 2023 21:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjFZVyO (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 26 Jun 2023 17:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjFZVxc (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Mon, 26 Jun 2023 17:53:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B17D273F;
        Mon, 26 Jun 2023 14:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0BD60F70;
        Mon, 26 Jun 2023 21:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E337FC43391;
        Mon, 26 Jun 2023 21:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687816279;
        bh=sBkglsaDnwOkcI2kCnoA34AtBWoZOKhM/qzwWI3FR7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnKWxHjdjLND0VkvcDvk3cb5fZU/dUXgUcQDgGIM0MfkUbQ4BvjyNTKYYKPXF2GDA
         FvxDzRjFCw2IQw5jfn6VpZDaFaZGa3MetHQaUSCqaIndEmvct0lxK5PUmYVhkWj3fI
         SZsH6+ALSpHllbcKt7bQpPvGINYnAKC4B788SgfuxYrzEItCSR/p4pg5ErBVNkb5oM
         v2qWxUAJ48TFG9qRJw8gB5+xFhjL4nxZqnJ5g3tqyTn4O8HwZtDxR6GC5tzxU3IdfX
         F38nWkdQsnX12eboDdRXLPsYF9xyKkPVWs75zC2tlBA97Jk+if8WwIKVTEHph/lMds
         hTE/O058lWU+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, marcelo.leitner@gmail.com,
        lucien.xin@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/6] sctp: handle invalid error codes without calling BUG()
Date:   Mon, 26 Jun 2023 17:51:13 -0400
Message-Id: <20230626215116.179581-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230626215116.179581-1-sashal@kernel.org>
References: <20230626215116.179581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.248
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a0067dfcd9418fd3b0632bc59210d120d038a9c6 ]

The sctp_sf_eat_auth() function is supposed to return enum sctp_disposition
values but if the call to sctp_ulpevent_make_authkey() fails, it returns
-ENOMEM.

This results in calling BUG() inside the sctp_side_effects() function.
Calling BUG() is an over reaction and not helpful.  Call WARN_ON_ONCE()
instead.

This code predates git.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_sideeffect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8d32229199b96..c964e7ca6f7e5 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1240,7 +1240,10 @@ static int sctp_side_effects(enum sctp_event_type event_type,
 	default:
 		pr_err("impossible disposition %d in state %d, event_type %d, event_id %d\n",
 		       status, state, event_type, subtype.chunk);
-		BUG();
+		error = status;
+		if (error >= 0)
+			error = -EINVAL;
+		WARN_ON_ONCE(1);
 		break;
 	}
 
-- 
2.39.2

