Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794343356;
	b=k7onrC0Lf7/wPq0B/du33TPL0BN6102r/i8KoQyWCjaTRYlHLmM0WoYe+zb2IIvq/FQZ
	 PKicteHw693hUapVvWJbuoC/Q7DMp6zoRVLuA04wpstdxiwsvAbGL//Uan1iUhFn+2YLL
	 cXmavdUDS2a0KGng7t/dyw/ycBWX+DRdqSSbrJgavxO6Wu65d2RpEzgsXWeFoOfbtYtGa
	 d6IyRyeoBPDelX0XTFuUA/fKsSBlIVDvt5MItNNstas9K4zm+P5IV/5PfVNxOSUFxxgjI
	 SwYpeseP+sj5QntAIV59g08WP2f0H5Bup5nEKrgTEGRyufpIyClSo/25CMmb87t/xeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794343356;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/Uiww4ezFXi6VNr6G5FkaTJlTRK1KjfoprXIwdlqKmQ=;
	b=S52U0fhzIQKog0/KFcKihIFTaxXi6qcKrW0jNt5IaNIwaJHEbkT1R312hjnBHbFKyebl
	 Emd0QoSyKAt5S9zk09d7zFOWcHXBJpcmpGzcWpruj9DJOKLMYqn7ZCuhhRHp1ntxNqwOg
	 cUAXa+In4yCpaPyJl+Hcaa/GbQMrtZhPXYOSWkEaMElZ6VNtF68DJ17Fp5ThRxtW+A/sM
	 5lW00Ugh4HMfFyZ+5n6s/VbKCw7/EOtntnTOO/lL/GN6C2P7wx3qsU7/p/NPWR7YFCLYg
	 EIiMAyiZKWY1eH/drudfShNZaQUsyKomnMupP8Ai7r5pT2bEdinVW8Pd1I34TZzNvGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkYKGcSY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0E606A320
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 20:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43C0E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkYKGcSY
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a07078200fso1065351b3a.2
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 12:42:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794343356; cv=none;
        d=google.com; s=arc-20260327;
        b=f091khvyxGPvAekZxcjKbB+kPyoOLw+8CuqV3uISaVhZTHZmzGpajSVvA35zZg41hI
         ku3c5Xv0JMQqY08o89sVkG7Kdp/emB//FbmHT4qzNStTUHlm1v2pMP4jKiiBnNsKqWFc
         UBABOehTlpA56Az5BM40GbSV7fUdGVcpiWgsO6pnb1SD580gimqs9vR7YCdiN4KUPiNi
         zhlsSmmuN5/5hQn9JWYoezt1xERh2aylAjXkaq1LY1qyboBraZSJw0Cy7zF2isiIw2Ex
         djCpplE9OGOXNJl3CzRIyHulzrvxwmjtVkWGTvkayd654axQw3LvmLqzpzErM4TclN0V
         IbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Uiww4ezFXi6VNr6G5FkaTJlTRK1KjfoprXIwdlqKmQ=;
        fh=HhoYgGML7ZJ4hs83jm448g9phNODZSHigmrrTcMBDeo=;
        b=rz98OggUREnFrMM4J6oSeCKcErLQEbKTIhki/tU+CitngknKCZUHPTfgt41TJOjk6c
         4EPrr4x9aXbeSMYwHdQrzrzLNpwGVACZsdsVvOHcAydnfC5c9RbXSbNEhM05iAZPGMQm
         92Ls/C006K+YfuvyFIMmX3GOZm4Q1VBEEq5QdAoU01DdW9ove/dj7d6DJ837AfPzXNVC
         AxjjKvbmchud3ieREkI78LDnrzxiba1GJNLRjJQZ6vhD4tJNiCH9LBLPGxjhAu+yMZVP
         jMcwg33BGCIIxOfK+WfIeanJRgvC66jrtFbJ7BTBCCqAlmQYNL49uD3gXPuqPBlvBj23
         M1/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794343356; x=1794948156; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Uiww4ezFXi6VNr6G5FkaTJlTRK1KjfoprXIwdlqKmQ=;
        b=PkYKGcSYMDN/AxLAIZEBQZtApqxXY1YTHtR1/pzU2W0HHe9kuHLmiz9SMfl+9Azmy1
         AKBCGf4AvA7Zj5QGqvzGQRPEQAqVJhXBw7Fb7I99eMXQ6FqoFxKABqWHwmNK2wAYaTIk
         eAhgxsO3elDxymBFgFncDG/08ywScsh4rv7fOmnf0aLVdt8qtsIZTdfxm7UBjFDk/+KQ
         Pp0Ek3x1C1HFtm3IxInYYmXG9UF1iTrkn9WFpNAEjDvPicQ4PJ/gdMlu8HePQCnVr5rS
         BUhdKzjTOqO6E77NWZzyWNPDyY4yVdXVM5Lw0FDlEs4BYjhVWoIHdqQt7al1HzbZVD+M
         /2VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794343356; x=1794948156;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Uiww4ezFXi6VNr6G5FkaTJlTRK1KjfoprXIwdlqKmQ=;
        b=LilSN9LwhDPaX2ECZEhqkMeF46pigF9NpxWOwtfGD/x1iZFvSVDR8U0vZm4rghQVo9
         5X9p+nr2+1rR1F5T3rf8e93ifW0su4ZycrEI+s0H11GPaOtl5u/A4OVAy/TYwypSij1f
         kq6dQNJ8TngWPGmJww1Y1OPV9Ma8GhdOUiEXl2xaAJgLzT9rgM85Dm3AjMmPvXbW7bEJ
         4cqV4CjIAj6ek99yoq6Q7HCP58GFRs/gnxDIY13Y0n43skeLpU5NclUM/dcCtSswzZTb
         YOpGbyu67gmHQQ+6Au2Yr01QHjC7uw/tmBwpHkGTvn8oOCNU/mlZFUgQGwocEWdvB3ZI
         w57A==
