Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EB9C77B73
	for <linux-sctp@archiver.kernel.org>; Thu, 20 Apr 2023 01:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjDTBS2 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Wed, 19 Apr 2023 21:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjDTBS2 (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Wed, 19 Apr 2023 21:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413A346BD;
        Wed, 19 Apr 2023 18:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE3F7623A2;
        Thu, 20 Apr 2023 01:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A9C433D2;
        Thu, 20 Apr 2023 01:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953506;
        bh=XPe5AY+r1t1QZkxzoMt8DRrTxiLc2RYeUZmspSq9lQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7/lCHl3Hzgg0STf4gH+qvB9t/4hQ03pFv6tRq8Di868nTfzvaZmGajc86kUK5ch8
         QZrE40JjIvdByuuf9By2e9CeGmDEIqEsTfIq9Zlz17mmRMYqPM7pgLuBlJVDlBC8qK
         sRLYAOkHRg8KBvjzEzx2C+OUA2W6gudGtFQhhH13aEfu5aH+3bXAebpmoVc0hhqp+R
         serTyMvYrtzH6EADbKtLoJ90mRKUmgpeQWkXnNE8aL2+KYlFHBdCgjK6RkqEhcWdpQ
         CuMLf37lWi6PDpL5Q0sIZBBcGjlR0I1QlIwqa/+XT/PsD5ffH1ejXnKRVt/Q282sI3
         quJ3QAvAhpAjA==
Date:   Wed, 19 Apr 2023 18:18:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net-next 0/6] sctp: fix a plenty of
 flexible-array-nested warnings
Message-ID: <20230419181824.10119070@kernel.org>
In-Reply-To: <cover.1681917361.git.lucien.xin@gmail.com>
References: <cover.1681917361.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Wed, 19 Apr 2023 11:16:27 -0400 Xin Long wrote:
> Paolo noticed a compile warning in SCTP,
> 
> ../net/sctp/stream_sched_fc.c: note: in included file (through ../include/net/sctp/sctp.h):
> ../include/net/sctp/structs.h:335:41: warning: array of flexible structures
> 
> But not only this, there are actually quite a lot of such warnings in
> some SCTP structs. This patchset fixes most of warnings by deleting
> these nested flexible array members.
> 
> After this patchset, there are still some warnings left:
> 
>   # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
>   ./include/net/sctp/structs.h:1145:41: warning: nested flexible array
>   ./include/uapi/linux/sctp.h:641:34: warning: nested flexible array
>   ./include/uapi/linux/sctp.h:643:34: warning: nested flexible array
>   ./include/uapi/linux/sctp.h:644:33: warning: nested flexible array
>   ./include/uapi/linux/sctp.h:650:40: warning: nested flexible array
>   ./include/uapi/linux/sctp.h:653:39: warning: nested flexible array
> 
> the 1st is caused by __data[] in struct ip_options, not in SCTP;
> the others are in uapi, and we should not touch them.
> 
> Note that instead of completely deleting it, we just leave it as a
> comment in the struct, signalling to the reader that we do expect
> such variable parameters over there, as Marcelo suggested.

Hi Kees, is there no workaround for nested flexible arrays within 
the kernel?  Any recommendations?

https://lore.kernel.org/all/cover.1681917361.git.lucien.xin@gmail.com/
