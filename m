Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687416;
	b=hy99FV9407TSxYBSCE2iLUeQy2HM492wPuriWddVl4419NEmcOeInABZx1yRTgOIV4vx
	 oqQnU0ZEc3Twf5UEDIADYE7JjQb7S0yInMf52gjhEvSE/H1LTxP/3fJBLW8EcICjEPbZ7
	 YJNloMjueiUv8jKBHu+3WMcgDfy+CNLA8hK/4nO2jK81s7kbCVZUoPq/Hj6Z26FT8rr1/
	 Or+iOYX1+W6FyUr2/XR9Y6Cy0zf3+LrRBtmd3xiE7cENSFucDaX75DtPLgLb1XdAR1i9o
	 kZpC7rAnTcoXbogqBmHIhfy5I+oc21fyQkU9X1syUSUhm3jBJZBAK+SaniAEY1qgAQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=Lg9dkbeTk2JSP9ScggLjlywqb2yBGxcuU6EEQsVamzB7X0LsdBrHRy4IyYFmU2NOHuFh
	 PbCpKESc3rExa2jqHDdxxU9Zv5J8h8m8vieq4RO5QG6Ujtx+ViCBawwuWhJwwufkepmtf
	 XFOuLLsRD0LabFkUQJIrwDmZS3DCm9wmOls2yvBLl1fKUodw4Ztw5VhuFC8by3QznP/oI
	 VuL2kUNQfet9SXtbOG/B3pgEU6sf6p3Q9rrI8WUVc+hxjN2Zcxv8/xnYrk8u/L1iHlnt9
	 KA//oyYdDvTUO9WWnBn0zP351q8v1wjxdsqkHfYhVHysWW9GVPgH2JcBtpt3sM7sGrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IaF1Ma/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59170606A31A;
	Thu, 22 Oct 2026 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IaF1Ma/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A1E1F01825;
	Thu, 22 Oct 2026 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792687415;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IaF1Ma/Gc3oTBrdND4yt8S5b7u7onXPw09OaZ14NtoedQ+U3WBerdj0+RkbAu5yQ/
	 PPv9RKOrSWDZNykDGOPT44H5dZFPhdRgA0e0vNZW0ej+XO5aYpi9PDU7psdgbsRgEj
	 DtWo4VOR1HzU9m4/nuCXZnKoKJCdVnkXTh6SUCXjFJbytHUYcJQcLMiZ7PqF00fIsE
	 E2gvXcxaW6UmO4WeIE3FAlDFIuuuA2lK1wKNexQKBrgbxObGxEJPJ6C60b/HFc4yGG
	 YaiU/KBQLNRll/Nu5IWPV3hxRHaoEQCS7cZUbi/MSjqAPYV66OPOCQoxHbvL+VW/4N
	 CHxW1D/uWHP0w==
From: netdev-bot+sinfo@kernel.org
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Jun Yang <junvyyang@tencent.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix ASCONF address change on single-homed hosts
Date: Thu, 22 Oct 2026 16:43:34 +0000
Message-ID: <179268741461.3290.3758686501946119458@kernel.org>
In-Reply-To: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
References: <20261022163639.2566945-1-andrey.misyrov@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
