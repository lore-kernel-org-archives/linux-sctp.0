Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B043F343D9D
	for <linux-sctp@vger.kernel.org>; Fri, 10 Apr 2026 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775847836; cv=none; b=Z22DHbtXfDfbRJ146KwCrSm2KxBrc7psbSL6vYoAvsQnFv09STWN1C2E8jBca7JyJyjuMfQ3c/xtE3fk7z/+4VQsAcB9opprey31iNEhOWJN5A2Up0K8OpBaOC6Xs/eyX7py0Wm4wAtwvmBdsELGdUlc7mzal+r1sZKSiIEen/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775847836; c=relaxed/simple;
	bh=A0fojv7pXOhmyXaSwDORGhPki46B9qck8V2QJFu+E9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/0eZ/CrxRBgy57JaWUoZyxjQfk81PlMG0ZXlVaRFSTKZIMujqW7J8gGOIeS+fZEWiNDnNWjnu3s6wlDwkcNaMI3fctFp6zTjOa62Dj1o7R/X/HjSltif0+N/OKPikb69n/6Sl83Ejfyek2BzZ15k1QYzPG+3s7xMzV7j6JbVtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pn82iTrJ; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pn82iTrJ"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-605159dd396so796092137.3
        for <linux-sctp@vger.kernel.org>; Fri, 10 Apr 2026 12:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775847835; x=1776452635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jOF2ctLto8Cga4gZZCbhmetTXKvSPuUuwNvxhc3GL68=;
        b=pn82iTrJ25XuynqdHN7Si1VGgk7a1zPTJtNFddCcsmm5MMYgm4Hrtf2/fdOC6jOsIq
         7AncFIPcwZuhwl95Xafk7Q5O12xfJmoRtpP3mfJaXCib8RtG02/DPzRQweWEU55x6Z7B
         8r+xIkqgq+iW5g9nNi5U3MCEN1ZukUoU1FTIBwqyuAJH3HpZ0LREnVAHFxUZNASucUXV
         cbxAx8BOHPhhqvLHAZbwz2ZUKZSqy8tU4MGzL2lBUb4wY9IxnyvSJdJy7K7738hWbXmg
         Xa/KoGVpWjBb3JHGAj/N2AlwpOEbV9JreH9rVeI2fj9OUJ4GLRn13aTXdp1yrVfoY8k+
         7wNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775847835; x=1776452635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jOF2ctLto8Cga4gZZCbhmetTXKvSPuUuwNvxhc3GL68=;
        b=bZ8KeQGQAOV8LGntJpE0o2FkAiDNArL+a/hbJw+mA1ZgOqtO4YoMa+YiYU89P8IyqQ
         8iJMr3NlbNg+kR42szk/Od6iS2zS1fVGUo3ktKMhIz5ulFPCh87wSSXU4wyKxjTlJL9q
         Ot3hhaOju1X+gmQqIO6wyOAdFRE+c1BAOh/jp9fmV+5AkxPohr0NpUdibkbp3sZ5SSp0
         sT8YKgm8y55sCg7mjXgeW3sOUJYKHaLtTFUduDtAeRpvsw6rqzcnHk2ez1dobEICb8ug
         H0TDa+0p516jLL2XP9MKsbDVA5ZTJ/1LZw/E7Crs8Nvd4ynsHUNBo2Q3WZNIy6G2kPh6
         dveg==
X-Forwarded-Encrypted: i=1; AJvYcCV06TsHPBi06GMxSUEPamVFke+aEq8kTLR9LFBue/9c+5ZfZvlwH/nncQbVUZGzOXYF5qdAfC64W1Mt@vger.kernel.org
X-Gm-Message-State: AOJu0YwujPfQVDcFcdtdTSGGh0jb/6IrZusMwgiKIP3oONOfWi91cgcA
	X3wAPKV7Pm6J8tyQ7F3q9xho9TPH9fcM9hMtcWeQ+YFG7ZcwgtYqWEYA
X-Gm-Gg: AeBDieuJDhjDYTjtDn37fLd7befuSIHo0cFggXVguwlwp+zSOKIbNptNZSrFDYdH7ek
	JiONRKcRZJfhoZrGSTurcRiwkf8PJsrCvOg2AVv1JfYLWZUwdbczHxQfT8xgSNd9+a8SDsG2D9g
	Aup8YakovcqaF41zpGlrlJ2KdVBCHMPET5v5+sPTG0tjiqvAEBEF0icYPWKNidq6s4KNe1eak7t
	njiy70n/4Kg6/g6OBZLXejYIiZ5SXZRICkcpAOCH5joLApHxReCVsIb46kiX0n09X5FVQ+L1mni
	pEgmFxDu5qMNYWwbqlKtm6Fk3gbgU6cFPOADFnH8BzJTyeC5H/ubvj2vTsqSR/ic5MGchr6E8Wm
	lgOBl6MuuUImS0a7zA7G1XA0L54wDESkJpGLWubRTY6W2h3yOrT00BrNhboUm6RBrxUE5GZKz3Q
	PLFYmFJfNcsGe/eyV9dGB7fIc6hyuRi3IYUewd0WRs3tlYB5RbD7+e5hZvVfyjYQHXEfu/ehF/0
	r1AuJ1zrR+RLwXP7FZ3Novyr2uowKxrJiQV0/FFMM2fHLsDq8rL2JyLK4j4rRz/sgtRB13w6Nc=
X-Received: by 2002:a05:6102:1621:b0:608:6d10:e415 with SMTP id ada2fe7eead31-609fe9b1602mr2080445137.8.1775847834660;
        Fri, 10 Apr 2026 12:03:54 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a47a0dsm30598726d6.22.2026.04.10.12.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 12:03:53 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH net 2/2] sctp: discard stale INIT after handshake completion
Date: Fri, 10 Apr 2026 14:59:17 -0400
Message-ID: <bea8a0dfcc56b9980cb914b54cffa9dd9948ba75.1775847557.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1775847557.git.lucien.xin@gmail.com>
References: <cover.1775847557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

After an association reaches ESTABLISHED, the peer’s init_tag is already
known from the handshake. Any subsequent INIT with the same init_tag is
not a valid restart, but a delayed or duplicate INIT.

Drop such INIT chunks in sctp_sf_do_unexpected_init() instead of
processing them as new association attempts.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7b823d759141..3bec026ecbc0 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1556,6 +1556,12 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	/* Tag the variable length parameters.  */
 	chunk->param_hdr.v = skb_pull(chunk->skb, sizeof(struct sctp_inithdr));
 
+	if (asoc->state >= SCTP_STATE_ESTABLISHED) {
+		/* Discard INIT matching peer vtag after handshake completion (stale INIT). */
+		if (chunk->subh.init_hdr->init_tag == asoc->peer.i.init_tag)
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
 	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
-- 
2.47.1

