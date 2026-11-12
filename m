Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496099;
	b=p01oWZQAQA8mucdz1T6OQnTBZl1XquiM43GbTLVRWjWo29VhFL8AvRII7yNPfXzWeyRH
	 aKYIeV5Ynl4sUiFm1Siq5nMtYaBPkUG6M15HkLhFnYt/wkwK4v4RShYeTDlUzrMomyiVM
	 fNpo212tCIO0OlPdwnkRXoXf6Uns0r/TPEYNWcIvxDZ0J9dbmhkMK0uif4AXstQayP2qn
	 mJKhG8H3A7irEL2qcsqXpXZzcP7XAKFYMx1ePjgJVJhcSaNt4ineslePmOREZkf9KCjtE
	 OjFcRiRKh1O9v/Qp4230CI3T712QsI9MURgf7+GeM9cZGYW/9G3cwQrFxyaZm9V9CFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	b=sD690bMfUGtfnkPIg7MporwITnZ3uEa5yJSu4aYhWeEssfZWvQgoeEOUr02IbNw9Dus6
	 Xm87Ra59q0IrBQIutaFu5RZBDJNF4slrJaODBR+7FQfLs52RtPIBrwtM+CVJ5UFvwu8J0
	 nmFedQRbVuGnCIAu7O702tfh/+v5lJ3m/9cFkOg2yC/6yoO/ldO6Cd0zxWEZzGowOlH7Y
	 UXDDdPstIaDZxQFrpr0ev5FO6O2s7og3JuEJan87m5QiKSKgE3NmaESYDK0AbIHiFuWy1
	 F426Kvkx3ricNd/flyMlXQA/nEPp5VYSffSqzS3PeWKn1c72uHj+91qFKpN3xKPECig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aWRO/zSp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448C606A321;
	Thu, 12 Nov 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWRO/zSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56221F00A06;
	Thu, 12 Nov 2026 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794496099;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWRO/zSpuzilyajkVVgilWOlD8ujV7ylA6SGx3jTb+HgLCD5QfJ4PyYR1Em2yquUI
	 MKTaUUKmMGGBXn25cEOPXc6lXHAbMajZ70wK2AUdhXB7/ZT6AENtikTg+zYj0rBoVO
	 zuOxiy0UB6MqAqZESPQHhdJx7ped7usYMXXhaZ3LfmajCx+hqaMisSALs5lJznmC0R
	 Ovt0Jyr+qFBF0kpn6jHOpoxHPiBq8CfISQBOdjRgRynAd7GQZ5WmWr2xBqmh548efZ
	 ATs/mmqXJVfm3A4ZD7qmSRYJGBrfGO8P7ZF1dK3XumePwClAJAxjuw6wQvVDcosxIg
	 s9DCLjLCs8z+w==
From: netdev-bot+sinfo@kernel.org
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 on Sim <tlatkdgus1@gmail.com>
Subject: Re: [PATCH net] sctp: validate SACK pull length against chunk length,
 not skb length
Date: Thu, 12 Nov 2026 15:08:18 +0000
Message-ID: <179449609839.2168702.14619030947263823831@kernel.org>
In-Reply-To: =?utf-8?q?=3C3fbf59d17a91c46098e3d4115e06987918b68c45=2E1794495?=
 =?utf-8?q?702=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C3fbf59d17a91c46098e3d4115e06987918b68c45=2E17944957?=
 =?utf-8?q?02=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
