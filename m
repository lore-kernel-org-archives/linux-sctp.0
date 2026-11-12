Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794507772;
	b=yvJsYe4G8fpPuvCX+BEpMlp4UZneZRfHUFlBcctJbZ/6kcylk2RJrewRrKj1p2Xyobau
	 bHdE6gK7q90o4q4t7vExGFATbbqZVOablqsvWJBUqDmKmqb41pRhltQ/jJ+spGmjjztyl
	 lc9bE7hmJ2gjQHiD9bsYhdl1XX55iudI9I/MJI9Eg1w41xqMi5X83LlaG5mA/4voIi3ih
	 5pi4Km9/QSsdd8fGaG/hr8KiWHadt541FL3fOyx3diLjBhS4HXgzlXj6QnhQyhS6V+5gT
	 kXpRmJnq3J8OlOx7xg2vgIRgKhurFs0wD+O3MRg5Gpfb7h+RAgxfoXt28qUvTet8wmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794507772;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=n44GLeAOgDdye7NV4IO7bRTFU8RygkQW6ehpVCLImtI=;
	b=V07Q+08irgPaHmivMNS6rumzE+QU9xiDj2QY3cFYWgH3RM9EeCrfPvj+n52QVBKGQb5u
	 esjzWoYK3++sCYzqluhvNcL6GUTq24zkDKnNtRnd+sdCWJS0CKxYjhNAFjT3GVhQ89kyA
	 KzD0Yff67AOE8rG6WstUmx7exvB5WelH/o4ideql02t2f5n2LE0k1hft9qBNuBBnOeoZI
	 knKFlahNf1bMQPZFE6Tk64ddhkWIMjIXE9qJ5zoKJ3EmZNB6P2QWumRfbprvlNI5QonS+
	 AWq7VSoOlrWQ/LwHeC9vnJXz2wLyue95klQc8nnXan8haznMUmrz2YpMN91+iBKbuGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxU4ML+T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3DD606A323;
	Thu, 12 Nov 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxU4ML+T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BA71F000C4;
	Thu, 12 Nov 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507772;
	bh=n44GLeAOgDdye7NV4IO7bRTFU8RygkQW6ehpVCLImtI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GxU4ML+TLMjtDNoh2xlJVi9HpPIyc0pTBIhhinjawsj1lu9tBJQabgQfB8IlNhQ8D
	 bmFBuZx2dk6a+/aA/tgFOVmARFnWldombX60pDWKGuWS00a7utqpjJ/V2RvQ9kld6j
	 ipon/Khmwbe5ZOJzgC8SKnqT3Vg4Xd7TcQcGcLF5J2cCxshj9ODeZF/TKwU2a+PqVd
	 yjeF1c5pdteYlhsF2Cukk79ByzblM+otqNortzlcC4JaY5d8SL5KsAORY76P+PkttN
	 vdZO+qknSkkOQsMlj1i7eQquYSXm7iXCCJB5wvPn8tWWyS5jkf4+f9HBaIlg5dX5qL
	 8R6wtEkFcB6ng==
Date: Thu, 12 Nov 2026 10:22:51 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: liuyong <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sctp: revalidate the association socket in timer
 callbacks
Message-ID: <20261112102251.6403e562@kernel.org>
In-Reply-To: <20261110120212.1110283-2-pkfxxxing@gmail.com>
References: <20261110120212.1110283-1-pkfxxxing@gmail.com>
	<20261110120212.1110283-2-pkfxxxing@gmail.com>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Nov 2026 20:02:09 +0800 liuyong wrote:
> Signed-off-by: liuyong <pkfxxxing@gmail.com>

We need real/legal names, one lowercase string doesn't look right.
Please update
-- 
pw-bot: cr
