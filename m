Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422E235DA42
	for <linux-sctp@vger.kernel.org>; Fri,  7 Aug 2026 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786131856; cv=pass; b=MvRF2Z8C5mrMTyHLFTKpnfCoBxn154Z6vuXVsL16Bpyu5mhrWM8XSC24CQFn5VrxfdGEjd288VaHBSRuBUJr6SzEQ+BEbYheCMAruuMr9A9NWzLZjkaetM3kIhQYlfI7jYvDfPa3k+zJmbXaWmlscmAPTdl/g+5C1sNtiDg2C2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786131856; c=relaxed/simple;
	bh=4xiLHxYkPGdiFvA0nrbU2tlQdfq82xczLJnzo0zXkwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQn//qkC2pUs3u25Q6hvJYb+dT07FyR3jxp0VZhZ6IO6As7ei5+yZhpIti3n1EkRtFlTGln8UBNZUCj/SxaBeifb3s2HVTkbcY8Umu2Uk2Sm+KE4HHfzXc+Y+IKgdiza0V2Ym2yAVCXSK7BQNOZf/iXkzDD2NtOCNDLGQEhARIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q80mHEg0; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q80mHEg0"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84874b52eabso4928409b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 07 Aug 2026 12:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786131854; cv=none;
        d=google.com; s=arc-20260327;
        b=WWjzSwi6Wc/H3E+OmymuNza+TXc3uKGAIUcKdFmGtYxA/V++kcTYP+eneZGFmSB0Zv
         tqV1SBO5E02Yk73YQX0GdgJPTrmm0sAj5hSlzU/Kh0uOt/iIGKgl9vEMIHNkBDObkCCK
         st9LMnR4wM0UAKwi6krq0vfZPbBPfflitt28//sZnZzXW5vqa4AiAHT4CuCBb8mn+eSI
         8niECL1NaZ9EsqtV808VDGPgeOG2mG+hl/wkAgZsw4T+974Rgy11Hb3qwLpP/eyJGuMq
         2NUAYBGwmFMFGERJ6p2LYagupfDv0dy2UjnJ+mxJxu0UqAt0XhDJPWhl6hqrHD63Mi5C
         zEYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e/wtoPuRy5LBbReY+YT0mukVCMIY6FSDljjCufXHkOM=;
        fh=3350oIKdy8dKxg7MmFIAO02Ol0LHGu8LHgmKF9Z+lA8=;
        b=QD907FA8x8IJqkjYcJv8LIg363w5Nr8JNYABsCxjuBWg1FEvN6ker8hGqZdKajX24F
         ORjk8AgR+Gfh2pktZj/kAIHSlSJ7n0yJnlC6ZhV+2xuxGHbpYx6qiJ8i63De8u8ZZTio
         Tt5Iypjicepbug3hM/n0K6xu+QG5zlyunUu66Dypo4uiVtVDGAovJNKU1GeZtO0KhqHK
         LoJgefiNLB3mtdVuvTV7qXi1GllE776sY0OaY9ktAXUP4CwnA2xM+zrB07nFcsyb662a
         qWlebEQNujOEBA99nFjt1ieT9XpVL4EbkaVlmtitwEuyK/5RS5GS9JAgVNQfTt4v1jPZ
         1CbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786131854; x=1786736654; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e/wtoPuRy5LBbReY+YT0mukVCMIY6FSDljjCufXHkOM=;
        b=Q80mHEg04QYmylKFoxCyDQK8pKqgOUTJGyr3fWCzTnohYdHTX28YRVl3Sx/ExN9eUM
         mZigsHsz/wm6vY6ko2X699jYd32rjwZOskPXMGb1EIg33N0DW+jJ5XQYVMwg11cS8zHE
         zZiTli8YJS0e4frkpoAcfFU9IArBK6LkV7L0UjOABb6wNLyVY6xYLw1qR5NHzPpMvkMM
         BRXs1FU7sJjijXBvIUBd+46PLEWNlrfySSbmR358Ssh+utSZLeAehRO5ys9AX5V6Nbq5
         nFVu/tyw0BPDKpeFuEhWiH9NMw8aCiT86rFhNYcpv2f7L1hSt7oK5J4tr+TEcNWMMbqF
         ZRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131854; x=1786736654;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e/wtoPuRy5LBbReY+YT0mukVCMIY6FSDljjCufXHkOM=;
        b=EdIpEP3/2IETqTBwio/qVBqt1oilel5EMbQ1Os8S1vXvfUFbuvR6au/hoFJHRhX+xK
         unfjlKVdmqRzWZdG3dhJbuac+fDnZ//ZB/xoE71JRyjP1X6SjgqF8ukJr25jTUfTffkS
         UGmW2ZXYJzLsAWSC3xTBtNMcYgluyz7dkbR+5Vk+Y8n2Y8yD+hmoKxpOx8k3aLaDTKB7
         cl8xpMQpe6jLO9QR+1TwYZke4JaD5WO0PQJ5Rkvin7u/XpW4oqXxoB7RQDqQt6osDmnY
         +ikd+M9QkBteU2GWhBc8semUsT1A76TTth/F598mAMdQO94Yt6+uxkDqSHmHSAAvWQ5o
         l1AA==
