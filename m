Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F4C184540
	for <linux-sctp@vger.kernel.org>; Wed,  7 Oct 2026 03:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791345460; cv=none; b=aGJcAxtUmsmgaWZ5D7K6y7M0sj9koA73G3wSg4H2MbUumTtbT+mIMdhYXKVgxvj5+va7+D6iw0Q7glHeu6SBUnFKaROglTG12U6o200d2W2YPlmK2D9vFnn0Z2K/v8UZR/5TkIxtwin07bUFkmt+Pn98zImonFqMC2zXY26IvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791345460; c=relaxed/simple;
	bh=uexnZlKrJFy9Uv64ru4W7iVry9vzMzmyMFMaf9QdqQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0GRuyFu9sjef98KpAseqOGn0kqRfuSFdHUSTV1y3OZAA/IO648CL99m9kWv6cP+JFeFYgWmWWSOajRGiTbnLUsnRa9YjjgffZwHadP3FXpo9tDB7mc5QsqeL9KaVdKmjZKImQCv5Jv98AaTD8ApPYqGHkYXY6AlhCUY3HG1Ex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5h3QAXE; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5h3QAXE"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so645596a12.0
        for <linux-sctp@vger.kernel.org>; Tue, 06 Oct 2026 20:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791345459; x=1791950259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uexnZlKrJFy9Uv64ru4W7iVry9vzMzmyMFMaf9QdqQM=;
        b=l5h3QAXE0N7K/vC22Dt/Wo4sylxj5fnjPmzDOeK6vYIovEzHI810FwAoTlCjHJIVaI
         BCmN7Tt7ZzMVq+rR6bd1/bohvLYp+WEW5nfBt1ERaHMhUTA5QTuZ8QillKr9HsHStOhl
         1NxoIkj1yF6FuFYdwQTE+gpC4qGU3ia5SAqWlZrf+wSh9fdXXNIKmDyc6JpFwrzRjWUP
         Qk3hjnpqzWT9cCYKHmrZRMLqu9QrB6omxJYAjf3oMLMOtsYZUDfyOYF1wQ8CuEDELylQ
         tmrRJyYl8PpiF7q8tKWrohuJDZFyInn6hl49TVEouQGZopnqzHbT7D7OhigIWGdbKJCN
         aeow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791345459; x=1791950259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uexnZlKrJFy9Uv64ru4W7iVry9vzMzmyMFMaf9QdqQM=;
        b=uf1BqJE/HZLT3BDy8j7shH558IlAQwoFo8lzpYp4TNov8QyMfN43t/WneeS8I9VB3x
         4aqCX/W5DSSdM6BCDQ3IJzlmmj5IZQcU53wfEvT6KfEVXkuZcolXSG489BQnZwNvMzdq
         YibjqJm46nAyPTrIg/Ab39N8Lss5kSebuW1FdpgiIf1qrtKijMfjKSBzntp9FSVnE/Z3
         +PhHbmg1vkssZoJs5Ok6OBK7pN3SA2ni7u6p4x1cXpLjqKNZct7awc13wJt0AS/1ETiz
         R/iIVOBSIBM5W8yrMV+KyHLbSoQr3tuyTNHwKFq0M0MF8z/5xITL6rz2AgNBepXd6T0b
         k8tQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+2sCZOkGAuEYjFxpfyKYiPyWvKIIi58jETIso3oIg0kXyRG4a4hSNWzgGm2Ms15ZPKP15xpfe8Jbc@vger.kernel.org
X-Gm-Message-State: AFq9FYLdfQFGIDL2AJs+GGmPpl5LxqSZYm/SneIUEVgPs4rhe+bBLGpp
	+CbpNwrIktF99qX3ikXKBKVVNlB9Xbly7fUboVMeeu7ie6ozzpTQdlLV
X-Gm-Gg: AYBFou0ErsjziD2zF30nC2lQC1Di0V0G4U5UvM1gB6CaNU1uclUQtWoLH7J6931ne7p
	6MPg2vL0OvFJ2GNu9KOk3mgQRN1ARTluVq9E/LhqOY0cVK12UxDhE0UYs62nU4NPlT4aZQwcyfx
	IvKfeNmMJE0WP9bYhJaPjyrVhVF7ilLSsrD1p301xdXFPCZNjH/khWueFNUkr0TRJOBQuHJTvqm
	xhwLkUcixcmeyo61HkPs7omw0VVlZNGgZ/IRxR0xvI8Soa4X1sJIs1uHEoO6VSEvd0lAmBVM53w
	EAsfq78SYlq5rjnf38BwcRePKjoQWajrOej/PzgajbU35yqum0umObWCpxF8ExW9Ib0I76kuNl1
	VaydaNwlPtkZDlSQib7pDCFv+Jum3EKYOQt/AHSUIGc+Hc2r0/yesTn/t6HSUhpnl/5USUs5HPm
	gbeYPkifFb8DkXbit7ANXOu9p4BmBOJBzzMA5RIhhqOtAf53SP7TE7I+of7t4bFroYaf7Qc/J0t
	ePxMcPl8Ig=
X-Received: by 2002:a17:90a:e704:b0:3a4:7195:ecba with SMTP id 98e67ed59e1d1-3a8a0e0974emr508925a91.20.1791345458952;
        Tue, 06 Oct 2026 20:57:38 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853e66560sm7888387a91.6.2026.10.06.20.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 20:57:37 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev-bot+sashiko@kernel.org,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH net] sctp: revalidate output stream after association connect wait
Date: Wed,  7 Oct 2026 12:57:23 +0900
Message-ID: <20261007035723.3470881-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CADvbK_ed4ruZjf8CV_jGN=JPkJDHwwZ_9vx+q3zdHnFYiW8dLQ@mail.gmail.com>
References: <20261002010449.3689454-1-4ncienth@gmail.com> <179124882160.434549.10169630192303444846@kernel.org> <CADvbK_ed4ruZjf8CV_jGN=JPkJDHwwZ_9vx+q3zdHnFYiW8dLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks. Both findings are valid. V2 uses the suggested range-and-extension
helper at all three points and returns ESRCH after the connect wait, leaving
the existing caller cleanup unchanged.

pw-bot: cr
