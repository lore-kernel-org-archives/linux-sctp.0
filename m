Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81331C433EF
	for <linux-sctp@archiver.kernel.org>; Thu,  3 Mar 2022 06:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiCCGT3 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 3 Mar 2022 01:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiCCGT3 (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 3 Mar 2022 01:19:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B73149BAD;
        Wed,  2 Mar 2022 22:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E55FB823EC;
        Thu,  3 Mar 2022 06:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA59C004E1;
        Thu,  3 Mar 2022 06:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646288321;
        bh=CV+mzyJI0MU1E13yzEY95qiJl5J/zjg0HzKnIqoOh6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n6594idVn1X4CaWhvXjreD7uvklwCF+u3aKbL01xQJrtPVgA9mowSH0olm7nU2fVP
         xysQ9WH+NWHkvYUAuw/9HoKnpGyS1UdAZltyoxW/XFmW3oCd4MIoWcyjNgE+7ablYh
         U01Xq3QhZmPGuJ+ioLRp7Zr0ykOiJgmEuEJEfBIv2KCniPVipyCO9z2/xMkYf/jhHb
         YK2//YOROxetmGcRVLcvRMeAEP+ol1l9dadP2HHifiUC2NmZtItnggPbu5+xeCkodp
         0nPiLYqipAhOTXQbPPVhJs7O9X3pY3lxUaLREXIivAqLeXOw1AG4Z7Yqutg62XpXhA
         IbAli1N1ptYJw==
Date:   Wed, 2 Mar 2022 22:18:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/sctp: use memset avoid infoleaks
Message-ID: <20220302221839.2a8649c5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301081855.2053372-1-chi.minghao@zte.com.cn>
References: <20220301081855.2053372-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Tue,  1 Mar 2022 08:18:55 +0000 cgel.zte@gmail.com wrote:
> From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> 
> Use memset to initialize structs to preventing infoleaks
> in sctp_auth_chunk_verify

Please explain where it's leaked to. Looks like a parameter structure
that's used by the called but not copied anywhere.

> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index cc544a97c4af..7ff16d12e0c5 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -652,6 +652,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
>  		return false;
>  
>  	/* set-up our fake chunk so that we can process it */
> +	memset(&auth, 0x0, sizeof(auth));
>  	auth.skb = chunk->auth_chunk;
>  	auth.asoc = chunk->asoc;
>  	auth.sctp_hdr = chunk->sctp_hdr;