X-Forwarded-Encrypted: i=1; AL+hErEYcbiLP3Yxs4pFoYyIFpIJM6TNL49BJm3IeORBdhVzCJtjWtcxnDdf/9dD8HLmEEqyw+UN0W8MdhYM@vger.kernel.org
X-Gm-Message-State: APuU4Z/zrLQ/J6g3u4o/Gc6YSOKgfzC42XZzqgCTosOLbvHkod5mBhr4
	Dbst03d51qXI0KZb/9ssyYfs2P+rpu7bmSc3m6JHQouaZ0Ife2dTr0C01ey2AjGtC3SbbJGmokM
	RC/MnkkEovGzZdv5rGY9ycWMyui6//Us=
X-Gm-Gg: AYBFou2UzcHce0MlDQM5U4P+/hP2fuv3LcEMY6SrVA81u3svKe7dzaySNfJe0wEJ1hD
	eqZ+b+RgZsQyg9SV4LJ7K2tSKfv/YGOQjswz/48Z6vYoAo3VPqYH+SU91ws181SNLemxFdHUcMD
	J8h90a8fAGYoHoC8aQo4KSXds+sXlNJq17ynrRKpoF3YqH6Ed79DHPisbfd/xnxVQMfojeBX73A
	DMy+pBUG4cTkSdb2Hnhwar1v/jZj6l5Iz8YzrvbDjZ7iiZ14HX11lIvmYcd9A79fMLlkwmLczFD
	YtFL+tHH+SueSEL/bb8oZCJIf4kLVoMcFU3ZevsDpZ418WfRfA3QveNJLZLPwmPrkZ8zOMUeLSW
	c8uRZzxiTPOlJ1SWGcp3xNWoczJTJQRyBIqU+J/20CfNHPhvt1iK75y1JrxdUer/rhpKFfefbhe
	VFZi/ozQCa4r8BOZ1vWQt+h+KzZCrFzlOmsaQ=
X-Received: by 2002:a05:6a00:174b:b0:89f:e1e7:e7e8 with SMTP id
 d2e1a72fcca58-8bc1b6ff7e6mr297211b3a.18.1794343355486; Tue, 10 Nov 2026
 12:42:35 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105050225.49292-1-tim.budding@gmail.com>
In-Reply-To: <20261105050225.49292-1-tim.budding@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 15:42:23 -0500
X-Gm-Features: AclHuK8o0-xxEFoJvGfG6APBQwWLT1OmYN6Yn9riIkt6Sd9kIfeUFXq--mPOaSg
Message-ID: <CADvbK_fcFqT+rFN25sG69piR_HDy6gTnXyL9m=R-m9xumOOh3g@mail.gmail.com>
Subject: Re: [PATCH net v2 0/4] sctp: fix I-FORWARD-TSN handling with user
 message interleaving
To: Tim Budding <tim.budding@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 12:02=E2=80=AFAM Tim Budding <tim.budding@gmail.com>=
 wrote:
