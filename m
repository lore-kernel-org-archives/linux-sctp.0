Return-Path: <SRS0=G3wb=EF=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C32FC388F9
	for <linux-sctp@archiver.kernel.org>; Fri, 30 Oct 2020 23:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD41221EB
	for <linux-sctp@archiver.kernel.org>; Fri, 30 Oct 2020 23:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604101603;
	bh=voJHJOf9dPBy4fxAMBhVgDxcGEaN2P+DHs0ps8ovIr8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=xU2+99sQr0wVe4IXgY5w+sT3tUoUXnZa2UW4QFdjkfEw9a1MoBrItZuHiSdI0kbcV
	 FZJ+I45jxFgDKP0PSNnxil2uVPvS7wfqI2/xahRwYBFHInJCjzhJDdIKwtAuA6KKmK
	 vyqeGAaIttOTX3Fr3hdullxlPhUDNX6q9yScHqT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgJ3Xqm (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 30 Oct 2020 19:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJ3Xqm (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Fri, 30 Oct 2020 19:46:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AB9208B6;
        Fri, 30 Oct 2020 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604101602;
        bh=voJHJOf9dPBy4fxAMBhVgDxcGEaN2P+DHs0ps8ovIr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FJdKogOYBw22C9CQ4xTuDRutEHcr9iI1uO1Xg2FQcBhiXnj8qPvB1zNgu2ubo0lP9
         uApQW7c0V58yT78WSf1xtyLLjRXXMgBVYy9FDGQOheiaRghFG1ULAZXCF1iGuk98K5
         iO6RVL9il2esFPCrtTuW1FBfwhTCrOOnWy/5kFcU=
Date:   Fri, 30 Oct 2020 16:46:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv5 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201030164640.4e89902f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Thu, 29 Oct 2020 15:04:54 +0800 Xin Long wrote:
>    This patchset is using the udp4/6 tunnel APIs to implement the UDP
>    Encapsulation of SCTP with not much change in SCTP protocol stack
>    and with all current SCTP features keeped in Linux Kernel.
> 
>    1 - 4: Fix some UDP issues that may be triggered by SCTP over UDP.
>    5 - 7: Process incoming UDP encapsulated packets and ICMP packets.
>    8 -10: Remote encap port's update by sysctl, sockopt and packets.
>    11-14: Process outgoing pakects with UDP encapsulated and its GSO.
>    15-16: Add the part from draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
>       17: Enable this feature.

Applied, thanks!