X-Gm-Message-State: AOJu0YxY7BQR145bDY9reqyWmB/wvE9nrQILWehMOi4f2Qd6jBGNefVR
	O9ydi1uK0rZou0e6l0l9WyAlz/HxI7YQPjJa8w60h4TonoclJoYo6v48kBPV3MExrC7uIb4hAdf
	I37hxqYxZewA75jmAJacD2BlXgRglxJY=
X-Gm-Gg: AR+sD10LFxUZaYnNfUVAw0dK+EqroNCx/ewbOpmJ7y7yIJCsHFFACsRL39789e0JnB8
	A/cz1Uudt5J9NQBA63liLTovdr2p9mskODIF11+UzTzz6Sw5Jug1t6D5kHE/VodPe6IK9uYAOXZ
	KWRuBrE2BmtnK8yUSGCxrXmmEbvtaiaRRJvRpEgW0wUBfhMN283F9iHXzUUT76P/kvmuvWP1eU2
	H7cNSjzYtsry24GmyhuQRuqFqfY/sPgI+AJ9sMPjznvuPIh9pCbf9pQRppJbHHvbAEQizn19KwT
	NAIGGtR3Evoswvx3M6y9st3QHBjBXtMDlOvaMR5nMYMVDw9zrut+v2VN1HVjwZ/5FN2V4j9AGyN
	CVbUd4dhoX6dEYfkR5vggNSKBPKpz2xzDYLwTYyn73os=
X-Received: by 2002:a05:6a00:2187:b0:843:49f0:f5a0 with SMTP id
 d2e1a72fcca58-84f5e0c4b15mr6824968b3a.32.1786131854606; Fri, 07 Aug 2026
 12:44:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806171614.945331-1-yangyx22@mails.tsinghua.edu.cn>
In-Reply-To: <20260806171614.945331-1-yangyx22@mails.tsinghua.edu.cn>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 7 Aug 2026 15:44:03 -0400
X-Gm-Features: AUfX_mzVEiReFNJVEm_qbf2Gmz63c3XMP8OIwZQiLtSF0RDjxwSqyp76pzJhYwg
Message-ID: <CADvbK_ekVxEzb=-sbphAtmzYYXqfggWX2h3CK24s84MmQvahJg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix use-after-free of cached ASCONF chunk
To: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>, Ao Wang <wangao@seu.edu.cn>, 
	Xuewei Feng <fengxw06@126.com>, Qi Li <qli01@tsinghua.edu.cn>, Ke Xu <xuke@tsinghua.edu.cn>, 
	yyxroy22@gmail.com
Content-Type: text/plain; charset="UTF-8"

> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 5b0ae616e1ff9..737f8ea9d482f 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -1713,6 +1713,8 @@ void sctp_asconf_queue_teardown(struct sctp_association *asoc)
> >          sctp_assoc_free_asconf_queue(asoc);
> >
> >          /* Free any cached ASCONF chunk. */
> > -        if (asoc->addip_last_asconf)
> > +        if (asoc->addip_last_asconf) {
> >                  sctp_chunk_free(asoc->addip_last_asconf);
> > +                asoc->addip_last_asconf = NULL;
> This is a pre-existing issue, but does setting this pointer to NULL here
> create a NULL pointer dereference in the T4 RTO timer handler?
> During a peer restart initiated by an unexpected COOKIE ECHO,
> sctp_sf_do_dupcook_a() queues a command to purge the ASCONF queue, which
> calls this function. It also queues a command to stop the T4 RTO timer
> using del_timer().
> Because del_timer() is not synchronous, if the T4 RTO timer is already
> executing on another CPU, it will block on bh_lock_sock(). Once the
> restart processing completes and the socket lock is released, the delayed
> timer resumes and can unconditionally dereference the now-NULL pointer:
> net/sctp/sm_statefuns.c:sctp_sf_t4_timer_expire() {
>         struct sctp_chunk *chunk = asoc->addip_last_asconf;
>         struct sctp_transport *transport = chunk->transport;
>         ...
> }
> Previously this race caused a use-after-free, but with this change, it seems
> it will result in a guaranteed kernel panic. Are there any synchronization
> mechanisms preventing the timer from running and dereferencing this pointer
> after the queue is purged?

Hi, Yuxiang,

Please address the issue reported by both Sashikos in this patch by adding
a NULL check in sctp_sf_t4_timer_expire(), like:

@@ -6105,7 +6105,12 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
                                        struct sctp_cmd_seq *commands)
 {
        struct sctp_chunk *chunk = asoc->addip_last_asconf;
-       struct sctp_transport *transport = chunk->transport;
+       struct sctp_transport *transport;
+
+       if (!chunk)
+               return SCTP_DISPOSITION_CONSUME;
+
+       transport = chunk->transport;

        SCTP_INC_STATS(net, SCTP_MIB_T4_RTO_EXPIREDS);

Otherwise, this change would turn the existing issue into a NULL pointer
dereference.

Thanks.
