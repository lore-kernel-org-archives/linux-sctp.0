Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794665481;
	b=s5H2DS2y4bdQBCitB9nqET5RjnjYN9bZF2ARJmhwGrFQ87uf2UmGOK74teawlKCMkVNI
	 p4TwmnVRFBq+ynO9leIyLSXRStLvZObvWMfhCA2VI7YVKVpJ9NyBXeodqyaZWmfMf9pma
	 GucgdgBELUYBnhtH07FYVioaX6eZ5rUZo5ir827ZFR73omAS96O5hbesXNffaGQtzKzky
	 IruQOOJhry7K+2WxS77GR3qHpMj3TE2pGOUssD5ZfghBakW/GibNC7ATIdDtlHtjOwU00
	 0k992loxvSCYTuW9Dqslf6nm9biNHkZ1KpKtKqfQb1AdTRxaVv4sVKxkJ4SQu8p3zKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794665481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:To:
	 Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=X1aNKxDcC9Su/sKRcb+fwZwTfaJYdtOu8vWxOSG4H9Q=;
	b=HH8ZA+jV1D1rpqIArInZ9suV2Tf4pwmLrmalV64brAA81aThtDbDx6hKJSYt5OiNLskd
	 e18LXc09i6jh6lJ0mSQyEjPAQtPAFh87c41rNrlYdKU1j9usIXmqZGUfe8ZbqK2XGfFS1
	 XWSHZzvUl325DPddzzL7diTUw4jSxiFmsB2GtaPVqFL1hCZ+kzMnRP19JRJgxFJjapfPn
	 PHnh9mVjRvmOIV8JlWfNIlvs+D4FS7THUYDzAveCYiljoeubWmObL1A/mI/2y7yPwa4Ds
	 p9E6FU1j1iThffyXWOSunhe6Sr9GOm1QoW8Rpe8zdCg9dBNba0nsVmKf59X1rGPbb3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VIuTSlCz;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0081606A331
	for <linux-sctp@vger.kernel.org>; Sat, 14 Nov 2026 14:11:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0081606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VIuTSlCz
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b58d6f67a5so974015b3a.2
        for <linux-sctp@vger.kernel.org>; Sat, 14 Nov 2026 06:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794665479; x=1795270279; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=X1aNKxDcC9Su/sKRcb+fwZwTfaJYdtOu8vWxOSG4H9Q=;
        b=VIuTSlCzI5+jZy6lhUJ3NdFy8QfvKvOumfxqXf/KsHSm7q7qnrtm0TQKMxcAu58t9e
         lgjYrX7X+fgOz0yW7XFscKcImqrdxA74UWS9CrBbqZFuQT5Xjd5qBFmUFrQGTROrNBmo
         j3HbrMQ9X6q0EiaKeeaJowpKByG3xCk7OAAinrnWahFvw3jTJfK6+Arw7kgFbveE7bcn
         cWEdrRwRmJsazex6ce+lvFzkV6lLEguXk6GoJ8/v93AWykNVZdy1xFS6PSwqBHVADnKn
         cowtQuqrBknj2KZWxJU5/xk+xdXxpzhtDkAlhXlKc/iEhax4HpKwerl5PO0Bnrx0eFp0
         sXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794665479; x=1795270279;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X1aNKxDcC9Su/sKRcb+fwZwTfaJYdtOu8vWxOSG4H9Q=;
        b=sSEEVpINQJFcv7mDgb6kRElS10fLM4/bayqSY8fSFCF6n5MiYiRyu6mchAdamgSd9X
         UP6vH6ll+zOD3ghDB7A0fJE3R1sAzLcqnyGZaWICrVabORsZTYL5Ejxi7LWF/RF6EdxX
         H9oegD+/i9I1E+4H3mTHtp7jR81tn8WJ0Ds0+BjW8VMN/ksBkneUf3AwtY0pio5S9xrU
         zVSBVqlkXaoxZi5VoxGurg6fzk8eorZD5tFd97V6WmyW4ncO+8kDE9fx4HBEFwtOZ0z4
         JPuNnLGAzxZFIRgAvwa/bCx1CR9Mj6qeTyvLyDb1D9/dnDHWdnhGh6Ke5y4DIne8V1v2
         nT+A==
X-Forwarded-Encrypted: i=1; AL+hErEasgww/aIJ8BFg78a70C45NEDT0lsqP9Pr7jzh4KT3FnFLQ+59dUfAWBgRexeolFNYWuhnbzp/s3gd@vger.kernel.org
X-Gm-Message-State: APuU4Z+TIiwIdtH0dK03URF3AcxzHqMJFB1w6vjYoZYuCRZJcvta/LbK
	s7EH5TQs/E9midFkbYIu+F/qRerrmzsSB+i3aWZmo2SjCx22Met42Ixp
