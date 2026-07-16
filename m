Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D642377A
	for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208708; cv=pass; b=mmJI/6bsIw7cVCe6W2CgDkhwYI3x9WpJtMvAWhnx5ME8MUADfr1LMLcWw7Vlfz16sC//WcFePBt+x7IXshnV2lxFiH6E2rZzRXk/cNxIh906W7UqJvsOsEboIwyNpqxmKgXG0GohhJCxyogn1upvL2RAaccVknNfRzUMuXWDu4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208708; c=relaxed/simple;
	bh=xc9S3c/xNsKaxwTz/5Yxl+QfgtMe1+bHg58ONELRULI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVja2G9XfoJOjoySfVomibjPA+7K9+edMWtWQ51QLoElrcc1zEonOvDrmes5JQBaC0WkbgNrsSlUPsWnmsvGjnUA3VmKKvNmn4DqAYpWBblYKXE6jhPQIcjJcXLOVvASCAiEs9Ix4mYWTZ88f8af2oQGDN5ru202Xiq6dTPuWCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cKgGGzoJ; arc=pass smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cKgGGzoJ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so7708696b3a.2
        for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 06:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784208707; cv=none;
        d=google.com; s=arc-20260327;
        b=FhWW2/oS15g2Poftx/wlyE2OFkEJPCiCwbvKvp9NVAboBj/r1pOWuEBczGywaHwfau
         xVfZQJkoQFlgBDm3qzIpbHoSdRaAq9arBoj5881qCnHs4Dj/MI19boeagmsi5CZ28W7I
         UpV9CKbvbuZAA1eMVKZBKHUieG6xwo4lPNn16XKnaCXRf3eJZhAZprPOwxF1k2saftz8
         uky5e3HQaXUVUYwFDqCmiquk5nRYRLOWkuJfPljI3UnNjkv1qfKkeDX94HcbQmJUcnH5
         xc50etrNc6EB5kQbM+AsUTAR3BrYd/jwPWEMHgsYBhUqE2jRVVSXW2sR6Jl5Y8hbV3iD
         UJUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xc9S3c/xNsKaxwTz/5Yxl+QfgtMe1+bHg58ONELRULI=;
        fh=1HThs3M8Odt4AmaMv+Inw5eFIR8fTMoNhoo1C/4ea7I=;
        b=X7/1vQHoTm+/BbwfE9M5tDCFSMwk1ZQZ1R59Uvd+7BrOxcryCoSMnkztmhbLcNt6h2
         5LoLg8ORZjFiJ+cZv+6+I7z/VxM4um4LMQnxX5mWGOtC2noL+SJU2xJ1/4frOW+vL8ag
         YEG4/ZxY3ahITdcuPwpt7D4mFvozEwZhiDuz6o7EcVyY+jF+U4ZE6VcIhSk8L4hARUT2
         cq1P+MYT+xwCsX9IhIiMuY1N5V3+3CoK+aAt3FvitgP0R6P0YpYUH3Xya2jXc4jeNWL9
         kQcPy2oDTWaPWzrMQXesDHe7Q4nhGoIIp0/7uxwmfPrMFgQxrZaqd5tLio1WVN6VGCZd
         Qw9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784208707; x=1784813507; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xc9S3c/xNsKaxwTz/5Yxl+QfgtMe1+bHg58ONELRULI=;
        b=cKgGGzoJXyG9YXgNQ3UL9mGg9Yro8Z9rUNvZNMbD2mWwtPpStS+cY/xIuM3HfrTBt5
         dxrXW+Od/ubio8prnPhiyNY+8oTvEynQ3/xYdrMGL5yr50ZO+yq4w7+u5r1A/U328tQH
         AUXp1HPEM88kpF0KM/a7vLHAGAggENIQV16a72ztLG5IiLUY/9cjxjx1qz2uvmEg5L13
         J/STDEqFb6Jlb36pbObiX1oH22yY9BkyG2+Gx2OV/+B5MH5fDqu1ImCZGk9DL/+K7KcX
         2oyrIEOj3nJZ4GjECL92y7KIFwMrP9FxfGirlMhNKO1XfEuwrwtFUFik2UlDJvswEtuP
         AtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208707; x=1784813507;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xc9S3c/xNsKaxwTz/5Yxl+QfgtMe1+bHg58ONELRULI=;
        b=OBxusEcGxdgThXaTIDcrv4lh5aUOrdu+NuV9nBlbfNlxocMill6kgQ7C0/KrvYN75u
         Ah6VhsVe3cRwpYa9F4Oy4I8lCMYGsz1N8CZnrTqnGeTFm4RLiMsI7eL5/ghKBbmFfocR
         fqompzWa/wlFpMwjhtBjI8SI6Wbi+vaLkD+YjPimZkAlYfhh9gT7nQADOxIj3paT+yFU
         M+iHV0Rux/baE6zjs5sUXubgPnjll6f3ziK1zHTqfnHBb6xg2LfCKP84fJu91HU/UNLz
         i0a1+X85bti9yBdXG5MC6d8sUwAN+kO+r9lARujRtEdYQIryQkXMYPUJGuT0kffJuUQf
         Jzkg==
