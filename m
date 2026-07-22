Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8143B3D1;
	Wed, 22 Jul 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754042; cv=none; b=jB+4Fa7tELmzLIWKaO7hyivxzGlLQyh/IcMk/S5zOxdqWwd3GrVTz86018rjNbKmARMSckmyryOxGwG1wkyw6+XAAi/5vkH05lxKWwYG5N6/Urh+e2CzW/S04IxM1NR2XKmxlsP2e5p7xhiBKOeIAlYVhb6+OX/sDsWh9c/ljiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754042; c=relaxed/simple;
	bh=98KXEL3e6PPr1XeLBt4PKV7CZ4wKVDatl8sfD6DUCxw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WCkUqouT3QPpLbE9T4v8gPg0xgyaseGQB9cEtlqeZnDqhNEVbnUDGB/2yifOdQLGg1cgXm3uYJIlP4Ai+r+IOtw/BXTrI1v2KCmJoceusnuMWxhIJyyZnhb+oZvJqVQ4B0WDwdPyiz7W11U+Xw0qaeqjkm6o8Ox9VdCmPivtVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frtnDYIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frtnDYIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B26D1F000E9;
	Wed, 22 Jul 2026 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784754040;
	bh=gZvOBtH8vAFy9BCB5ek8DGJ6epMY2gTdMkFXKntraxI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=frtnDYIt6WxSOVKKz3nFwvquvPZiGrUlrJYrbfEOByF04570TdNiME0qZaVOA9NGN
	 Yo9A+KaXsbFUizcY+ML71rC7UPEdkuCl+Er33aM0fkAyqcBElOuuvrfnHV0u1LCE0Z
	 Z5lXwZNLSXrV5QxVpxJ1RnzsZD8uaaSi3k+op2o1gFg18r3L48hWdj+XeXHZh82B3Q
	 SbLxqgvtTW84OgptOdbSU0fABCnxhULAnfQo3k6264LBx+zAiTgf011Vs7vlEylLiX
	 3FwnuNsynHnWVrh689VEQlGx98qA/Z3eTiZ2syTQWpQIpaSmjwKHTRK+ronOkQvVbl
	 9LUSREVwIuYiA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5699C380CED5;
	Wed, 22 Jul 2026 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] sctp: auth: verify auth requirement when
 auth_chunk is
 NULL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178475400889.2022998.5643327282281908086.git-patchwork-notify@kernel.org>
Date: Wed, 22 Jul 2026 21:00:08 +0000
References: <20260721015532.120157-2-l1138897701@163.com>
In-Reply-To: <20260721015532.120157-2-l1138897701@163.com>
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jul 2026 09:55:32 +0800 you wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> sctp_auth_chunk_verify() returns true unconditionally when
> chunk->auth_chunk is NULL, silently skipping authentication.
> This is incorrect when:
> 
> 1. skb_clone() failed in the BH receive path, leaving auth_chunk
>    NULL. In sctp_endpoint_bh_rcv() asoc is NULL for new
>    connections, so the early sctp_auth_recv_cid() check cannot
>    catch this.
> 
> [...]

Here is the summary with links:
  - [v4,net] sctp: auth: verify auth requirement when auth_chunk is NULL
    https://git.kernel.org/netdev/net/c/8e04823c120b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


