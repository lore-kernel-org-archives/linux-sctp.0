Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7E034676F
	for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 19:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790279184; cv=pass; b=R3cg6PKA/xHEDwpT4Yde7SYI7lsjb6FscuoS8RI4NU20MduzWsxE9s7RGKIquTa1680rGIh42ZXnyqNpo1ijm77VNR8WzxhoQJrXt/HPC5YAIJbvgpoVplY85+kd+C+o2nKy7OS69oQD7e2FvQTyQ5OzrXpmHhNW8TMSm8Uuikg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790279184; c=relaxed/simple;
	bh=cWBBE5NKGRnMa1w/IhPdQbTbTPbXKFZ24GCRjXXb3gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=htRZtPuEcsZF5smRvq2aA2T5fWw3ToOg9JvC9V8oqjAT0imZEgX91JgBE1lCL7hVg3+fCcgd7gFHzdvEDIKFuau5iWqJbvhfrFXyMmG5iEwqLNCXJkWxX318It64iZfhXbEH/n2QsqW34cPWSVnXgjsdMxEZsNHwPWlnwpJ8Kv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=IRAdG3jr; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="IRAdG3jr"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a3156692c6so938481fa.3
        for <linux-sctp@vger.kernel.org>; Thu, 24 Sep 2026 12:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790279175; cv=none;
        d=google.com; s=arc-20260327;
        b=AeyJEfNhcJdFbDEPdsse4OfomM3XQ+Q/1nfmYhtNuzuP9y3MHpAe2UGrm29xk0OIyj
         kzXZ8r8xUxa1DlqZoE6VQVwqAZlxTMi/WqZS00w+dAOUIJX15yxp2H4dRon79Mxsww8p
         A+3/Qob2OX+O0zPTcjx+kTxeyb6iBNSqO6Vk2dqd3svMnRb4UM9g4dR5k+4kkc4mmUAQ
         OsU4+sYzHofxC3A5YDgD8okfrUJY1wxPqqT/ks5YxYNONISLvOyTDQH81tRrwxNUT7pl
         2M9ETSJe9SCZNumnINPM/4ijCDP79r+ZdYYHJxloFT7NjSWZ5MpjTgpWRf8aG17Apgxk
         a1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1uYTjFCSvnfULFVrptjRLphPX1S8KB2IOyYhkGGsRus=;
        fh=WtVpecY8aU3yNwoLzQMo4bl0pN33CG30pocV7DnjzyU=;
        b=Dx6JnSPR/OdiVaYX4EvXZTcogBfKB2UZN89GbT2ypZ1wZClYCd3xzIseGT+k6zJlmE
         mI3eoNbtjYnHapkOnWt9BFrZeP6x97HYprJPwoWFmBRR2UUNx62ISPA8FmZYHHK22PLg
         laWvA+raqfoKhlpBgDKpxGh4j4CP+PPvNItAPOL4UFp7yyZMjWxTqzri5Z+lrdM8R4Rn
         4Fe+p11lX+41lMSgP7uZ6Lp3eN/frh3FJsqFHhw2/BobwbdhfrM3xlnUDGJY0Q4EH02k
         CJA+UBrEg+fywnQQOXIRyfSfUazRS3vwjbAIrJHDj87VIHThBBJQpBhWb0/2V9hlEqRq
         QGJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1790279175; x=1790883975; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uYTjFCSvnfULFVrptjRLphPX1S8KB2IOyYhkGGsRus=;
        b=IRAdG3jrlZJKSlVg9HLF82g7qFNaqYZwbE2cnuNfBnp/2Pyxlv3ymaxrN31++XGP5x
         8ayvqjSDo7dI/XJ7vuNo0M6d25XFgYOLmtUXsc5yOVEymjTNn2dXqHJddBAyGdzDXqxL
         2AQFIE02qrWuWX4r2XjF76RaKw3GWs4hc17F0lW2mq9CLRmIL+0gTR1SFaAvGNrFciD6
         CnXo1uWQ2VGoNmckRoc4ils/59N+eaV/ibWc/KzV6HzlkW3xuNXFICdF0b3Km7oPewB4
         jsq/7tZKw2V6U3MliVTXG1Lfs8q70SB/RXWjwcmqB6Aw4adxn0xHYuOtl5nupSwAMXSi
         gRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790279175; x=1790883975;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1uYTjFCSvnfULFVrptjRLphPX1S8KB2IOyYhkGGsRus=;
        b=VD45bXLtH1h5vcQq0fzSmU7AC8xQQVutcMzQKf52vDecuwvzEUSuleSpno1oI2evhN
         9LvOwUPO3s8zSLE2c7axBxY2Nxb4Lo28CpyvLzIcp8G9yiNQaNmNPL56rMLnb6DZ2VPA
         sKPKWYkiNBpKb9iAmnCnvXHURFKm9WY5irSrOStJNSv/BJZFMjb9k8O8tsgnVHyFU0e9
         34cscbc8QLq7bxvebN1LNp7NQWeepJ9rGiuUSSJGPYkwrJy8i0T3DO0yaAMInA9BCg8R
         CiTjMVkKb6/IbkbiLJ/7HEIzzx4NvvtA/qs9oEhsQl1kmlNig7+5vVM/nLuCZ/A/+mJk
         a4Ew==
