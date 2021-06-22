Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A294AC2B9F4
	for <linux-sctp@archiver.kernel.org>; Tue, 22 Jun 2021 17:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C05C60FE9
	for <linux-sctp@archiver.kernel.org>; Tue, 22 Jun 2021 17:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhFVRFD (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 22 Jun 2021 13:05:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51508 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhFVRFD (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Tue, 22 Jun 2021 13:05:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8736D4FE766CB;
        Tue, 22 Jun 2021 10:02:46 -0700 (PDT)
Date:   Tue, 22 Jun 2021 10:02:42 -0700 (PDT)
Message-Id: <20210622.100242.807992618453242367.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     lkp@intel.com, netdev@vger.kernel.org, kuba@kernel.org,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH net-next 06/14] sctp: do the basic send and recv for
 PLPMTUD probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADvbK_dCgaqrr=pxZGfBmm=3m31+eKgcfkU7AowFbnZAcC92bQ@mail.gmail.com>
References: <66a73fb28cc8175ac80735f6301110b952f6e139.1624239422.git.lucien.xin@gmail.com>
        <202106211151.QDS54KHu-lkp@intel.com>
        <CADvbK_dCgaqrr=pxZGfBmm=3m31+eKgcfkU7AowFbnZAcC92bQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 22 Jun 2021 10:02:46 -0700 (PDT)
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Jun 2021 21:13:59 -0400

> This is a "set but not used" warning, I can fix it after.

Please fix it now and respin, thank you.
