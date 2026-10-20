Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508455;
	b=MCmjW0LwmbzfpIuJK0hCX3RfFdESuBeSY8TtlWPYleIuoi1KsKBoP1ukkVwJDMZyU2d5
	 ndLrkzXNAzQBwKnQPt8JVwFPwADBSto7Kpk8BjOs4kLySOS2t6JXfqlgARR+jlEgAIJ0+
	 kjnahBWcwjOs/+TIfALwPAuI6U7VeUXlzOTPUZwpOg2Oxd8SPKs64l5GXv2Hrt2Px5qL7
	 LBzqsy3i8Ly7Kk3PjkjbsX3l7Z4+DpEE2muOctc1WmTrtJAjLSvTn04dREPej+Y3e9WUQ
	 py5oBCUKPrmwm3Lfp9G+VKASS3L6d0ytrFvFx3OxUNxU4gLBc6A4YULYoTXCUQjF7KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tXs1R/Pc8fPj3MZ2A9bwsOFFGo9wKdk1WOT8dGH7DfI=;
	b=Ut64P42lTcZecpCchfl6uT2QSkfWmn7McMLQ1D/It7DLW6wgg+wEtGMSecFZZRqQCvkj
	 TZVhmafGPdtYUYTqLZ0cvxZ/MIC+VtIkxG2Zjq/zQ28XF75UcGS+p18lygtXxbWxB62vM
	 tSsWGUdyn51mQgB1JbCuCSUWNmQHa8zZfg+IfJkXGmquHVQTasfQsmw5C5AYF7xCIwCkf
	 QoR2PGv783JmCPq7nynhSV8fHvIYZ0knYVDTILSwo4Ec4G/NMq8PzUV9RoQDvqIOD6mh0
	 2kyBWZpvniytp7u+/wysNU1bJTbBX19L3TSsxnzKCyA7KZA+qGqZaitzGs3uzc8Tbpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="N5jZt3/b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AE4606A31E;
	Tue, 20 Oct 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N5jZt3/b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D791F000C4;
	Tue, 20 Oct 2026 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508455;
	bh=tXs1R/Pc8fPj3MZ2A9bwsOFFGo9wKdk1WOT8dGH7DfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5jZt3/bavAkK5vTeGgezwT/UiXeU3mx9vQshsEIGIVKda4Q7A9o+sZoS9lPU51tM
	 w1Q/4/RbRnRKrt40kORad1w35T6G0BjaVeLZsAiLCYTrDmnAnMZmcU5F+ZVwZVzqTz
	 /aPcGd+6G1k+Fc+6dj4laAyX2lSorYTwfaOi+IuWPghT3ysHgflyU3ZfCgrMu9LqU9
	 lfao/hb75wbkaRoxFNkdQP0wez5hcf5KJCN68VUb97/jeTU3hd4dCewi0V5CJQYbs5
	 jDpcTksAnAe8Xlz/RQU59/I31P1SHOuDxsPPsBQgFGf82HpT2ESFdbOomvlUsCQna8
	 0xgEkz+JgwZUA==
From: Sasha Levin <sashal@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Qing Luo <luoqing@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] sctp: auth: propagate HMAC calculation errors to callers
Date: Tue, 20 Oct 2026 11:00:24 -0400
Message-ID: <20261020150024.3643458-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CADvbK_d3hcGcP21Fy_z9hkoSuQT0Bg7111Ejns_WxOYfCCGFHw@mail.gmail.com>
References: <20261019135441.1420968-252-sashal@kernel.org> <20261019172836.GA1885@quark> <CADvbK_d3hcGcP21Fy_z9hkoSuQT0Bg7111Ejns_WxOYfCCGFHw@mail.gmail.com>
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

On Tue, Oct 20, 2026 at 09:52:16AM -0400, Xin Long wrote:
>On Mon, Oct 19, 2026 at 1:28 PM Eric Biggers <ebiggers@kernel.org> wrote:
>> I don't think this backport can be considered complete without handling
>> that case.
>
>Agreed. We should return the error from crypto_shash_setkey() when
>it fails in sctp_auth_calculate_hmac().

I've dropped it from all trees. If you'd like it in stable, I'm happy to
take backports that also return the crypto_shash_setkey() error.

-- 
Thanks,
Sasha
