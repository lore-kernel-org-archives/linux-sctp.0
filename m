Return-Path: <linux-sctp-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628BDC433F5
	for <linux-sctp@archiver.kernel.org>; Fri, 22 Oct 2021 15:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C02761246
	for <linux-sctp@archiver.kernel.org>; Fri, 22 Oct 2021 15:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhJVPiS (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Fri, 22 Oct 2021 11:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232339AbhJVPiR (ORCPT <rfc822;linux-sctp@vger.kernel.org>);
        Fri, 22 Oct 2021 11:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C0566121F;
        Fri, 22 Oct 2021 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634916960;
        bh=0ZR8O9FlD5B7yu81apaRKl77Msj4he+jWK9IlKVr47Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SK0BjwWIcPOBwUfIaq06htaqtdstrZzYY9/8QWTllYKA0DR4Gkvk5Uh+bF/gMgKWT
         ceUGmz0tSkrjjHVz3UcF1ZKUcKQpJOYfNdATLU+UKEOc+K3cp80jlnXFu+AOuZcDOX
         eHeh1y/+o4pUV8WfgmhI/w0VPiqgBN+ANNiOhheR1nNcEi/OR0RZ1s6KQalNsiVeMu
         QmeUl7fP4Drx8Wqc4ddFoH45M1hr9ble+jp1dn1741IRKahrHt8gFSlA5QRMgp8Wbs
         542PU71C5rHQN+nTfp7BhQxR3WXIV3E92r8TKfkhzAgXdQZoxRey88vbf6rzmUeTnn
         7cBZMUkC2Q10Q==
Date:   Fri, 22 Oct 2021 08:35:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH net 1/4] security: pass asoc to sctp_assoc_request and
 sctp_sk_clone
Message-ID: <20211022083558.5fce8039@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <615570feca5b99958947a7fdb807bab1e82196ca.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
        <615570feca5b99958947a7fdb807bab1e82196ca.1634884487.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Fri, 22 Oct 2021 02:36:09 -0400 Xin Long wrote:
> This patch is to move secid and peer_secid from endpoint to association,
> and pass asoc to sctp_assoc_request and sctp_sk_clone instead of ep. As
> ep is the local endpoint and asoc represents a connection, and in SCTP
> one sk/ep could have multiple asoc/connection, saving secid/peer_secid
> for new asoc will overwrite the old asoc's.
> 
> Note that since asoc can be passed as NULL, security_sctp_assoc_request()
> is moved to the place right after the new_asoc is created in
> sctp_sf_do_5_1B_init() and sctp_sf_do_unexpected_init().
> 
> Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

missed one?

security/selinux/netlabel.c:274: warning: Function parameter or member
'asoc' not described in 'selinux_netlbl_sctp_assoc_request'
security/selinux/netlabel.c:274: warning: Excess function parameter 'ep' description in 'selinux_netlbl_sctp_assoc_request'