X-Forwarded-Encrypted: i=1; AKwUvBxfq1HXHKK2Ztuh/YsICFGGNLHDgOMGRAD9NHqJAQnykuld0gHWWnsLNFB1llzZzwOuVRcSqXXZ01di@vger.kernel.org
X-Gm-Message-State: AFuF++leOUPvGSCD9X9/4uZZA8jUh0Ycbh+yabzSUhjbpKYR/aD/h8L6
	JFAGzaOWgSJGmkdrWN4G2QGxIaGV8Z66T5y7bIoQb6+i+CIy8Ih9yCYn0CLQIHeN6mLn2mF4J2h
	o5xAc1NpHz0EdRtFIxUP5j3Csz+L8bCQGx2AotmBSgg==
X-Gm-Gg: AYBFou0OFAUacCVVaIb5bDJl9Ep+Ng3thUwFOo2NmW9S/ivVFzc4DPs//5EmLNnlEDY
	NriIB1vVBZV/vyku1o966/3T75EEaec5gfI3BwqMihVY8mv2YhkmgCtSN9tMnGMTZVulMyqgAlt
	Vk1iGw00E+dd3N03Xlf6vcCKYtFlCEM+SqQa4LCz7CLMK+JCaobrc3JIxm9OhAP0NvJvNo6oOmH
	ToGiLUsVUq32OpH14pzgRkNIozJgS0ZPzdVWW8vb9XhTAn58gyuCVdDy6CvsO9fDH+T81KkAU/i
	UcTeXjMa6RB+UGUNLUns0j/aEz/KGxT9yofOYd3RaJ0Za6RUK/kYv2r9AiW9mkTRVw==
X-Received: by 2002:a05:651c:54e:b0:3a5:f982:9c92 with SMTP id
 38308e7fff4ca-3a63c061c09mr8269281fa.7.1790279174670; Thu, 24 Sep 2026
 12:46:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921135733.577647-1-wbriggs@cellusys.com> <179021514567.2160803.16218616091479610626@kernel.org>
 <CADvbK_c2P-qxJJ3sCDLJMpCQ4g6PaKVN3kiLTiXYx8UREmCZWw@mail.gmail.com>
In-Reply-To: <CADvbK_c2P-qxJJ3sCDLJMpCQ4g6PaKVN3kiLTiXYx8UREmCZWw@mail.gmail.com>
From: Warren Briggs <wbriggs@cellusys.com>
Date: Thu, 24 Sep 2026 15:46:01 -0400
X-Gm-Features: AclHuK-O0oW-wMX0yMzGjTG_pFHVFuxMN8-cHfLCwcd4-GHCZmAeQO04RntgfNM
Message-ID: <CACjaXw6eEyjeJ3YS+b-xQr89QDRiQVdD7fKH2OzA6V7SQkBo7Q@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: carry peer capabilities across an INIT collision
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, marcelo.leitner@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > The testing notes describe ASCONF and RE-CONFIG appearing on the wire, which
> > exercises the outbound counters (addip_serial and strreset_outseq, both set
> > locally from asoc->c.initial_tsn).  Was the inbound direction tested too?
> >
> > Should the merge also carry strreset_inseq and peer.addip_serial, or
> > re-derive them from new->peer.i.initial_tsn the way sctp_process_init() does?
>
> Makes sense, please follow the suggestion, and add something like:
>
> +       /* Re-derive sequence counters from the peer's Initial TSN */
> +       asoc->peer.addip_serial = asoc->peer.i.initial_tsn - 1;
> +       asoc->strreset_inseq = asoc->peer.i.initial_tsn;

Will do, placed after the peer.i copy so they use the new Initial TSN.

The inbound direction was not tested on v3. I will test inbound
ASCONF and RE-CONFIG on v4 before sending it.

> >
> > > +     asoc->peer.intl_capable = new->peer.intl_capable;
> >
> > Would calling sctp_stream_interleave_init() and sctp_assoc_update_frag_point()
> > on the surviving association after the copy address both directions?
>
> Outqueue may already have data at the time, we can't just call
> sctp_stream_interleave_init(). Let's drop the intl_capable update from
> this patch and address it separately in another patch.
>
> You may add a note for this in the commit message, so that the AI review
> won't report intl_capable update missing.

Agreed. intl_capable is dropped from v4, and the commit message says
why and that it will follow as a separate patch.

> Please address this one as well by adding:
>
> +       asoc->peer.adaptation_ind = new->peer.adaptation_ind;
>
> either in this patch or a separate one.

I'll include it in v4.

v4 to follow.

Thanks,
Warren

pw-bot: cr
