Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6171FC47092
	for <linux-sctp@archiver.kernel.org>; Tue,  1 Jun 2021 05:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43892613AD
	for <linux-sctp@archiver.kernel.org>; Tue,  1 Jun 2021 05:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhFAFvt (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 1 Jun 2021 01:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhFAFvr (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 614D1613B9;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526606;
        bh=SHOagyHzUL039zus7rj0nzp6zQlrR5zsS4tIrAIW0TU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eUX77wkozv9kqihqisu8zau+ugeuOSxMEDL0x4Jl5exs13Kxip2024Ll+r5XZZKJ8
         Z+IcglgNGdVwF7WYeNR27E9Y8KQ/WfES4YM6FTIQEhYIe6N+A4puGk/sCfJYtELHfz
         XADIuZvtHUXrserzYjcOmf6QrulfT+LcntRSlC6QAhVwU4NVypA+CoAxXSR/Xvt0jI
         W/VEMQ/nyhmQX2wfILfGnkCfA7qwJ9uvBCNaM4tPoeZ6KmCowP5DUci6DRwL5YmiCd
         HEcrSuf+pPrnekjjk7OSPTlIRznpWzL2uiLbYR30UqTxGtmI+HwVmF0wSunWgoCbTA
         p7eZR9SDOanFA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] sctp: sm_statefuns: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660635.4642.3781623408761149340.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:06 +0000
References: <20210601020801.3625358-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601020801.3625358-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 10:08:01 +0800 you wrote:
> Fix some spelling mistakes in comments:
> genereate ==> generate
> correclty ==> correctly
> boundries ==> boundaries
> failes ==> fails
> isses ==> issues
> assocition ==> association
> signe ==> sign
> assocaition ==> association
> managemement ==> management
> restransmissions ==> retransmission
> sideffect ==> sideeffect
> bomming ==> booming
> chukns ==> chunks
> SHUDOWN ==> SHUTDOWN
> violationg ==> violating
> explcitly ==> explicitly
> CHunk ==> Chunk
> 
> [...]

Here is the summary with links:
  - [v2,net-next] sctp: sm_statefuns: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/0c2c366e0ec5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


