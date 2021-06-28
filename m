Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_20,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5B6C11F64
	for <linux-sctp@archiver.kernel.org>; Mon, 28 Jun 2021 20:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44A761CDD
	for <linux-sctp@archiver.kernel.org>; Mon, 28 Jun 2021 20:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhF1Ukv (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 28 Jun 2021 16:40:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48432 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbhF1Ukv (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Mon, 28 Jun 2021 16:40:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 899F84F41AE3E;
        Mon, 28 Jun 2021 13:38:24 -0700 (PDT)
Date:   Mon, 28 Jun 2021 13:38:17 -0700 (PDT)
Message-Id: <20210628.133817.1312716382882999150.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, marcelo.leitner@gmail.com,
        linux-sctp@vger.kernel.org, david.laight@aculab.com
Subject: Re: [PATCHv2 net-next 0/2] sctp: make the PLPMTUD probe more
 effective and efficient
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1624675179.git.lucien.xin@gmail.com>
References: <cover.1624675179.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Jun 2021 13:38:24 -0700 (PDT)
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org


I applied v1 of this so I'll need relative fixups.

Thank you.
