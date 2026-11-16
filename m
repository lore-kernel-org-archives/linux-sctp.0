Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800612;
	b=BSKUgtDydw7l3mcIJfZrZMPoKqgx/st8w8vvU83SbHlHznyNejilOb2WASK4kcRSKYzy
	 99ub6wUP/b6fwYWbtPq3TEDnGJzoQ1mXeme4XYmI//cnin3fGgw6gwURT5UVCAdDyx/TP
	 JpVVoOhZwoxc4IOVNfDRyXD7QSkqp3Vz1OUOccZlpaiWVeEiv5Sc1IYHroDD0crrN0b24
	 SsUlggYMs3E2DBMIYZV++V5pOXYXK328+//LGHliot0AKsy5qx5fSDT5WWh3sZDb7gRyb
	 bkGC+T/hp4XelN05iKV5Rdb+1mgRSled2AIqq8RlSDksQxXcUdQRmU90RzETM14AR4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	b=cc1nrKAjqde8Zbwe1eGbwB+sFUG7dc9/fyy2kPLfibUX0ySxiey0EOSlEZwsMHFsleov
	 9ThuTWp1wI68LkomJ2kBvZvSjiFoNqBtCG60h+evfdlGPjBAcwNH0Jf256oRYh1vJWPwc
	 CL0xEpI9uJLWRM1BGX/yF1d9rCtjap6NNgdCF4HQJA3RRhanAJoxkzWqwtZLEdV4S4eNf
	 7QSiJjQBSLSH4CmD1xFZ2YzCAWBeaFV156U2MttOrPsuQQGFpAuqZQmUPo+v6M5LjPzND
	 XoqBkcawYv8uAmIHX9TkBsOsG7adjIMog41htHEYuR2HcdZsRjIR6eY08+g1S3/fayw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OH9Qf3dV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CC7606A32F;
	Mon, 16 Nov 2026 03:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OH9Qf3dV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD631F000CC;
	Mon, 16 Nov 2026 03:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794800612;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OH9Qf3dVNYp3H445PQqgLbOI+IyNmG/WoQKKc/Qp1kZDzB3sEjLPZG4ILeZqD0M91
	 PP9CftiQTud+e2YHRDACoh8zXTpjgo3KvbAwyvZWrhLu9d2EUFXPD21untSFBg8SO0
	 SM523qwLJ47IDx7xJPO5O+BO7IxkdOnAtEVAb1CXRistkL+UOZdA170MXl6rvzOTkC
	 ProlWsVaL4T5FRvYC/lZiSE+cedHrsCMxNN00KAv67GKrGexRDuZXr823B35vxJdcs
	 Vr7OGDOZmAkPpx/0YWG4h9Lchxydyq+IQXS5YITQjQj5V5v1zBXtx3aT4xfOLXlic0
	 Q6l9nRloM1IuQ==
From: netdev-bot+sinfo@kernel.org
To: Yong Liu <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH net v3] sctp: fix use-after-free after association migration
Date: Mon, 16 Nov 2026 03:43:31 +0000
Message-ID: <179480061110.3291.15316004866558271126@kernel.org>
In-Reply-To: <20261116033855.1792036-1-pkfxxxing@gmail.com>
References: <20261116033855.1792036-1-pkfxxxing@gmail.com>
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
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
