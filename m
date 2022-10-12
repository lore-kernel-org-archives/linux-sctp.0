Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A702CC4332F
	for <linux-sctp@archiver.kernel.org>; Wed, 12 Oct 2022 21:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiJLVFA (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Wed, 12 Oct 2022 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJLVEl (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Wed, 12 Oct 2022 17:04:41 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B728B2124C
        for <linux-sctp@vger.kernel.org>; Wed, 12 Oct 2022 14:04:10 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1321a1e94b3so188287fac.1
        for <linux-sctp@vger.kernel.org>; Wed, 12 Oct 2022 14:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvH76TQJB8M7fp5h6K3B1zs6Bs5IVYd4fYdNyFLRvhE=;
        b=Vg1jGtj3TbbHH+p7uJBujIH2xQMlcnVp3GLr9sm8wsuZJeUY4cVaYddIFeBPHB23Pa
         7wPZ0ijDb5wISpzthjb68VD30lh2TiMNudjvDv0VXgpwbH0y2eDTYxSMcDF9T2Y7rdUh
         MDQkFo5HqjXRiBVpxttdEh+yWan1S4snwRgojcoJGeXZ2RDfvmE7OcjxssY43bqT4BDi
         80wCM9/ESfq9xQJ3AxZK83iuGVp19nDQ/jshaC8e5lrHDi9U9eAHJ2Tnw9MJAYSkZPzM
         rCCiTTsq3DUPZsu5+tu2CPkFVe2qZXD4H7LIUs1MelDthOmKOmZVCc8R7rtpKYiGYhW4
         k3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvH76TQJB8M7fp5h6K3B1zs6Bs5IVYd4fYdNyFLRvhE=;
        b=M/gW31T8xX24G8dEJ6IedwDGq/mAPhsUaIL1W2s/QHgcmh5s0fwD1AwRF0UgmTsIP4
         qAaAdtdzMqe+2UaaWtbu8+ch94ts7Nx1KI2kmnENYOWLG5+zDFT10Rncd+USmwT/37TG
         yqzKry2NyefApxYqCBMLX832zDYzm2Zyd4MBhQ4rn7sENnayHtJ3FjNb2+pV8uu9tlYR
         P+37pM22uepoQNICN4fCPXp42HA6+vNshZCmapYi22reOtLI70tqUHxECtfcgyfbM8mH
         VXfTQFmZ3oHSZNxe740WeUAxV2DqPF7Xz1XisD9CAJmWpwU1BaC8htICoZVK8aNA/D1g
         Ydgg==
X-Gm-Message-State: ACrzQf1s5IrPUkhlVDrcSovKah5eGjrVNTGWU2cPHnVumzWKt9PwqRVz
        f4dBg7TIHudwGDIbZMDWlqAEJ/hVZoA=
X-Google-Smtp-Source: AMsMyM79qUdBf7SXSRXcAf1XD0RqIr+iDSnkl/L3QEhY6Zax4OSbtnV9H4f24V5Ruc8EnE5VFhiBvw==
X-Received: by 2002:a05:6870:702c:b0:132:fdbf:8148 with SMTP id u44-20020a056870702c00b00132fdbf8148mr3773471oae.253.1665608648795;
        Wed, 12 Oct 2022 14:04:08 -0700 (PDT)
Received: from t14s.localdomain ([177.99.67.48])
        by smtp.gmail.com with ESMTPSA id i11-20020a54408b000000b003549397fde4sm3634195oii.54.2022.10.12.14.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 14:04:08 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 7C763429DBA; Wed, 12 Oct 2022 18:04:04 -0300 (-03)
Date:   Wed, 12 Oct 2022 18:04:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Istvan Gyurjan <istvan.gyurjan@flex.com>
Cc:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Subject: Re: lksctp-tools licensing
Message-ID: <20221012210404.v5e4cprel47nc5fm@t14s.localdomain>
References: <PH0PR08MB724105AD73E9AFB3F12A0679E7419@PH0PR08MB7241.namprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR08MB724105AD73E9AFB3F12A0679E7419@PH0PR08MB7241.namprd08.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Wed, Sep 07, 2022 at 10:32:38AM +0000, Istvan Gyurjan wrote:
> Dear lksctp-tools Maintainer team,
> 
> We are planning to develop an application where lksctp-tools would be used together with other OSS components that uses Apache License 2.0 and The OpenSSL License. Those are in conflict with the GPL-2.0-only
> license of lksctp-tools.
> Do you have any plan to update the license to GPL-2.0-or-later?

Actually.. all the library files are LGPL. Isn't that enough already?

  Marcelo