X-Gm-Gg: AYBFou3XvQ0IRkcqsOjp85JCFBp+Rv51hZG0JFmqszMTPCfiPciN+/FlklHm+CmLrxw
	TbMJT5iPL4CGh2mlLKJckpl1UZk++ae/f1PBvlPDDJQwEkSvAr7Osfkc4jymtvOjgl0eGIKr0E6
	KL8oqJTJoi5cen8si1qSW4z07GixH9JDnU/soNjPyxOXgnk91acXDrJMHBo8mTFnqXs32voe/Iw
	xnSZvTwOdt+TuTxuAeHmbVvDsYghcvSJQRkoplMaXBgHhxtAF4dEz6O+JkDzxkqrlOZNHie6O9U
	AkYv33OjfADpcSrhFO+z3TXpDZWLpHmsTTLWVLtnu2sxClbLvgulvzvwrXZrtXb6iWB3uKHKWVF
	sBFTBjsHQFutFZlbaeirE3/GfjLy60TSNYRVI0XYa6rXMEfKFYjvaPP+LkUI5Bz/TlyhLHRaRqd
	GJ4aPSQXevDD9GD/dDGlRwlF5UZEmR/GA1k4v6WXTI9SFovSpCWGtYxqGjw/xD5dpbqHujIQPHi
	xaJcQ/NNe2QKgvHyupiNsP/1h3bVD9Vk2/Mp5lJ7BD8gASylUifPc1IKsgzLwXCIcSEKExKKH99
	B6cdDcp3PGF7M+Yi/Re/8c/vckvGEZ5Jhnfv0VaMQvuCM2ohe/zNi8Dx7Rn85tC/2lc=
X-Received: by 2002:a05:6a21:118e:b0:3eb:b103:6ec0 with SMTP id adf61e73a8af0-3f7a72ba2e9mr5274932637.14.1794665479089;
        Sat, 14 Nov 2026 06:11:19 -0800 (PST)
Received: from [192.168.35.40] ([218.50.238.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18b4e68sm2442814a12.25.2026.11.14.06.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 06:11:17 -0800 (PST)
Message-ID: <2d8dbfaf-46d3-4d05-b052-5e8a8670931e@gmail.com>
Date: Sat, 14 Nov 2026 23:11:05 +0900
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] devfreq: Use trace_call__##name() at guarded
 tracepoint call sites
Content-Language: ko
To: Steven Rostedt <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vineeth Pillai <vineeth@bitbyteword.org>,
 Peter Zijlstra <peterz@infradead.org>, Aaron Conole <aconole@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>, Alexei Starovoitov
 <ast@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Chanwoo Choi <cw00.choi@samsung.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Danilo Krummrich <dakr@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eelco Chaudron
 <echaudro@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Ilya Maximets
 <i.maximets@ovn.org>, Ingo Molnar <mingo@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
 John Fastabend <john.fastabend@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
 Koby Elbaz <koby.elbaz@intel.com>,
 Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Maxime Ripard <mripard@kernel.org>,
 MyungJoo Ham <myungjoo.ham@samsung.com>, Oded Gabbay <ogabbay@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Philipp Stanner <phasta@kernel.org>,
 Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>,
 Thomas Gleixner <tglx@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 tipc-discussion@lists.sourceforge.net,
 Tung Quang Nguyen <tung.quang.nguyen@est.tech>,
 Xin Long <lucien.xin@gmail.com>, x86@kernel.org,
 amd-gfx@lists.freedesktop.org, bpf@vger.kernel.org, dev@openvswitch.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
References: <20261027153658.703730257@kernel.org>
 <20261027154413.039021489@kernel.org>
From: Choi Chanwoo <cwchoi00@gmail.com>
In-Reply-To: <20261027154413.039021489@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/2026 12:37 AM, Steven Rostedt wrote:
> From: Vineeth Pillai <vineeth@bitbyteword.org>
> 
> Replace trace_foo() with the new trace_call__foo() at sites already
> guarded by trace_foo_enabled(), avoiding a redundant
> static_branch_unlikely() re-evaluation inside the tracepoint.
> trace_call__foo() calls the tracepoint callbacks directly without
> utilizing the static branch again.
> 
> Original v2 series:
> https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/
> 
> Parts of the original v2 series have already been merged in mainline.
> This patch is being reposted as a follow-up cleanup for the remaining
> unmerged pieces.
> 
> Link: https://patch.msgid.link/20260515135920.2238808-1-vineeth@bitbyteword.org
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/devfreq/devfreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 82dd9a43dc62..9f71d9dc4a70 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -370,7 +370,7 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
>  	 * change order of between devfreq device and passive devfreq device.
>  	 */
>  	if (trace_devfreq_frequency_enabled() && new_freq != cur_freq)
> -		trace_devfreq_frequency(devfreq, new_freq, cur_freq);
> +		trace_call__devfreq_frequency(devfreq, new_freq, cur_freq);
>  
>  	freqs.new = new_freq;
>  	devfreq_notify_transition(devfreq, &freqs, DEVFREQ_POSTCHANGE);

Applied it.

Thanks,
Chanwoo Choi
