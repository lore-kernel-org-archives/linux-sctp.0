Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA90C433EF
	for <linux-sctp@archiver.kernel.org>; Fri, 24 Sep 2021 09:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873FD6105A
	for <linux-sctp@archiver.kernel.org>; Fri, 24 Sep 2021 09:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbhIXJlk (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245241AbhIXJlk (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Fri, 24 Sep 2021 05:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 317136105A;
        Fri, 24 Sep 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632476407;
        bh=DmO3RJxY/ScWDvNs3diqdTPGOviATZRpNBy0oaOblWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BQPyTyXbBbESjVDmcr7fJtkezsQB+Lk0CQMmlJkye73ushE/PEiObEIjhzuX5HMyq
         nFN22PLHWk9lhCALqQsYVpaSWrv1KNGpRG6o+xShc6++BB5B2EVP05mxjljtFl3zof
         hNNHz3OKIVirFob8jVucqMXTdi+LxFePM38o7eINXXK0vpakwIzGvCY2Liq6RrwNO1
         la3r5I2WrsOuOJkzRnVx09HVEqB5tGX9hYpFEv+R2lPIf0jTA6K0zpIdm9NPEeBtUF
         q04+tL5EfDO2RWyLEvZGDEnIzbvu5HBDGzJraIuWDaqZK/vF4I963wFasb53Ao3//d
         +B6rICeat/mnw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: break out if skb_header_pointer returns NULL in
 sctp_rcv_ootb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163247640714.26581.17261316258079212151.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 09:40:07 +0000
References: <8f91703995c8de638695e330c06d17ecec8c9135.1632369904.git.lucien.xin@gmail.com>
In-Reply-To: <8f91703995c8de638695e330c06d17ecec8c9135.1632369904.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 23 Sep 2021 00:05:04 -0400 you wrote:
> We should always check if skb_header_pointer's return is NULL before
> using it, otherwise it may cause null-ptr-deref, as syzbot reported:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
>   RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
>   Call Trace:
>   <IRQ>
>    sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1109
>    ip6_protocol_deliver_rcu+0x2e9/0x1ca0 net/ipv6/ip6_input.c:422
>    ip6_input_finish+0x62/0x170 net/ipv6/ip6_input.c:463
>    NF_HOOK include/linux/netfilter.h:307 [inline]
>    NF_HOOK include/linux/netfilter.h:301 [inline]
>    ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
>    dst_input include/net/dst.h:460 [inline]
>    ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
>    NF_HOOK include/linux/netfilter.h:307 [inline]
>    NF_HOOK include/linux/netfilter.h:301 [inline]
>    ipv6_rcv+0x28c/0x3c0 net/ipv6/ip6_input.c:297
> 
> [...]

Here is the summary with links:
  - [net] sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb
    https://git.kernel.org/netdev/net/c/f7e745f8e944

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


