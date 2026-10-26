Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992474;
	b=mQeSuBaERdKLQP+kVg1iRu4dM/KGRZcCNfMajC3ogI35e6h4Y1wd/zXIi1CnrUknaR+3
	 /JmuvjujNXp+aQrPorCACBt3n9G/tEi95zH0hTdF1CSvFIZCYhuQ4VtQjnVkp8VZL58Im
	 WGqMSNxpvst/icpEfY3MY1VVK3fxr9ck8+dXItJCnyLi5lcSQVedjrW+0a9R2oTRQiTnD
	 qmly+rOZeXCreLRQTXEarpN/+uNaPSmfRu71U44AsfC6OOKYtGwbgAPh4iXY6yOvchFhn
	 Un+EjIY97lH/lleTu+7i15rZp8chNwxTzBDTFAMumg9O83gWon+boBkIQwU37f3VlLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2vVLfr5r23oMNsvxAvIsVWSucEEuXtAs0YtxOnot1U=;
	b=FxiimsUIMJtzBsD9R6Hvj5ei5JbdVqRO76OSb6P4G83H+Xc1sYkAT9q0MyQ3UU0JmIu4
	 iTfCnbzdsC2G1Wp0Eg8i99lCQk1cQD5Nw2oF2KvPGkMi41vVjf4NVrauQsaKe1QQkPjXi
	 qYN4OFbZOSNpTjPHGv6Xb/U91u4koLigM0Nkp4bXnHgLSIW8q/faVlgwvlDL9VcZMrTsw
	 SBqJPPrlgjchhHDEtCm2gc/0QM94JVzBSMTCLrj8CDMLs4udRN6qx7vgT209LXawH5WCx
	 mf2TrrV9O04QGJ+Fdutj7dyFsRo4smtFF8jpmGJxjiSH9tBRkd4xMMFHZhW4VYB3OKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="jMP/3eHG";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1E3606A31B
	for <linux-sctp@vger.kernel.org>; Mon, 26 Oct 2026 05:27:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E1E3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jMP/3eHG
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-156cbe59524so1704312c88.1
        for <linux-sctp@vger.kernel.org>; Sun, 25 Oct 2026 22:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792992473; x=1793597273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c2vVLfr5r23oMNsvxAvIsVWSucEEuXtAs0YtxOnot1U=;
        b=jMP/3eHG+EcjoJUjkHbgDNSNscVw1lpaVMGVmlUpSZzj8OH+U3b1U1M2BhE2Mv8I9+
         vqrrRNa5OA9HhlhBVpqgpBpk+jw8d9HwWsf/blISembtKeT6gaD0G3HT7EacBY1BhFNA
         QazbKzpgew+ACfErhewIOJ3thbxuc2XrD5GfdKyk8zl6bM+EIWPMksj6qQ3oBrXZOzwC
         mpWCSIUiPObAEG/CqyHrzXy7Fa4E05tF/kJHXvIHnKYcNxDDGyyKgG36WcNdxV5hs+0E
         rXurmLsgyIVpwv09sjXTYPzp89m0LKWKukArbhcO9O1hgvfCJNbxYu4tl3umhJy8fGfi
         dynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992473; x=1793597273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c2vVLfr5r23oMNsvxAvIsVWSucEEuXtAs0YtxOnot1U=;
        b=dn3KDqcbbJdEMU/k/KQlgO4FZVCF2p+HOtQqpitF5XBe54g6cH8f3cCijX0Zm6PZIQ
         R9VGoWgZsEQUSJkrxhYeuxfNiXz398MuD8doQqAU6psjxVoicXuAhFzazX+YS3NQ8jxU
         fU3qcOlK2UfcOZeYd4Uz9qspjDhhBILBLiSnXRzmNileRn7qDMVssIUmNO4lVhVHnmnb
         2+mUBsdwddDHt0I2gFYth+fXRuzZAImMk/aBTrDD5qlQXY12qVveg6MCj8oeDMqWaHiU
         AK5csXoMQ/MG+XDJKvvouAwZOVGr3ck7omhfFdh8fqpcwR/Q6gmoiMjS2/pxNKGzwcRL
         0xQw==
X-Forwarded-Encrypted: i=1; AKwUvBy9s++vazbhjDyc37P7k8cbn/bOCePBSao1rWsVaYt9wRFm0zXSgKtxM1VRSTubHUf5CGeC2buXN6F8@vger.kernel.org
X-Gm-Message-State: AFq9FYIZR//nKU/TB++0M5rUMhE9sUmrj2ZrX0myQTRS+n+GWZ9uQjJt
	IvNvCCbqMWHfHi+xC5pbk59Nh92qbEWJ0zg+W732sbU8zUwynNeagjVp
