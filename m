Return-Path: <SRS0=RtEr=DS=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA51C433E7
	for <linux-sctp@archiver.kernel.org>; Sun, 11 Oct 2020 08:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D028D20781
	for <linux-sctp@archiver.kernel.org>; Sun, 11 Oct 2020 08:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgJKIdh (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Sun, 11 Oct 2020 04:33:37 -0400
Received: from mail.fink.org ([79.134.252.20]:44620 "EHLO mail.fink.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgJKIdh (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Sun, 11 Oct 2020 04:33:37 -0400
X-Footer: Zmluay5vcmc=
Received: from protopia.fink.org ([79.134.238.50])
        (authenticated user list@fink.org)
        by mail.fink.org (Kerio Connect 9.2.12 patch 1) with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Sun, 11 Oct 2020 10:33:22 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: sctp discarding received data chunks
From:   Andreas Fink <afink@list.fink.org>
In-Reply-To: <5af24669b72c4bbb9456b53c397489a4@AcuMS.aculab.com>
Date:   Sun, 11 Oct 2020 10:33:22 +0200
Cc:     Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-ID: <DBE38DD7-A378-4269-A839-4CB0A41D948B@list.fink.org>
References: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
 <CC1FDC9B-F273-475A-98C5-000ADC395BB0@list.fink.org>
 <73434b87932e46a89dd1b5b5132b3196@AcuMS.aculab.com>
 <766ffacb7d4c48df81aea64204ff37d9@AcuMS.aculab.com>
 <CADvbK_farVU-bB9NeLSDfmCgPcdG2Oe44-odeU0o+b2BwfRA0g@mail.gmail.com>
 <5af24669b72c4bbb9456b53c397489a4@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20201011083322.BLs2RGO67vf5PgsEdr9K4OfJjh96vzhRnfOaX-cctB8@z>


> 
> Extremely unlikely.
> 
> Looking at the latest version of my driver code
> (which I wasn't using) I wrote the following:
> 
> * Since the code that negotiates the number of streams got broken
> * in version 5.1 we need to extract the correct value from the
> * internal structures to avoid SCTP sending messages the remote
> * system will discard.
> 
>    /* stream.outcnt is the value we should be using.
>     * But kernels 5.1 to 5.8 fail to reduce it based on the number
>     * received from the remote system.
>     * So bound here so that transmitted messages don't get discarded. */
>    outcnt = asoc->stream.outcnt;
>    num_ostreams = asoc->c.sinit_num_ostreams;
> 
> I think there was a patch done for 5.9.
> It needs back-porting.
> 
> Although Andreas said 5.4 worked for him.
> So maybe he has a different problem.
> 

In my application code, I never use anything else than stream 0 and 1
So I see some other issue in kernel 5.8 which makes it go haywire.


