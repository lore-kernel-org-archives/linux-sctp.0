Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD4AC433B4
	for <linux-sctp@archiver.kernel.org>; Mon, 17 May 2021 22:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D040611BF
	for <linux-sctp@archiver.kernel.org>; Mon, 17 May 2021 22:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343921AbhEQWlb (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 17 May 2021 18:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343905AbhEQWl1 (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Mon, 17 May 2021 18:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F3C0561263;
        Mon, 17 May 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621291210;
        bh=LZE2iRtRE9Ou2/z8ye8EEydsHVnc3WBAzTs+rmw1Caw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EM3iTFPe/Bfq3eUH8LPiJYRf1tqWRxbLkTnMbZL0Oydx+Ys2YTwgJxzKn9TBWgekk
         vnJxIoNuzwhEM7a+jqcvHwG+PZ0MF5K9lElpQC/5Igjz+IhdtqLt8z9MuuTVf1yw7m
         K4slJ+NiyqEpkJ7nxQ3XuqGIgh8Z6JkYcHxrYjeT13Taog/UiG9NGOj3oZRkSuV99N
         6UMRFiZPIY64drmEG9Pf5inmosK4qPleu0darpOzh8mAWlHo2gQvFxBChNoH8kjJiM
         lS04vpkS7hShsmo6NotxRcpkrmHgfjVGBx2nFYQ5ucLUx19346w29JlntslN+DUmg2
         wv/mmL1rHGy6Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Remove the member netns_ok
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129120995.10606.11207863324142799499.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:40:09 +0000
References: <1621254125-21588-1-git-send-email-yejunedeng@gmail.com>
In-Reply-To: <1621254125-21588-1-git-send-email-yejunedeng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, xeb@mail.ru, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        edumazet@google.com, yejunedeng@gmail.com, weiwan@google.com,
        paul@paul-moore.com, rdunlap@infradead.org, rdias@singlestore.com,
        fw@strlen.de, andrew@lunn.ch, tparkin@katalix.com,
        stefan@datenfreihafen.org, matthieu.baerts@tessares.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, linux-sctp@vger.kernel.org
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 20:22:05 +0800 you wrote:
> Every protocol has the 'netns_ok' member and it is euqal to 1. The
> 'if (!prot->netns_ok)' always false in inet_add_protocol().
> 
> Signed-off-by: Yejune Deng <yejunedeng@gmail.com>
> ---
>  include/net/protocol.h    | 1 -
>  net/dccp/ipv4.c           | 1 -
>  net/ipv4/af_inet.c        | 4 ----
>  net/ipv4/gre_demux.c      | 1 -
>  net/ipv4/ipmr.c           | 1 -
>  net/ipv4/protocol.c       | 6 ------
>  net/ipv4/tunnel4.c        | 3 ---
>  net/ipv4/udplite.c        | 1 -
>  net/ipv4/xfrm4_protocol.c | 3 ---
>  net/l2tp/l2tp_ip.c        | 1 -
>  net/sctp/protocol.c       | 1 -
>  11 files changed, 23 deletions(-)

Here is the summary with links:
  - net: Remove the member netns_ok
    https://git.kernel.org/netdev/net-next/c/5796254e467b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


