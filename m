Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADF5C433F5
	for <linux-sctp@archiver.kernel.org>; Thu, 17 Feb 2022 09:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiBQJnu (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Thu, 17 Feb 2022 04:43:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBQJnt (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Thu, 17 Feb 2022 04:43:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AB01704F
        for <linux-sctp@vger.kernel.org>; Thu, 17 Feb 2022 01:43:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8FBC521108;
        Thu, 17 Feb 2022 09:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645091014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMLInmOQBOfRxxxSqN1OsDaJao7PcodBVEmK0/ffCpc=;
        b=UtRq7p6eGsKNjVL2qw8z5oFvbnBfVW6V5bbaiZ9tBmgJLPEuVT08J8wB+QVxV4A708BWGn
        4foE/Kb6fFCq/DOKdqhQDjOVPhSM7jRlhk7q7Hem+W0uoP/HJqyAM/HEgTU+Ywa1mAGEXL
        IUeiaBsRyMz06521nky+3FXpBkUWdYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645091014;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMLInmOQBOfRxxxSqN1OsDaJao7PcodBVEmK0/ffCpc=;
        b=J+nbUw7fD53EIrpLtsyvtM0lw5B9yl4QJ/kA4cFY/k/mbZ/ipQX9gcs/9ucQGeG1sc/Omo
        nHrVU1YQ3s4PTDCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75F8D13BBF;
        Thu, 17 Feb 2022 09:43:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hJfWG8YYDmIHKgAAMHmgww
        (envelope-from <chrubis@suse.cz>); Thu, 17 Feb 2022 09:43:34 +0000
Date:   Thu, 17 Feb 2022 10:45:41 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org
Subject: Re: [PATCH 1/2] sctputil.h: Fix some formatting
Message-ID: <Yg4ZRSy3nmzB31D6@yuki>
References: <20220203170522.22051-1-pvorel@suse.cz>
 <20220203170522.22051-2-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203170522.22051-2-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

Hi!
> +	if (sk == -1)
> +		tst_brkm(TBROK, tst_exit, "socket: %s", strerror(errno));
> +
>  	return sk;
>  }

Also one more thing, we can just do TBROK | TERRNO instead of the
strerror() as well.

-- 
Cyril Hrubis
chrubis@suse.cz
