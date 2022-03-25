Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0009AC433F5
	for <linux-sctp@archiver.kernel.org>; Fri, 25 Mar 2022 20:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiCYU7S (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiCYU7R (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Fri, 25 Mar 2022 16:59:17 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6014CB9192;
        Fri, 25 Mar 2022 13:57:42 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id b188so9437281oia.13;
        Fri, 25 Mar 2022 13:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uzAuqtwkm46GspJerldWifZpeS2uUUcdgFDDV4iF0Yc=;
        b=kCPIJahkmzOtz09iL0VBxsl721inkNgOH3ZtvZsKBaopkIMxhCt9wXBCVZYMOlR09o
         NJPOZusdSDjEUe1v1RHURtfLqkJdx3KH4JphrNnOXpWQEU96pRFb1VqPwVgAvJxtdEpG
         bopMeVKGXfzygIfBVJOPU5wPvbIk6pW02zSNwJrXOqVnKl17SVYljisZiwRj1uSUCgDu
         dQ0OCgdtwemBhxEYLAz4q8qK1XAix5DlRTSObG3pXdeNz7Czed057mimeD8qSS8xYrNI
         qtA0mmZaonjBAf6+nYub+v08IcolTB1yB9z8WdlukM8astVozXDIy9Sva2nvkMUQ8a+j
         R/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uzAuqtwkm46GspJerldWifZpeS2uUUcdgFDDV4iF0Yc=;
        b=5QRPida1CkAgPqKxYDPKyL5AGhpcay0D+8HmNO1SiTxFjHLGzciUSujfDLHosbKlfd
         zm5SDNDpVkJmbx7jD0C0S9bOIXJQnm2kSnEiLr7l3zdLpsBBgPoOonkLbq8aYh3BJnmg
         VHr+x8edA+RZsGRc7ln88aUpaD2GJ+rjHu9F4L+kE+OeozN/AbmA0ZVK18Spazjmf9Xx
         nBgY3BJbW1WtsznTEeGdT0iG3kw7WWgTbRntca7wlEhgNTtJmwcHVi+oNrehikxM9Fn8
         6lBzI/2Y+QACUDIK9ppyWitE7EfRkl3HDu3cXR598XIj65/1mHZgHhFlz6L5QMPY81ec
         Ug+g==
X-Gm-Message-State: AOAM531UEaLP8RW8fgjXG1OS7+xE9CF9wSgX20T8r+CpKsZIV8JvzoV6
        pvK4jOOaSF4hPHk8SI1k3Qk=
X-Google-Smtp-Source: ABdhPJy7ZXjFFrHR0aVM76ZkWCenQp0VXu5AZMjydR1p7at00cvcj9FndX4+x8BsGzBlg9+btiJKDA==
X-Received: by 2002:a05:6808:1485:b0:2dc:d320:ce57 with SMTP id e5-20020a056808148500b002dcd320ce57mr6621661oiw.298.1648241861726;
        Fri, 25 Mar 2022 13:57:41 -0700 (PDT)
Received: from t14s.localdomain ([179.232.121.194])
        by smtp.gmail.com with ESMTPSA id v8-20020a05683018c800b005cb39fc3e15sm3129743ote.13.2022.03.25.13.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 13:57:41 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 2F1001D1F05; Fri, 25 Mar 2022 17:57:39 -0300 (-03)
Date:   Fri, 25 Mar 2022 17:57:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH] sctp: replace usage of found with dedicated list
 iterator variable
Message-ID: <Yj4sw30tZ8DRG5qT@t14s.localdomain>
References: <20220324072257.62674-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324072257.62674-1-jakobkoschel@gmail.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Thu, Mar 24, 2022 at 08:22:57AM +0100, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
