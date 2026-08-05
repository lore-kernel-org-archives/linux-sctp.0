Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA84756B2;
	Wed,  5 Aug 2026 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785933339; cv=none; b=dCi9c/jz3oT1grVAXJ5A7yWoBWTkCciQm0pEULtmGSFTp5D0MQyii/67SvWRF4vT2I2+gOregPRO9z6cWTNMsanWWowLN8MNXKMMrAzgi8/1lilrg+iDuY0QNt/L4+m0AsXl8MwkzDGnI2Ertr53+31Wp6ADABWMg3l1ZfmuzO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785933339; c=relaxed/simple;
	bh=1i+o+YR5ep/8AdzKp+ojS8afAGeMCtI9FNH+zSLiSGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YckqXHFLT9PnrXMys2OF5BuP7M5oL2XklYKemD65HxndOUdrj7qs3DlPVZrIEV8MZhxEjqIJWlTHaAAKfEHD3Ii18Y/LhxAo6wB5xq+QJoxvq+Hs5HC6PI/zY67+5LmPJPYouGUTBet37i9taVo6yOrqGSYQcyOAmtcMQjhfj9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnyGSi7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnyGSi7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DBE1F00A3D;
	Wed,  5 Aug 2026 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785933337;
	bh=i9Ym0jAKLrceLlkhNVC44kdENs/0Kse5nUlY5Q8Bm0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnyGSi7XKOQQIai1+vo+Vss7EnNNQn0JoiqMG/3fTz/xPfIHlo8GBYLS/2aDJI9IU
	 SylgiYQyPp1B2iSzOpKI1jnL6qTQnmubUh19e+KErEaIo42BjPgAYbWXD0f9VuQSeC
	 QIPOf68HBC5Gx5qkUvY9pvkGzs81KvrrdLqUwoIaPluverlTZeR76EZqhBv7r955YQ
	 V9ySu2iZrS/TeEiM+sX8F6yYscvllEOq+eKEjU/OgUXy+oH3Gep9SvClzUu15LtkiW
	 Kfn18lxw2w/L92bjOOnJX2z4po9av/uaijxpKD54It7mXFP92To6fsDvdLlvD+TaU+
	 tRI/5Y1BWpsBw==
From: Simon Horman <horms@kernel.org>
To: juny24602@gmail.com
Cc: Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	junvyyang@tencent.com,
	stable@kernel.org,
	corvus@tencent.com,
	lucien.xin@gmail.com,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] sctp: fix stream->outcnt underflow on duplicate RECONF responses
Date: Wed,  5 Aug 2026 13:35:25 +0100
Message-ID: <20260805123525.571744-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804113100.37840-1-juny24602@gmail.com>
References: <20260804113100.37840-1-juny24602@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev/#/patchset/20260804113100.37840-1-juny24602@gmail.com?part=1
---
--- Patch [1]: [PATCH net v2] sctp: fix stream->outcnt underflow on duplicate RECONF responses ---
commit 9a827b81b27b219603b09c1f04c9dbc9a6dd2368
Author: Jun Yang <junvyyang@tencent.com>

sctp: fix stream->outcnt underflow on duplicate RECONF responses

This commit addresses a bug where duplicate RECONF responses could cause
stream->outcnt to underflow. It converts strreset_outstanding into a bitmask
to track request parameter types, ensuring duplicate responses are ignored.

> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 34ffe6c945a4b..cb7543929d657 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c

[ ... ]

> @@ -928,7 +936,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
>  	__u32 result;
>  
>  	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0);
> -	if (!req)
> +	if (!req || !SCTP_STRRESET_TEST(asoc, req->type))
>  		return NULL;

[Severity: High]
Could the new duplicate-drop logic permanently drop legitimate responses when
the sequence number wraps to 0?

If a user calls setsockopt(SCTP_ADD_STREAMS) with both incoming and outgoing
streams when asoc->strreset_outseq is exactly 0xFFFFFFFF, it creates a RECONF
chunk with request_seq = 0xFFFFFFFF for ADD_OUT and request_seq = 0 for
ADD_IN.

When the peer responds to the ADD_IN request with resp_seq = 0,
sctp_chunk_lookup_strreset_param() handles it:

net/sctp/stream.c:sctp_chunk_lookup_strreset_param() {
    ...
    if ((!resp_seq || req->request_seq == resp_seq) &&
        (!type || type == req->param_hdr.type))
            return param.v;
    ...
}

Because resp_seq is 0, the !resp_seq check bypasses sequence matching and
returns the first parameter in the chunk (ADD_OUT).

Since the ADD_OUT bit was already cleared by the first response, the new
!SCTP_STRRESET_TEST() check here would see the bit is cleared and drop the
response as a duplicate.

This would leave the ADD_IN bit set forever, preventing the RECONF chunk from
being freed and causing the association to hang due to endless
retransmissions.
