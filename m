Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE55C433FE
	for <linux-sctp@archiver.kernel.org>; Fri, 18 Nov 2022 01:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240834AbiKRBg7 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 17 Nov 2022 20:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiKRBg1 (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 17 Nov 2022 20:36:27 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB3C277229;
        Thu, 17 Nov 2022 17:35:52 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id ABB721E80D72;
        Fri, 18 Nov 2022 09:32:40 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 47yIjIXExCWa; Fri, 18 Nov 2022 09:32:38 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id F3E031E80D70;
        Fri, 18 Nov 2022 09:32:37 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     pabeni@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, vyasevich@gmail.com
Subject: 
Date:   Fri, 18 Nov 2022 09:35:21 +0800
Message-Id: <20221118013522.2760-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <1c43f0836d741a575b4805292d6dfff134ef6225.camel@redhat.com>
References: <1c43f0836d741a575b4805292d6dfff134ef6225.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org


Many thanks. I resubmit a patch.

