Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2BDC4321E
	for <linux-sctp@archiver.kernel.org>; Fri, 18 Nov 2022 06:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbiKRGa2 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 18 Nov 2022 01:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbiKRGa1 (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Fri, 18 Nov 2022 01:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F274697AA8;
        Thu, 17 Nov 2022 22:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B5F46233D;
        Fri, 18 Nov 2022 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8A6EC4347C;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753024;
        bh=1BCsujnUrqOkhwayNpCNCxBMA1Mx0P4pKHMzbMlx/jU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZbEP1v4jIbEwXxns/IIb+3QtG7/9ik7LVR2h7KIlhW7/JW7s39/O7unZzQODkwatu
         LKreEfoVBLFsKyhVAUmqwYAZrAcK/lLucJco/fTYUFT0gbhB9shYWFRBF3s8ZFnHq9
         7wS9rwcTV9Tz6YfUKHYlBqyJNDLLQzVscFebfwq4Nt0Pvrh5D5Pe+S2Ujh6E2rLxzE
         62uED9o+ThbR39abRrQ0gYstry+QEFRg+Iqws7HSfUwUBQVL9O+NUf6khOkf/z9AlX
         7RpbHXIpo1MUF05LrjK38byzaTl0ty/J7EsbDsspWHeeif4i8Vs/Q9tCFQ/uB/2X67
         y3VEJ5DXznFzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6D32E29F45;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: move SCTP_PAD4 and SCTP_TRUNC4 to linux/sctp.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875302467.3603.6380526619601790868.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 06:30:24 +0000
References: <ef6468a687f36da06f575c2131cd4612f6b7be88.1668526821.git.lucien.xin@gmail.com>
In-Reply-To: <ef6468a687f36da06f575c2131cd4612f6b7be88.1668526821.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Nov 2022 10:40:21 -0500 you wrote:
> Move these two macros from net/sctp/sctp.h to linux/sctp.h, so that
> it will be enough to include only linux/sctp.h in nft_exthdr.c and
> xt_sctp.c. It should not include "net/sctp/sctp.h" if a module does
> not have a dependence on SCTP module.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: move SCTP_PAD4 and SCTP_TRUNC4 to linux/sctp.h
    https://git.kernel.org/netdev/net-next/c/647541ea06a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


