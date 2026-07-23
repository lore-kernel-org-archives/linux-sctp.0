Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023E470430;
	Thu, 23 Jul 2026 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816967; cv=none; b=U3wpcQA3Qa3x1nZQesc6pUOyOoj7GTHxT5e8jXQPd6lSu3YOZMKAf6r18Gd17JvhQgpIOZCwY75bwY47UVt02yKLSOXBbfDDUftymmhMSDoIahuA283JEoUc4cgdxDW1itAeMAKraNW2iKSnArGaoQH2wD0jZv1Ds1ma6d7j834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816967; c=relaxed/simple;
	bh=RDBKQM9xWLdZ7a6ZW8VV5ifHJkI3lf1A9xElNQIqGAk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kjm8mrIbH0lnsJa4WRPpGyjR37cjTyhAlw/80hO7gXqRa/bkeJssOPHhSIosq+9Oe14w0Q892pxUKNGhZbRGrbYPkG9wmBo6IyPPn0X4L1BZgMo6dMUuLUpQl426MMjSFB1Dh4cCBZXouz8VXLlb2unFvIpY2mPyv+tVZv/h1bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOcGowdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOcGowdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA31F000E9;
	Thu, 23 Jul 2026 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784816966;
	bh=RDBKQM9xWLdZ7a6ZW8VV5ifHJkI3lf1A9xElNQIqGAk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mOcGowdEsscWawawXc/dOgqzXQRsIEnkPqO8Qamyk4aHqmu6cGExapmy9qj4vt3x0
	 7DD+IiEvCq8ctjoykoQShGG9TJ6JOUFLo2I7ZsmeEBKH9FJX2/OW7S+pceLi4ZSloF
	 9WDlzHCo32dwTBH2YT4u2hs90GSb4MSM4K1HkwV8R6op3FSmjkOtdupm0QT9TA36Uz
	 yYq8ALSBqy7bTBh1jpZAvQmamRLMEoqny3bwqbvj+EvrTFRQJoY4TykVCQmAxrYm1N
	 wGms4FbJXQu5C1sBkkh1C/Wd7zXjMayYOIC2zGFp8FBcnjKrirVIxyUIBB/OG9lNW2
	 UNMvpk9DGYwwg==
Date: Thu, 23 Jul 2026 07:29:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jun Yang <1753810072@qq.com>, Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jun Yang <junvyyang@tencent.com>,
 stable@kernel.org
Subject: Re: [PATCH net v3] sctp: don't free the ASCONF's own transport in
 DEL-IP processing
Message-ID: <20260723072924.7db6b065@kernel.org>
In-Reply-To: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
References: <tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Jul 2026 21:14:05 +0800 Jun Yang wrote:
> Acked-by: Xin Long <lucien.xin@gmail.com>

Could you point me to where Xin Long acked this?
I don't see the ack in replies to v1 or v2.
