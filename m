Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839DAC636D6
	for <linux-sctp@archiver.kernel.org>; Thu, 16 Feb 2023 11:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBPLsg (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 16 Feb 2023 06:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjBPLse (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 16 Feb 2023 06:48:34 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2505553558
        for <linux-sctp@vger.kernel.org>; Thu, 16 Feb 2023 03:48:27 -0800 (PST)
Received: from dggpeml500002.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PHY6z5Y4Wz16Nc9
        for <linux-sctp@vger.kernel.org>; Thu, 16 Feb 2023 19:46:03 +0800 (CST)
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 16 Feb
 2023 19:48:25 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-sctp@vger.kernel.org>, <marcelo.leitner@gmail.com>
CC:     <zhaowei23@huawei.com>, <caowangbao@huawei.com>,
        <yanan@huawei.com>, <zhangqiumiao1@huawei.com>
Subject: [PATCH lksctp-tools 5/5] fix memory leak in test_fragments
Date:   Thu, 16 Feb 2023 19:48:22 +0800
Message-ID: <20230216114822.1000-6-zhangqiumiao1@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20230216114822.1000-1-zhangqiumiao1@huawei.com>
References: <20230216114822.1000-1-zhangqiumiao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.117.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500002.china.huawei.com (7.185.36.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
---
 src/func_tests/test_fragments.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/func_tests/test_fragments.c b/src/func_tests/test_fragments.c
index 359a78e..3071176 100644
--- a/src/func_tests/test_fragments.c
+++ b/src/func_tests/test_fragments.c
@@ -238,6 +238,7 @@ main(int argc, char *argv[])
 			sizeof(disable_frag));

 	msg_cnt = sizeof(msg_sizes) / sizeof(int);
+	free(msg_buf);

 	/* Send and receive the messages of different sizes specified in the
 	 * msg_sizes array in a loop.
--
2.27.0

