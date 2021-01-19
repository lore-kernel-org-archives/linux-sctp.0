Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0268DC433E0
	for <linux-sctp@archiver.kernel.org>; Tue, 19 Jan 2021 22:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D033C22E01
	for <linux-sctp@archiver.kernel.org>; Tue, 19 Jan 2021 22:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbhASWZ1 (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbhASWZZ (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Tue, 19 Jan 2021 17:25:25 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB42C061575;
        Tue, 19 Jan 2021 14:24:44 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id p72so18216016iod.12;
        Tue, 19 Jan 2021 14:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vUaNEpj3UB7GS8SZkE2GtWpYrUEQMNzq+HaXsNRFN30=;
        b=ZXOuGzre+celxLqmxUEfCU+oA92M6GPrrUso8iCbe+bmE7VJFzjWihurb+60w4tw4s
         J8TFiYOu4qS1HDaIlsH0nMWywPC1YQ5DxjYlULQnQltrFEyO50jO0YQyV3YVQ+IYCYRO
         rFp57insSklU9Lwg0EtjTfbUak0VreA/XBntYVTy1FD4jXnSvnXV6PF3V2Qlnxcdi1im
         QftfFlL89rPW7MECDdO0fruaN8pSPzJFIuujjr9ec7hI/NxRrYu+j8oKjDBVCzIqeG4c
         eCGWe8vYdot+vS2o18eVNT7PjqYoz3i10FhKeIXtXONnNTlfWGiaBLeWj5wMViGsJ5eD
         P1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vUaNEpj3UB7GS8SZkE2GtWpYrUEQMNzq+HaXsNRFN30=;
        b=VN1M0CMrHd+Mhe4WtM8I19S4P/YKmKIYhMtEhfaUVFHPkvJISogQ8PdxUHAnjNae0L
         iGAw42td1Wsmu4JE+ZqbwF6MRYBZwr1c8ZaSff00US5pLjiw/TfIYeFJZ9KZjJ9wS7Mu
         Ec0E1YxkRZZkpJsC6PyzjAEoXyJR2c5fooq5JwQCO2SjlDJ9Tn/MxbCRzlD0G7/5qqap
         vt2u+0Vm66pTmJomd5NTefWJhesNxu3b05AOh9jZiJzjehSe1KDDDis4Fm1UXH2LyECr
         wWMoxM3I1s5y3sfBIQCnugOGFE9YJb9xryX48CSzGL62qEILmV/qurngLRJQseIbydwy
         9T/Q==
X-Gm-Message-State: AOAM530gTw7ag0dffwpBoklrT0XLZGVL9NJlzeGeust0AyfgMowf1Bjb
        ewnr/KYZGldK7vvqJyAO7M9nxnSjFL8PA8pyJVI=
X-Google-Smtp-Source: ABdhPJwJp3Df/eyCiTVTsT4bfIm3u6N07L+MRIFBIAeyvHbl2bfnUhbN0j9rMEHohQwO5nZ3iryFFmwm5w2LohB5e64=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr4585008iov.5.1611095084212;
 Tue, 19 Jan 2021 14:24:44 -0800 (PST)
MIME-Version: 1.0
References: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <cover.1610777159.git.lucien.xin@gmail.com> <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
 <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <c1a1972ea509a7559a8900e1a33212d09f58f3c9.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:24:33 -0800
Message-ID: <CAKgT0Uc-a37D7hxYY7kgk-mP8rX2=b8yt8fayr81NbNHWyV1_A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: igbvf: use skb_csum_is_sctp instead of
 protocol check
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Fri, Jan 15, 2021 at 10:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
> checksum offload packet, and yet it also makes igbvf support SCTP
> CRC checksum offload for UDP and GRE encapped packets, just as it
> does in igb driver.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
