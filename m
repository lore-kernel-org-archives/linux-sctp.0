Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F14C187C
	for <linux-sctp@vger.kernel.org>; Tue, 21 Nov 2023 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8eax162"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F33AC433C9;
	Tue, 21 Nov 2023 01:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700528716;
	bh=WydedWHI5hgSzmjYaAgFcEvQrWisnvd0Tah1sl3VwoE=;
	h=Date:From:To:Subject:From;
	b=o8eax162YMj0zcLaqYv7+xWhsyxal2zDwVnWiTm4xiAZ5u3d1GVq+jxQXMXY7F+lF
	 RNCF5oe7VbshzPJXrt98amgsmXhCidkH1hcfsrs/or6Z7iFAgNwu+nhAtEbyEtVepR
	 297SwLMk5wg7JzMAdtRc9rHtiUUX9p6E1Lf0glWc=
Date: Mon, 20 Nov 2023 20:05:15 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: linux-sctp@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231120-gigantic-meteoric-spaniel-f5ccdc@nitro>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to new vger infrastructure. No action is required
on your part and there should be no change in how you interact with this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
