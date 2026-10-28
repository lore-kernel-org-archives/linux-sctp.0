Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793176272;
	b=ZUKbBMo2mLJYJXoLMJqOBkVy/ykGsqW8GHEV47EkbOVDrZEYUS9YgjwHJgvRQ07+t0ek
	 Icao5f19QWFnI7nldcCxXd/ZB7SFgyWcdMhfQtLQUMbHj4rDrc1PiBoj2McPGrkcCVLsi
	 aLAjD2KvWJ9pcrmz8YshWcjbZ+pLZO9hNbHZYZ7n1seW9XzBoWlK1nnTiBh3tZnQD8MU7
	 MM4/sXDP8ekf7Qt8E4Im7rKdlOHJLeBVIBUzK1qyIQEHCAXlTr6fPLwYzt7WeeCcFgMXq
	 AJylqrsu1A1h81aMm0Ceg3yhdDiqcsl0c1tF/RGN0VbC53S8Y9kP6iPwOhziWZUQ6PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793176272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=eAHQl3zIgzKTPq2clVDEXlT2Vz1gLyDuGtHlHT/emVMtuT85k2ofNpi+fc6A0rehBM45
	 aUPdDCLKd7KuwaXC+1pfp88PBxIgEUrAWVUI5FPxUND0CeFIi9PC8ejJkS3N3IDEbKTbR
	 2zgeqU4GgUG13NHM9rwwePklz4M/To22hmILEHjtgkk94VMl/jrze4yYFLM7j8hIaWqHD
	 AX/XppMC8jKrjsz1zHV2XVTqiQTHaxb0xgiNUb9uDElmfJUjRl8ufbAmS1ocu6Nqxyo+P
	 jwyPnI2qNUqYEfyQnYG8yU4ysJitGnQOCps55rIKxNVfJHrEfpfqF+p6q4rbV+t399w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="VQBi/bFR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8162A606A32A;
	Wed, 28 Oct 2026 08:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VQBi/bFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3551F031E0;
	Wed, 28 Oct 2026 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176272;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQBi/bFRTAByL9q3LEyBOxQNgqiMH7V7fgMvCtdQT1wnnPS37pFD7VpbEPlrNkuX/
	 MldPdysWqbjzzYIIS6K4YddlFBfEP+AYbXxVRFF5R/eis9kdgXI0xf6gixKGH6GDJ7
	 8l96QwiJFS/H/hCHMjslIpfWXXTX4LnKZN97OrthsMmGyCWdTHSV5cKZPgoVLTq7DP
	 VlS3Fmjryq5sv/0yaQ2UckK1ZKJbl18MXdLxYSF/jmYJrVmCF6Yu/zkELJ4LH7xB95
	 JKOVGlXz4SWBMzKKZy9nn9kztY5BiNSozBPbxRKPce0WBRdMpSNPQGiF8h7+ZqBX3H
	 WKPKdnmlZ7mdg==
From: netdev-bot+sinfo@kernel.org
To: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
Cc: mptcp@lists.linux.dev, matttbe@kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Kees Cook <kees@kernel.org>,
 David Ahern <dsahern@kernel.org>, Willem de Bruijn <willemb@google.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-sctp@vger.kernel.org
Subject: Re: [RFC net-next v11 1/2] inet_diag: pass net_admin to get_info
Date: Wed, 28 Oct 2026 08:31:10 +0000
Message-ID: <179317627056.3327.10816635120441836463@kernel.org>
In-Reply-To: <20261028082704.1609493-2-kalpan.jani@mpiricsoftware.com>
References: <1ec0c2b5-a0fa-44e8-9ae8-dca9b7f90ec6@kernel.org>
 <20261028082704.1609493-1-kalpan.jani@mpiricsoftware.com>
 <20261028082704.1609493-2-kalpan.jani@mpiricsoftware.com>
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

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
