Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090807;
	b=Rlae6bwbmK/jRbRGV9nyIHMzjXCJAeFyvhIYcgpHZ+vA5+Uup4OgmqU8FYwqMLKj9XIe
	 Yb9mp4Yiw/QXnyGPtKH1YRkFoJ4xgzQAhu5rwwO11Yb+1hJRpaWPrSVT4QVDL99N0utvy
	 dMpfvRko+wD1l3+/4zHZNzZtwiIwX4puI5aFY+ASvWAzVaiouG+AiPNNqY42QxRcZMOj2
	 JB83AfjurZ5Kxwt0TMicSUrgshdDFWUNqcSoW6/y7mB+J/l/bcIn9PLSLmzUKCVgY/o6I
	 ibDjPr/QsTyKmr8pskvPt0LeuOBuIEwdeVl+EMZcr1gmfrnXnITOI/LwT5fPW26ZfJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090807;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=2A2Wp+VOcoRYH14efvNOokF8L6m0/5cq7iHxRlrrVV4=;
	b=2Codjj3g7qK7H3Dv3fPdVNbZM1S0VTT94j9Zz1PyUcxYNO4QvrJmGxz8eivitDJdoRue
	 mblRh+cnNzY6jMWEouUYfHQ0+blQbF09mv5vXd2vcDFTnGINO+/zh/fa/TMcDVySxQrMf
	 ClMS6F8u8/gQRm7qQSTFsVXKqhMe5eyiFHm90HVzuhGJicIHSpydG6UrOOZaMa6sZzvIc
	 G59jTRoQp6yCBU2ig2KrRWGEg8KRjUtUk3vpQMWsFNU7rDMNUTsMJCjUljTNzpXDLY0yg
	 9sU6orPAYH77PVUUqWHDYpCAqdjGyEFMADNJ7lMH3Y3p15GLkjrE3FmW1JkmgmhDafw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VrYqqg45;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79150606A320;
	Thu, 19 Nov 2026 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VrYqqg45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447BF1F000C5;
	Thu, 19 Nov 2026 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795090807;
	bh=2A2Wp+VOcoRYH14efvNOokF8L6m0/5cq7iHxRlrrVV4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VrYqqg45dFes5bx5W2pYBS7nxqNhPH4eZlcvKkubdC+U12WtlhAHQF7wS3ZnWXJhe
	 u+AIlMAgdlWiKy8XL/vgeYFF5VdHrgnme9BXmMc5Q9syw0WAsNKuJerPZ+Qo/1C9rB
	 LTioWKoqVzmYAX97kcQLEZtXFi3c4SwXhI3CSw4Fe+EAjwWfjjQTL6Q+W9VDAEw/oe
	 lMmISFbE9GkLNw9MqfxNF6AAbNeuyayBFgolsutPAGtQTBwGT7L19q3vUHSSeIUS0t
	 aXSj+ATxz/98hbpxptUlzbc3+CeWk65fEiSR+u5/LFgNA5Hnge5Bw5dKA/h059xtOm
	 iAfndbDqlonKQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A2FB3808210;
	Thu, 19 Nov 2026 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] net: avoid truncated transport header offsets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179509080603.3058492.5089452129323552698.git-patchwork-notify@kernel.org>
Date: Thu, 19 Nov 2026 12:20:06 +0000
References: <20261113124625.4010206-1-edumazet@kernel.org>
In-Reply-To: <20261113124625.4010206-1-edumazet@kernel.org>
To: Eric Dumazet <edumazet@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 dsahern@kernel.org, idosch@nvidia.com, willemdebruijn.kernel@gmail.com,
 marcelo.leitner@gmail.com, lucien.xin@gmail.com, aconole@redhat.com,
 echaudro@redhat.com, i.maximets@ovn.org, daniel@iogearbox.net,
 justin.iurman@gmail.com, linus.luessing@c0d3.blue, sd@queasysnail.net,
 sbrivio@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org,
 linux-sctp@vger.kernel.org, dev@openvswitch.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 Nov 2026 13:46:20 +0100 you wrote:
> skb->transport_header is a 16-bit offset from skb->head, and U16_MAX
> is reserved as the "not set" value. skb_set_transport_header() silently
> truncates an offset that does not fit.
> 
> The first patch addresses the report from Hyunwoo Kim, by applying
> the IP6_MAX_EXT_HDRS_CNT limit to ipv6_gro_pull_exthdrs().
> 
> [...]

Here is the summary with links:
  - [net,1/5] ipv6: gro: limit the number of extension headers
    https://git.kernel.org/netdev/net/c/050f2adb6043
  - [net,2/5] ipv6: mcast: use skb_set_transport_header_careful() in ipv6_mc_check_exthdrs()
    https://git.kernel.org/netdev/net/c/425b1fe50b71
  - [net,3/5] net: openvswitch: use skb_set_transport_header_careful() in parse_ipv6hdr()
    https://git.kernel.org/netdev/net/c/b9b77e243003
  - [net,4/5] sctp: use skb_set_transport_header_careful() in sctp_v6_err()
    https://git.kernel.org/netdev/net/c/13391f1a8c58
  - [net,5/5] udp: use skb_set_transport_header_careful() in __udp6_lib_err_encap()
    https://git.kernel.org/netdev/net/c/02f578b736f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