X-Gm-Message-State: AOJu0YxjSj9Esc5vHUFUhMS0XQ20v1YucBvvgux/AoJgCgJY/ljajo2l
	H+kbV+6DqJNDo5KxTiCQSbLYasy6vG/NMhyAznGVgPFrC5bz6eGLRyEAEYNjYn/g5g2wbb8Gt/g
	SUjJJ74R3Rt/uTsK19a1O/deBa3i5qjc=
X-Gm-Gg: AfdE7cl+VPmy6EPLW9HdSbT+MWnthS//1vdY7pmd3FNLIm5LCZ4G0b1uA7CE9aA0wM0
	7R5w701YcpROIuOof64jmKd7q724hLyHGpsp6QzDE5RZLueLMkUY+9MR3fl03yu7xpP1SdcxhyS
	XccsShsJRWT7HdlSz6T+5EsEm/aQ6RKu2WQxCZWz0qAmhLJ1YHOjVvwWkhSICDC+pgSDX+lPSld
	6jZ8rsZNvV26evUEA+QrjFizT4e/A0bfCo3hM+Du+tebvX2zLyau5bV6xLTgune/gl8tOuOtoUd
	9Gtsx7b6lYlKwdvHOXQ5UTboNoh+OOBFB0L8SY4sOjdVDALeQpN4Oj++qSeSd+gsfjprZ0wlqyS
	VEO0ZdEab3UL883JZtQ==
X-Received: by 2002:a05:6a00:3319:b0:848:587f:8acc with SMTP id
 d2e1a72fcca58-84a5162f709mr10179967b3a.54.1784208706567; Thu, 16 Jul 2026
 06:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784033357.git.roxy520tt@gmail.com> <390cd5e91ed60eea27b0b64d0468301a9e73b808.1784033357.git.roxy520tt@gmail.com>
In-Reply-To: <390cd5e91ed60eea27b0b64d0468301a9e73b808.1784033357.git.roxy520tt@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 16 Jul 2026 09:31:35 -0400
X-Gm-Features: AUfX_mzSqFy0j4m8l7TfrH8k3EUCCD1rj9O7PFk_y4PpSTTmkSqPxAXdVXUBAo4
Message-ID: <CADvbK_f7du2s28mJ=DsFm6dE8u5xaSbd=EG_5sL+-HKYfUuCcQ@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] sctp: avoid auth_enable sysctl UAF during
 netns teardown
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com, horms@kernel.org, matttbe@kernel.org, yuantan098@gmail.com, 
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn, 
	tpluszz77@gmail.com, roxy520tt@gmail.com, sashiko-bot@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 9:50=E2=80=AFPM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zhiling Zou <roxy520tt@gmail.com>
>
> proc_sctp_do_auth() updates the SCTP control socket after changing
> net.sctp.auth_enable. The handler gets the per-net SCTP state from
> ctl->data, so an already opened sysctl file can still target a network
> namespace while that namespace is being torn down.
>
> SCTP previously registered its per-net sysctls from sctp_defaults_init(),
> while the control socket is created later from sctp_ctrlsock_init(). This
> exposed a window during initialization where auth_enable was writable
> before net->sctp.ctl_sock existed, and a teardown window where auth_enabl=
e
> stayed writable after inet_ctl_sock_destroy() had released the control
> socket.
>
> Move the per-net SCTP sysctl registration into sctp_ctrlsock_init() after
> sctp_ctl_sock_init() succeeds, and unregister the sysctl table before
> destroying the control socket in sctp_ctrlsock_exit(). If sysctl
> registration fails after the control socket was created, destroy the
> control socket in the same init path.
>
> Make sctp_sysctl_net_unregister() tolerate a missing header and clear the
> saved pointer so init-error and exit paths can safely share the unregiste=
r
> helper.
>
> Fixes: 15649fd5415e ("sctp: sysctl: auth_enable: avoid using current->nsp=
roxy")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Co-developed-by: Qi Tang <tpluszz77@gmail.com>
> Signed-off-by: Qi Tang <tpluszz77@gmail.com>
> Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>

Acked-by: Xin Long <lucien.xin@gmail.com>
