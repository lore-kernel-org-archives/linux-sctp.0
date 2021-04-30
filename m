Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8381BC433B4
	for <linux-sctp@archiver.kernel.org>; Fri, 30 Apr 2021 22:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C3861481
	for <linux-sctp@archiver.kernel.org>; Fri, 30 Apr 2021 22:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhD3WbA (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 30 Apr 2021 18:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhD3Wa7 (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Fri, 30 Apr 2021 18:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2234B6147E;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619821811;
        bh=RRl6MM3D82GDe1ExZBBTvCuAXAL7NA+feHIUCR7ZbHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3TEpG5FBMWJIDOcj/BDtmWnUu55ZD9RTnzAwRTnWnyM3u4ClRsXBuArZ+cs+WOd7
         YnHKi5aCj8Q3UIFM8vH9Y54u4ZlaMtYFbYE+QERgwrnS9j+2QU7ea6s6bKc4rhcCjT
         zF+QQB9g+O8wTVSZ+ocuvGBwxyHENx9ExoKYtMxu7IMlXn4jGrMGEulXJYFtzO4sCX
         Z/vXT5SSnt7rbHBOuTxv8FWBI9O6JYZpYXHcuUkmjYRkADB12STtNFA9047B+UXFPv
         wYRIo9PO3HogGLPksqPUT7tc7yfprHfWMzA5YQJa51wBZuVLKeFOvb2M06Y9CbSer2
         jameo5bB5MbIg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/3] sctp: always send a chunk with the asoc that it
 belongs to
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982181107.1234.530240717623635776.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:30:11 +0000
References: <cover.1619812899.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619812899.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        jere.leppanen@nokia.com, alexander.sverdlin@nokia.com
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  1 May 2021 04:02:57 +0800 you wrote:
> Currently when processing a duplicate COOKIE-ECHO chunk, a new temp
> asoc would be created, then it creates the chunks with the new asoc.
> However, later on it uses the old asoc to send these chunks, which
> has caused quite a few issues.
> 
> This patchset is to fix this and make sure that the COOKIE-ACK and
> SHUTDOWN chunks are created with the same asoc that will be used to
> send them out.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_a
    https://git.kernel.org/netdev/net/c/35b4f24415c8
  - [PATCHv2,net,2/3] Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
    https://git.kernel.org/netdev/net/c/7e9269a5acec
  - [PATCHv2,net,3/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_b
    https://git.kernel.org/netdev/net/c/51eac7f2f06b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


