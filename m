Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25C7C05027
	for <linux-sctp@archiver.kernel.org>; Wed,  1 Feb 2023 05:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBAFKW (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Wed, 1 Feb 2023 00:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjBAFKV (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Wed, 1 Feb 2023 00:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BB44FAC9;
        Tue, 31 Jan 2023 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8921B8206D;
        Wed,  1 Feb 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47107C433EF;
        Wed,  1 Feb 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228217;
        bh=J4F1RIdeOqp5SaQZHOHqxwq4Bm4uDn15mrx8cBJCg30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p8zjFCTH9he+VLq88lOxcwxYlo7s3SO87fMG2pjBfegA3jSJXDRSGOD1jKPkTNdI7
         TTkpINzao05NnxjEd4Mx1AOigfvsU9MPX+0vlS9QNdyPOMS2I5I8Y/Zjx6NkndXuZh
         uEV6u1dv1zvCNWcQMy79MRMvdjE49b0/KlWsW69m+ajGQIHxj1F1lAvO8DPgiL0+Fd
         NzEKBzsmcDH/yhcp4xHRf1Rn5275ehJ/iF83oD1kwiDezm2PEvTjBq3tY9aQLJhtiY
         qVhXsIdUgfqUd6g2YWwWjwMEbY7xtc92oH9seCZnl9IY5cjF0sffCSChsAq02nv1eN
         pfQ62nluIDAUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21922E21EEC;
        Wed,  1 Feb 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: do not check hb_timer.expires when resetting
 hb_timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522821713.27789.13852790689813770738.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:10:17 +0000
References: <d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com>
In-Reply-To: <d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 11:25:33 -0500 you wrote:
> It tries to avoid the frequently hb_timer refresh in commit ba6f5e33bdbb
> ("sctp: avoid refreshing heartbeat timer too often"), and it only allows
> mod_timer when the new expires is after hb_timer.expires. It means even
> a much shorter interval for hb timer gets applied, it will have to wait
> until the current hb timer to time out.
> 
> In sctp_do_8_2_transport_strike(), when a transport enters PF state, it
> expects to update the hb timer to resend a heartbeat every rto after
> calling sctp_transport_reset_hb_timer(), which will not work as the
> change mentioned above.
> 
> [...]

Here is the summary with links:
  - [net] sctp: do not check hb_timer.expires when resetting hb_timer
    https://git.kernel.org/netdev/net/c/8f35ae17ef56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


