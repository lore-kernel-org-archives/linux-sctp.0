Return-Path: <SRS0=JHyp=D2=vger.kernel.org=linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F86C433DF
	for <linux-sctp@archiver.kernel.org>; Mon, 19 Oct 2020 22:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B72F2237B
	for <linux-sctp@archiver.kernel.org>; Mon, 19 Oct 2020 22:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fi9chrdk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbgJSWOe (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 19 Oct 2020 18:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387948AbgJSWOd (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Mon, 19 Oct 2020 18:14:33 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2D7C0613CE;
        Mon, 19 Oct 2020 15:14:33 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id m9so964697qth.7;
        Mon, 19 Oct 2020 15:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6kB+6Lvm623DlzXsDekfd4reTJnZkIBHde2/tQAV37c=;
        b=Fi9chrdkC/UweSu7BssKF5bqOkutCb4so+5/Y+q629Vrk3tIbpaX+yePbjRLCKeAWS
         f7pUPpIRQjt/2LrJNSa3vcQNYS/HDngf8Hd5x7vZDzyhyTC8aPLecdhSZHFbaNsDS0JJ
         ULxhMTtUJ8wUkZ3Ysq9EzedSNzQ92CEzYe3zlb6B7LWHI4Ly2mNtXigOEZW6BeN+XNNL
         unf0dSEYjB4WruaU2wmdthM8ghtq0/UjyHhDKOnbiRwaQxpYCQHaWSyv+0GH4aZowjrB
         5JdL/QzwFiqX70+aSO1zdDmcqWZYvIiCWGqjVChvKhzTFV55KHk3ceXmK7yWav/1/OWf
         CtMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6kB+6Lvm623DlzXsDekfd4reTJnZkIBHde2/tQAV37c=;
        b=qC25FMlg1FDe3Gykv8ar9/iWkKovi4oeJfmklJ7pQ4PY6NIeYYfqNvJGQZij7UYQS7
         REixoWHiN/4iU7cBQJogamMGn3wVRF9GWdZ5FGChDamaB3Kt1MpEnkOeTUzm7XGb0HL4
         NoVkGns0FwKw7GK2QeBPaPzJ/wnGFxnFshFIM7LwXQ7k1c6d/7aXD9lpCKQpoJVSOd9r
         h+Bg8YSwhuqaksDa1GXw7cM08xWR1JvLsxCxhmMpDaLCF2CVKMF5z/Oi6it0oThmRwj2
         x1JnOCp8GMgPSEymmlDV0beHG7Znk1HZrxqICPiqXCe4xTcXeBcluerCvwtr1CGCn8pO
         ApPQ==
X-Gm-Message-State: AOAM533OOYRrHxGmHs3W5rCWuc8YoPLzDzuhwRjt/tVb2bI75SuUU0Vv
        3gKnj8No3cId+8meyU4FeZI=
X-Google-Smtp-Source: ABdhPJynYmNTickJ0EIs6xnJpkF0XxNMSOlqlFg9rUyQ1Qtg7SdnnwzSpZppohmfZOiqe4dL6gJx5w==
X-Received: by 2002:ac8:36ca:: with SMTP id b10mr1654314qtc.135.1603145672539;
        Mon, 19 Oct 2020 15:14:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:5091:9c4f:6b95:2ed0:130e])
        by smtp.gmail.com with ESMTPSA id r58sm535755qte.94.2020.10.19.15.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 15:14:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 145C0C1632; Mon, 19 Oct 2020 19:14:29 -0300 (-03)
Date:   Mon, 19 Oct 2020 19:14:29 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv4 net-next 07/16] sctp: add encap_port for netns sock
 asoc and transport
Message-ID: <20201019221429.GC11030@localhost.localdomain>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org
Message-ID: <20201019221429.JUrvlcIvQcz6mqL_A88xNwNpukeaj2TdvmuuaDHShn8@z>

On Mon, Oct 19, 2020 at 08:25:24PM +0800, Xin Long wrote:
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2640,6 +2640,15 @@ addr_scope_policy - INTEGER
>  
>  	Default: 1
>  
> +encap_port - INTEGER
> +	The default remote UDP encapsalution port.
                                     ^^^ typo

> +	When UDP tunneling is enabled, this global value is used to set
> +	the dest port for the udp header of outgoing packets by default.
                              ^^^ uppercase as well
> +	Users can also change the value for each sock/asoc/transport by
> +	using setsockopt.

Please also add something like:
	For further information, please refer to RFC6951.

> +
> +	Default: 0
> +


