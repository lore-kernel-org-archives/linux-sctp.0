Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A426E936ED
	for <linux-sctp@archiver.kernel.org>; Thu,  5 Oct 2023 00:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjJEAki (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Wed, 4 Oct 2023 20:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjJEAkg (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Wed, 4 Oct 2023 20:40:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5563CD8
        for <linux-sctp@vger.kernel.org>; Wed,  4 Oct 2023 17:40:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA42CC433D9;
        Thu,  5 Oct 2023 00:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696466427;
        bh=1/Us9HGzzokeMRRp/ZJIfxuzIgehXZMPqhsa/gG69GE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=atbOEoAXr7BZSZni49FNM5HKySE202zlI+OjqsXI+BUg0rKjD+g+D5IStaY1HtbJv
         CwthWKVp5HZUjj2iPIDxN3rekFAfcAD/2HskA5GA7tQccalLq04mmu5Yup297CbRT0
         UTDEooDUk9Tx5dcupk6FZsMnBmiscfryxVIhbXwMHhnmVlvAsZR8LrCNGUUX1ZTzz3
         hE6CswiowOYzws2yn2cVHm6jQaKm2AJDneKjfp/1IaDCZIX8emuCSEf7OGvO3w0Quq
         HjJg31ikJ86MUM8EIln0nLoT5wbzm5qeJEWSlIN0aTSReYLVjp2Pt9eEUVdjd6HwPj
         ssUbFdsmR3mlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD6E8E268B2;
        Thu,  5 Oct 2023 00:40:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: update transport state when processing a dupcook
 packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169646642777.7507.18371535328786220058.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Oct 2023 00:40:27 +0000
References: <fd17356abe49713ded425250cc1ae51e9f5846c6.1696172325.git.lucien.xin@gmail.com>
In-Reply-To: <fd17356abe49713ded425250cc1ae51e9f5846c6.1696172325.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  1 Oct 2023 10:58:45 -0400 you wrote:
> During the 4-way handshake, the transport's state is set to ACTIVE in
> sctp_process_init() when processing INIT_ACK chunk on client or
> COOKIE_ECHO chunk on server.
> 
> In the collision scenario below:
> 
>   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
>     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
>     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
>   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021]
> 
> [...]

Here is the summary with links:
  - [net] sctp: update transport state when processing a dupcook packet
    https://git.kernel.org/netdev/net/c/2222a78075f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


