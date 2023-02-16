Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41315C636CC
	for <linux-sctp@archiver.kernel.org>; Thu, 16 Feb 2023 11:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjBPLsd (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 16 Feb 2023 06:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBPLsa (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 16 Feb 2023 06:48:30 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E3D518D6
        for <linux-sctp@vger.kernel.org>; Thu, 16 Feb 2023 03:48:25 -0800 (PST)
Received: from dggpeml500002.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PHY6w62B7znW9r
        for <linux-sctp@vger.kernel.org>; Thu, 16 Feb 2023 19:46:00 +0800 (CST)
Received: from huawei.com (10.136.117.208) by dggpeml500002.china.huawei.com
 (7.185.36.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 16 Feb
 2023 19:48:23 +0800
From:   Qiumiao Zhang <zhangqiumiao1@huawei.com>
To:     <linux-sctp@vger.kernel.org>, <marcelo.leitner@gmail.com>
CC:     <zhaowei23@huawei.com>, <caowangbao@huawei.com>,
        <yanan@huawei.com>, <zhangqiumiao1@huawei.com>
Subject: [PATCH lksctp-tools 0/5] fix memory leak and use valid conversion specifiers in printf()
Date:   Thu, 16 Feb 2023 19:48:17 +0800
Message-ID: <20230216114822.1000-1-zhangqiumiao1@huawei.com>
X-Mailer: git-send-email 2.28.0.windows.1
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

fix some memory leak and use %u as the valid conversion specifier of unsigned integers

Qiumiao Zhang (5):
  fix memory leak in sctp_status
  fix memory leak in test_peer_addr()
  use valid conversion specifiers in printf()
  fix memory leak of iov.iov_base
  fix memory leak in test_fragments

 src/apps/sctp_darn.c                  |  4 ++++
 src/apps/sctp_status.c                | 15 +++++++++++++++
 src/func_tests/test_fragments.c       |  1 +
 src/func_tests/test_sctp_sendvrecvv.c |  1 +
 src/testlib/sctputil.c                | 18 ++++++++++--------
 5 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.27.0

