Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F9CC11F64
	for <linux-sctp@archiver.kernel.org>; Thu,  1 Jul 2021 18:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6769D61416
	for <linux-sctp@archiver.kernel.org>; Thu,  1 Jul 2021 18:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhGASwf (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233223AbhGASwe (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Thu, 1 Jul 2021 14:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C69A6140E;
        Thu,  1 Jul 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625165403;
        bh=2K1RTMskIWz2OTCFctvPmby4zDSYIe7g1D7jUZKqi+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iYmcO5yoIieBEPzksXVp+OnXd5xqWfbMoKoTM/uU5tqoeJPL0t/3neDxhpLcm4rse
         XCTeONyNbL58X9gshUQliqmF0kV17AK8PGoBtcP5+xxoopMYDdPLV5mmRtTwGq6gTP
         rQd+wJ/CDJdoWKeJQyBzL5EJQiLiMQEUvpW26KPsRUK+2CjbJ/8lWRQYmCsbUl1Mtp
         UySeDNDNvYzu26eTgJ/QMKPlj2xM6xZWgPswQ6widtc2yrtE+3CUYRTQpYC/jRA/V7
         CieDXXsU03IENZsxNPSAbRsxYVRd8/SV1vedMIlUr51j8gz1U4UaMqFfn/+lybVUR+
         /KjjFXoe5ITRw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: check pl.raise_count separately from its
 increment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516540355.27350.69226156177934555.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:50:03 +0000
References: <727028cb5f9354809a397cf83d72e71b4c97ab85.1625023836.git.lucien.xin@gmail.com>
In-Reply-To: <727028cb5f9354809a397cf83d72e71b4c97ab85.1625023836.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 23:30:36 -0400 you wrote:
> As Marcelo's suggestion this will make code more clear to read.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] sctp: check pl.raise_count separately from its increment
    https://git.kernel.org/netdev/net/c/650b2a846ddd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