>
> With user message interleaving (RFC 8260), fragments of messages on
> different streams share the TSN space. When a PR-SCTP message is
> abandoned, the receiver still frees queued fragments by the
> I-FORWARD-TSN's New Cumulative TSN, which loses fragments of messages
> still being received on other streams:
>
>   TSN  stream  MID
>     0    0      0    B   64KB reliable message on stream 0
>   ...
>     5    0      0
>     6    1      0    BE  PR-SCTP message on stream 1, lost, abandoned
>     7    0      0
>   ...
>   I-FORWARD-TSN new_cum=3D6 skip=3D[sid=3D1 mid=3D0]
>
> The stream 0 fragments with TSNs 0-5 are freed with the abandoned
> message, are never retransmitted, and stream 0 stays blocked.
>
> Patch 3 frees fragments by the skip entries instead of by TSN, and no
> longer treats an I-FORWARD-TSN that reaches the highest TSN seen as a
> reset. Such an I-FORWARD-TSN is then handled by sctp_intl_skip() alone,
> which has two partial delivery bugs of its own: an unordered partial
> delivery is not aborted when its own message is skipped, and
> PARTIAL_DELIVERY_ABORTED reports the highest skipped MID rather than
> the one being delivered. Patches 1 and 2 fix these first, so the three
> fixes should be backported together and in order. Patch 4 adds a
> selftest.
>
> Patch 3 has a cost, as discussed on v1 [2]: an unordered fragment of an
> abandoned message that first arrives after the last I-FORWARD-TSN
> naming that message is no longer freed by a later, unrelated
> I-FORWARD-TSN. It keeps its rwnd and receive buffer charge until a
> later unordered skip on its stream, a reset, or teardown. Dropping such
> fragments on arrival needs new per-stream state and is left to a
> follow-up [3].
>
> Changes since v1 [1]:
>  - Fold "sctp: don't treat an I-FORWARD-TSN as an association reset"
>    into the purge patch, now patch 3, as Xin suggested [3].
>  - New patch 2, from Sashiko's review of v1 patch 3.
>  - Move the unordered partial delivery fix first.
>  - Selftest: add leading_edge_nopd, reset_pending_srv/cli and
>    pdapi/pdapi_uo; wait for conditions rather than fixed times,
>    including all data being acked before the queue check.
>
> Tested with the new selftest, sctp_vrf.sh and the lksctp-tools
> functional tests, also on a kernel with KASAN, lockdep and kmemleak.
> W=3D1 and sparse show no new warnings.
>
> Initial bug observed in use, root cause identified with AI-assisted code
> inspection. Related bugs found and fixes implemented with AI assistance.
> All reviewed and tested by me.
>
> [1] https://lore.kernel.org/all/20261024120627.837568-1-tim.budding@gmail=
.com/
> [2] https://lore.kernel.org/all/20261026052706.187296-1-tim.budding@gmail=
.com/
> [3] https://lore.kernel.org/all/CADvbK_du=3D-oT19kKBKYSjFKYscnQSH1mekRKMX=
gmLPMXTEH_=3Dw@mail.gmail.com/
>
> Tim Budding (4):
>   sctp: abort unordered partial delivery when its message is skipped
>   sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
>   sctp: fix I-FORWARD-TSN handling of fragments on other streams
>   selftests: net: add SCTP I-FORWARD-TSN tests with message interleaving
>
>  net/sctp/stream.c                           |   2 +
>  net/sctp/stream_interleave.c                |  38 +-
>  tools/testing/selftests/net/.gitignore      |   1 +
>  tools/testing/selftests/net/Makefile        |   2 +
>  tools/testing/selftests/net/sctp_ifwdtsn.c  | 699 ++++++++++++++++++++
>  tools/testing/selftests/net/sctp_ifwdtsn.sh | 233 +++++++
>  6 files changed, 951 insertions(+), 24 deletions(-)
>  create mode 100644 tools/testing/selftests/net/sctp_ifwdtsn.c
>  create mode 100755 tools/testing/selftests/net/sctp_ifwdtsn.sh
>
>
> base-commit: 6baae996ecf6a3f57b08ea6f6786e29af9260f51
> --
> 2.34.1
>
Series,
Acked-by: Xin Long <lucien.xin@gmail.com>

Thanks for the fixes and test case. You may also want to look into the
pre-existing issue in:

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105050225.49292-1-=
tim.budding%40gmail.com
