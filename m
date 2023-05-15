Return-Path: <linux-sctp-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9727CC7EE22
	for <linux-sctp@archiver.kernel.org>; Mon, 15 May 2023 08:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjEOIQM (ORCPT <rfc822;linux-sctp@archiver.kernel.org>);
        Mon, 15 May 2023 04:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjEOIQL (ORCPT
        <rfc822;linux-sctp@vger.kernel.org>); Mon, 15 May 2023 04:16:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF59593;
        Mon, 15 May 2023 01:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53ADF611BB;
        Mon, 15 May 2023 08:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41258C433EF;
        Mon, 15 May 2023 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684138569;
        bh=gSL2tuOqWpZ0taEm46ptIuXp6+GiMkpZNYVxUrwODIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiDz6NH8jUbxkuD9+PfRQ/QYzm6NUnKBzmSBCiQGutfXjoCLsAG7OkKDiQHvfmT/S
         97LZugsZmrFK2YEik54Iofh0vht55UfSWrIlmZjMjugdmgTYGqddgC9L5yis5/sLdm
         XOJCiqQNLX3zT7pfJ5Gk81KPQ+KM+IQRTRAoe7I+v/qH6LXHjAkNkYHcRjuFJHMS1i
         7SukXF1g6oX9uat9R50IKJFCaJDtZ6SsRjdpwiYqNvLvyYijoo7iK0d4FaO6XG2dGM
         IJE1AfAYj0IGC5qvem7XPycnodYyhz3SHWZgO95GLFFW1s4JR06U7tEUJewbFSDI96
         7yCBRU7dwQlDA==
Date:   Mon, 15 May 2023 10:16:03 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] sctp: add bpf_bypass_getsockopt proto
 callback
Message-ID: <20230515-unberechenbar-ergoss-4a2fc34870a0@brauner>
References: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
List-ID: <linux-sctp.vger.kernel.org>
X-Mailing-List: linux-sctp@vger.kernel.org

On Thu, May 11, 2023 at 03:25:06PM +0200, Alexander Mikhalitsyn wrote:
> Implement ->bpf_bypass_getsockopt proto callback and filter out
> SCTP_SOCKOPT_PEELOFF, SCTP_SOCKOPT_PEELOFF_FLAGS and SCTP_SOCKOPT_CONNECTX3
> socket options from running eBPF hook on them.
> 
> SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS options do fd_install(),
> and if BPF_CGROUP_RUN_PROG_GETSOCKOPT hook returns an error after success of
> the original handler sctp_getsockopt(...), userspace will receive an error
> from getsockopt syscall and will be not aware that fd was successfully
> installed into a fdtable.
> 
> As pointed by Marcelo Ricardo Leitner it seems reasonable to skip
> bpf getsockopt hook for SCTP_SOCKOPT_CONNECTX3 sockopt too.
> Because internaly, it triggers connect() and if error is masked
> then userspace will be confused.
> 
> This patch was born as a result of discussion around a new SCM_PIDFD interface:
> https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com/
> 
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: linux-sctp@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---

Reviewed-by: Christian Brauner <brauner@kernel.org>
