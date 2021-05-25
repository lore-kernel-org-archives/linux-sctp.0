Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97606C47088
	for <linux-sctp@archiver.kernel.org>; Tue, 25 May 2021 22:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5C26140B
	for <linux-sctp@archiver.kernel.org>; Tue, 25 May 2021 22:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhEYWVm (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 25 May 2021 18:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhEYWVk (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Tue, 25 May 2021 18:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 04EE76141C;
        Tue, 25 May 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981210;
        bh=c544cEyM+gnTZOpPKS+LnAMh4KVsoVDYWaWpDwsXsw4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=njVJZvEWbfGJMPn/L+JAdWDdv0YualOqQtgPnfZ0wFE/oPwpGH5iOJZifhWLP/AjN
         32Ve+7HzFljHuOitSye/GbktoS7wSnjC1xGfqctgA9xaMFtFkqDGVKajGkzmEdRI5P
         TmguECpt9/krGuCWNJgOY+jTKewxwuL8LJtbjqXUnDQUJNZ0prV+0+iAoQ4jl2IU9T
         Wb8+xUKABCmvY6bS1H9hgRjQUdvXkdsqwVJ/jQLHz9Ct3W115tWCyYroSJoHrK68NP
         cgdkSbcfjAr02Br3xCLe9hyik0xlX4VcEdb2uQx71wz9s/eCSF3eddvhaTiNnhAdby
         HzX20Qno/mYaw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: add the missing setting for asoc encap_port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198120997.14309.11695729415213636820.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:20:09 +0000
References: <6bd2663c371f783d4668de217d0fbf3b0e85cca8.1621910964.git.lucien.xin@gmail.com>
In-Reply-To: <6bd2663c371f783d4668de217d0fbf3b0e85cca8.1621910964.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 22:49:24 -0400 you wrote:
> This patch is to add the missing setting back for asoc encap_port.
> 
> Fixes: 8dba29603b5c ("sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] sctp: add the missing setting for asoc encap_port
    https://git.kernel.org/netdev/net/c/297739bd73f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


