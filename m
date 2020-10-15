Return-Path: <SRS0=noBC=DW=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A0C433DF
	for <linux-sctp@archiver.kernel.org>; Thu, 15 Oct 2020 03:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C5E822243
	for <linux-sctp@archiver.kernel.org>; Thu, 15 Oct 2020 03:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602732859;
	bh=TVGjhdWiB2fFA3Y1jyQm7Z4EccfRhDmqHc1Qnp5+ouk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Z4CVb9wUOsRajdNIl1TCscxT3rWKbIDxuobP6CgcriA1oiFGlngQFTSEYjw1FgrM/
	 wOLtrnLBtBflw/+c8hujIhyz41pBudV5L+1tAJ8YuPOuhHgkVLFsTCmKeH4xjV4tjL
	 0wE3IhL2Ls2EB71kyedzWoz7Z5QbTXH//LaqmWxg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgJODeT (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgJODeS (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Wed, 14 Oct 2020 23:34:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D5622241;
        Thu, 15 Oct 2020 03:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602732858;
        bh=TVGjhdWiB2fFA3Y1jyQm7Z4EccfRhDmqHc1Qnp5+ouk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UD8c268b7z7PxWnzhwPftXHLw4gqiynlEH3lAPHx3vRzAfcSeHISXTkHpQTRyzgDB
         VJ7kqMwdQ3bAWuqhhhjJGM+RFN5g82d4q4tAEFe121iQ6MdZ3FGPDOmKa9LJkV+QVZ
         fwUOe+/yxEEdt2JE31rBCn0xsojs/nPX6MSM2u00=
Date:   Wed, 14 Oct 2020 20:34:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv3 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20201015033416.dIjkQupckNkagx1HJ7x_1cG5Jr555BVxjQq1Gb7d8l8@z>

On Tue, 13 Oct 2020 15:27:25 +0800 Xin Long wrote:
> Description From the RFC:
> 
>    The Main Reasons:
> 
>    o  To allow SCTP traffic to pass through legacy NATs, which do not
>       provide native SCTP support as specified in [BEHAVE] and
>       [NATSUPP].
> 
>    o  To allow SCTP to be implemented on hosts that do not provide
>       direct access to the IP layer.  In particular, applications can
>       use their own SCTP implementation if the operating system does not
>       provide one.

Marcelo, Neil - please review if you want this one to make 5.10.

Otherwise we can defer until after the merge window.