X-Gm-Gg: AYBFou3th8ksdb/D0fdCIp4BUdClOf09vylDrXFLIRAD0LnGUW5XVaGRUzZz15a06Na
	bF8KvDtSMJj90H4mRwY04+AvYnejQ7GwuZf9DVRQbp/oEFpz8nK/m86dedKgJwAI+kOSEZMxuco
	72ukzJkNPDuGMirgxM8Q+7i5zLtYV032RTShryTqhTkmngG5D8c34Vt+LCDZc6mABdGSsLggyC2
	QwY27sZLY8FQw1oE+nTPkN+8qeWUxJxmdERbinKQSLppORadllUu3iO+I2O0pM5NLIK2PJoPhD9
	seq4ZbVQ0pXLdOMfqaDc00bvb52VSLjhxEq6/dMJNLyg79wWWoICemC3oq9ZGqkBdcaHZDkNiHF
	ClYxrSwoijQrilVeOraGBokzlbGrBignjVRUHOA6q9pPpge40gDonZqUWpHv8aZT28Kzu8PG4t8
	4Zy8J8mjuZoDwa8bRAO39//7lyKx6fBYqvyBq0zX5fpaUyAN7WC+EQ4VR+XsiP4Gsoc3/rTuKWF
	oFIYnwpO+8YcP3k/1MRyYMaDYpOZtC2ORcsqCB3/opMKEgrTUnw1n9PtbhOdNmX1uL4ZogOEKmt
	nz1f/3bQkF2Zh42zh05vKWAPaw==
X-Received: by 2002:a05:7022:b04b:10b0:164:4e36:f956 with SMTP id a92af1059eb24-19935905c52mr8981726c88.16.1792992473149;
        Sun, 25 Oct 2026 22:27:53 -0700 (PDT)
Received: from localhost.localdomain ([136.25.42.214])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0e8d700sm25064523c88.10.2026.10.25.22.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:27:52 -0700 (PDT)
From: Tim Budding <tim.budding@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net 4/4] selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving
Date: Sun, 25 Oct 2026 22:27:48 -0700
Message-Id: <20261026052748.187496-1-tim.budding@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179293012994.3134.15218902499880345860@kernel.org>
References: <20261024120627.837568-5-tim.budding@gmail.com> <179293012994.3134.15218902499880345860@kernel.org>
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

On Sun, 25 Oct 2026 12:08:49 +0000, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> This isn't a bug, but the deadline check and the poll() timeout use two
> separate now_ms() samples. If end - now_ms() comes out negative, poll()
> blocks with no timeout.

Agreed, I'll fix it in v2.

> [Severity: Low]
> Does the reset case check that queued I-DATA is discarded on reset?

[...]

> The test does show that MIDs restart at 0, because the marker is
> delivered. Could the test leave stale fragments, or a message in partial
> delivery, pending on the server when the reset is issued?

Agreed. As it stands, the reset test only shows that the reset
completes and that MIDs start again from 0. A reset is only performed
when the data sender has nothing outstanding, so in v2 the pending data
will come from two PR-SCTP messages that the client abandons while nft
drops the I-FORWARD-TSN: one partly received on stream 0 and one in
partial delivery on stream 1. The reset is requested once by the server
and once by the client, so that both new abort_pd() calls are covered.
The test then checks for SCTP_PARTIAL_DELIVERY_ABORTED on stream 1,
that RX_QUEUE is 0, and that a new fragmented message on stream 0,
which reuses MID 0, is delivered intact.

> [Severity: Medium]
> Can the RX_QUEUE check fail on a correct kernel in the ordered and
> unordered tests?

[...]

> Should this poll assoc_rx_queue() until it reaches 0, with a timeout?
> Or wait for some sign on the server that the I-FORWARD-TSN was
> processed?

Yes, confirmed. Lowering net.core.wmem_default alone wasn't enough:
there were no failures in 140 runs between 212992 and 66000. small is
then sent after all of big, but Nagle holds the marker back until small
is abandoned, and it then goes out in the same packet as the
I-FORWARD-TSN, behind it. With SCTP_NODELAY on the client and
wmem_default=70000, the ordered and unordered tests fail 10 times out
of 10 with "2464 bytes left queued on the association": the marker
goes out right after small, and the I-FORWARD-TSN follows one RTO
(300 ms) later.

Rather than poll RX_QUEUE, v2 will have the client wait (with a
timeout) until all of its data has been acked, i.e. until SCTP_STATUS
sstat_unackdata is 0, and then check RX_QUEUE once. The server's
cumulative TSN can only move past the abandoned TSN once it has
processed the I-FORWARD-TSN, so the check no longer depends on timing.
