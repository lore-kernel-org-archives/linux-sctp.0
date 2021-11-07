Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00CDC4332F
	for <linux-sctp@archiver.kernel.org>; Sun,  7 Nov 2021 19:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB56760F46
	for <linux-sctp@archiver.kernel.org>; Sun,  7 Nov 2021 19:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhKGTMy (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Sun, 7 Nov 2021 14:12:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54100 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbhKGTMx (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Sun, 7 Nov 2021 14:12:53 -0500
Received: from localhost (225.159.143.150.dyn.plus.net [150.143.159.225])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 345F74FE7B833;
        Sun,  7 Nov 2021 11:10:05 -0800 (PST)
Date:   Sun, 07 Nov 2021 19:09:59 +0000 (GMT)
Message-Id: <20211107.190959.1432110661171124830.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     omosnace@redhat.com, netdev@vger.kernel.org, kuba@kernel.org,
        lucien.xin@gmail.com, richard_c_haines@btinternet.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhQwpKWBF2S=vTutBVXeY9xSfTRuhK9nM9TariLVUSweMA@mail.gmail.com>
References: <20211104195949.135374-1-omosnace@redhat.com>
        <CAHC9VhQwpKWBF2S=vTutBVXeY9xSfTRuhK9nM9TariLVUSweMA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 07 Nov 2021 11:10:07 -0800 (PST)
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Sun, 7 Nov 2021 09:12:57 -0500

> 
> When we change things as significantly as we are doing here, i.e.
> shifting some of the labeling away from the endpoint to the
> association, I much rather we do it as a chunk/patchset so that we can
> review it in a consistent manner.  Some of that has gone out the door
> here because of what I view as recklessness on the part of the netdev
> folks, but that doesn't mean we need to abandon all order.  Let's get
> all the fixes and repairs queued up in a single patchset so that we
> can fully see what the end result of these changes are going to look
> like.  Further, I think it would be good if at least one of the
> patches has a very clear explanation in the commit description (not
> the cover letter, I want to see this in the git log) of what happens

Cover letters show up in the merge commit log message for the patch
series so they show up in the git commit log.

Paul, please stop being so difficult and let's fix this.

Thank you.

