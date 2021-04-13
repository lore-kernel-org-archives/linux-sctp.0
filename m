Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698ABC433B4
	for <linux-sctp@archiver.kernel.org>; Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4836124B
	for <linux-sctp@archiver.kernel.org>; Tue, 13 Apr 2021 22:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhDMWK3 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 13 Apr 2021 18:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231648AbhDMWK2 (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Tue, 13 Apr 2021 18:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AD5C61164;
        Tue, 13 Apr 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351808;
        bh=TJzecSdtqpqxQ3J+Jndv3DhFj2ALtOqMzU4mFfYuoac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i2RQ28x/lgUGyLHGUAjzoYoo3ISfwuvhoiuEXhlXQTCfPPR+O9ENSlq2YzoZR7/+m
         /UQpEbV4I3c7Cm0JPHoH8xK3rjzMyRM4Qi9XFaqW+JA6gqtCzKizyXja/kWTtOAxs3
         RGk8kZ1u3bU1GciexnCXF+5sxHGW8y3lAixL5I+XEQQmx9ITS3RG+m/olaXkaIyccr
         PT4/HiA64HJuIhMBQSsR+KXGzlM4ATvwvocO2m7xXmv/5v/gJgZXWBqxWsok/9KIP2
         yiViXjbJQCmWmcujLIiGE4IUERPAn8+VyFhGZlBHfSUSGGb5QLfZE6KDzhJ3seUdJ6
         joO+gn3xP3Rfw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/sctp: fix race condition in sctp_destroy_sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835180857.31494.15153605709607960746.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:10:08 +0000
References: <20210413181031.27557-1-orcohen@paloaltonetworks.com>
In-Reply-To: <20210413181031.27557-1-orcohen@paloaltonetworks.com>
To:     Or Cohen <orcohen@paloaltonetworks.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        nmarkus@paloaltonetworks.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Apr 2021 21:10:31 +0300 you wrote:
> If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
> held and sp->do_auto_asconf is true, then an element is removed
> from the auto_asconf_splist without any proper locking.
> 
> This can happen in the following functions:
> 1. In sctp_accept, if sctp_sock_migrate fails.
> 2. In inet_create or inet6_create, if there is a bpf program
>    attached to BPF_CGROUP_INET_SOCK_CREATE which denies
>    creation of the sctp socket.
> 
> [...]

Here is the summary with links:
  - [v2] net/sctp: fix race condition in sctp_destroy_sock
    https://git.kernel.org/netdev/net/c/b166a20b0738

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


