Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D18361958;
	Thu, 10 Sep 2026 02:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789006119; cv=none; b=URATu5RAszaGLxN32hy0MA2QnUVjgrbDgSp/LSFQSDTsH4S4X2zLwLjRC/PhaNzs5eLGhvbAMgkj3BVscUPbM7GyrZYIblkixlBt28hZ5booOG/4zW/qjX+ni2oPEmZaC4PX+Zv2YY3dYXWAM2pqBTkgwyV8RHNgPQxcmM3FFM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789006119; c=relaxed/simple;
	bh=8Oc18qarRUAf/LBE9vYwxYldzVLszQdu25w3AHsnm8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ4FukXA2SjYOSWT2ZXsMqVbWknKEpgZ0bzWXxIYjatXJYxChXcThX9G614kE+um8PUlDUg35Tdr/Jl9AL8lSQrdm1ehkT6oBjg3qP8hmAMUXHkW/of2iRr0fhe9j16q31uLpCtNrUNW3ZHg0TeDy+6VP+wSneTA2DAeKsEDdg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=chbmszRF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="chbmszRF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8O
	c18qarRUAf/LBE9vYwxYldzVLszQdu25w3AHsnm8Y=; b=chbmszRFMpTFiv4BXe
	/zcfRbuKN8xt5yeiC1uzwvOi/AWAwKl3LKeW51YKYywLCUeZtvCpWAqIP0O2sBdV
	wyfn6FxZ5K5zhWRtNxT53+sLfWBbHL+deNO8BSlTWlTvu9KECVWr0P2PGkkWST9T
	Xw2nmjzfyz1HvrR/25HEK6a1E=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXCpX1EKJqc+4CBw--.33406S2;
	Thu, 10 Sep 2026 10:07:50 +0800 (CST)
From: scott_gzh@163.com
To: lucien.xin@gmail.com
Cc: davem@davemloft.net,
	david.lee@trailofbits.com,
	dominik.czarnota@trailofbits.com,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	kylebot@openai.com,
	linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	marcelo.leitner@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com
Subject: Re: [PATCH] sctp: hold shkey across socket migration
Date: Thu, 10 Sep 2026 10:07:48 +0800
Message-ID: <20260910020748.3643902-1-scott_gzh@163.com>
X-Mailer: git-send-email 2.41.3
In-Reply-To: <CADvbK_dWeqUFR6XqC-BqjjwsWJpNjEeER-fJ2SVYKhUObkMm1A@mail.gmail.com>
References: <CADvbK_dWeqUFR6XqC-BqjjwsWJpNjEeER-fJ2SVYKhUObkMm1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXCpX1EKJqc+4CBw--.33406S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUF8nYDUUUU
X-CM-SenderInfo: hvfr33hbj2xqqrwthudrp/xtbC7BaEImqiEPbrXgAA3H

Hi Xin Long,

Is there any progress regarding this patch?

Best
Zihua GUO.

