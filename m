Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71421C433E9
	for <linux-sctp@archiver.kernel.org>; Tue, 19 Jan 2021 04:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33466207A0
	for <linux-sctp@archiver.kernel.org>; Tue, 19 Jan 2021 04:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbhASEdj (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 18 Jan 2021 23:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731400AbhASEat (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Mon, 18 Jan 2021 23:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F35A22252;
        Tue, 19 Jan 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611030609;
        bh=KKrrHJRxceyv9NCnsP7zhyWC+fZs+HpkgzYcPPKcac4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jTlyMPINDoflRgJGE5tGandoDoBMtm5Pw2WzLZ4K3aSmlBa01XUrXXH6S/lznQ29n
         TOgkEcssisrcfwFHhnnCikEvFynueRyQc8mZ6+0Vb5sPXsFjQYEmgmduqvvUcut4vJ
         S6HfTXIq7w91+N1cY7U57AZk9Gdw5dNoQ1IxmDYfnesDx0EgTbiyzovL+c/c7eCAbk
         kIA4Jp1OrhcM92YUaW/9ayveI0aL5jOcW4TgDE9dRUwB2VnUJRVEXZku56B10YpnH6
         FClnFOF//Vg0xLcDRbgyaPZaiuFeE7GnxVZetM7fwV3R90LE9Q3pM6oBwb+Jeg1S4G
         5OlunaDu3cTBw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: make udp tunnel devices support fraglist
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103060919.4335.7926202532790955178.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 04:30:09 +0000
References: <cover.1610704037.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610704037.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, martin.varghese@nokia.com,
        alexander.duyck@gmail.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 17:47:44 +0800 you wrote:
> Like GRE device, UDP tunnel devices should also support fraglist, so
> that some protocol (like SCTP) HW GSO that requires NETIF_F_FRAGLIST
> in the dev can work. Especially when the lower device support both
> NETIF_F_GSO_UDP_TUNNEL and NETIF_F_GSO_SCTP.
> 
> Xin Long (3):
>   vxlan: add NETIF_F_FRAGLIST flag for dev features
>   geneve: add NETIF_F_FRAGLIST flag for dev features
>   bareudp: add NETIF_F_FRAGLIST flag for dev features
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] vxlan: add NETIF_F_FRAGLIST flag for dev features
    https://git.kernel.org/netdev/net-next/c/cb2c57112432
  - [net-next,2/3] geneve: add NETIF_F_FRAGLIST flag for dev features
    https://git.kernel.org/netdev/net-next/c/18423e1a9d7d
  - [net-next,3/3] bareudp: add NETIF_F_FRAGLIST flag for dev features
    https://git.kernel.org/netdev/net-next/c/3224dcfd850f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


