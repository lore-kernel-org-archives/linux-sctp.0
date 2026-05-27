Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2073212F89;
	Wed, 27 May 2026 05:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779860594; cv=none; b=DXZDtgWNSH5NvRjiCkEXhITTAfGlU52JDwW/gbJ684ZuEDg/cHDe64/OeBZfFLhJXJywjamQbTxAlmRA6Jj0LRQ2NWRRndtHLo7VKlP5HCppMMfWsAXPZnhddcXVRA56xUWQEW45QZagVD7JfW5desH1cXJlXHHgbN36T8wBo30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779860594; c=relaxed/simple;
	bh=dgxnsRzxuzPgCSH5uF9RHAkNP8LhdVIjjpDwb/smPlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REgSy4UA2UpFowP+zKyOry5QftUInNfe5CYUu7U3hkNILqeTMNL5YmVoJLeFZSDUiFJNqf32cbAY7Ebo+d/6GQstYLWNVrUaLEf7WM9DmKFZhzWOKOoxxbwWWZW1KhP8k0GsmjstC1VDfAdfDcQKS6Tl4N437wGGVZ6Xna2tviE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowAAXVv5ghBZqWSELAA--.26479S3;
	Wed, 27 May 2026 13:42:59 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	xuyq21@lenovo.com,
	n05ec@lzu.edu.cn
Subject: [PATCH net 1/1] net: sctp: clear current outbound stream on stream teardown
Date: Wed, 27 May 2026 13:42:51 +0800
Message-ID: <4d56a975d40611822b2bd44f2f215e3534d76276.1779632544.git.xuyq21@lenovo.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1779632544.git.xuyq21@lenovo.com>
References: <cover.1779632544.git.xuyq21@lenovo.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowAAXVv5ghBZqWSELAA--.26479S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1fWF4rKw1Dtr1rKFWDXFb_yoW8Wr4Upr
	ZxC3yftrZ7JFy7CFn7Cw1FvF4rKa18Gay7KF1Fkr1DZw4DGF1aqF1vgrWvqryxCr45uFWY
	vrn0qwsxKw4Uu37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
	JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEACWoVV86CvgAAsT

From: Yuqi Xu <xuyq21@lenovo.com>

out_curr caches the outbound stream selected for continuing a
fragmented message. That pointer refers directly to an entry in the
stream->out table.

When the stream table is torn down, such as during stream updates for
association restart handling, the old outbound stream entries are freed
before a new table is installed. Clear out_curr as part of
sctp_stream_free() so later dequeue paths never keep following a stale
stream pointer after the teardown.

This keeps the lifetime rule local to the stream teardown helper and
covers every current caller that frees the outbound stream table.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/sctp/stream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index c2247793c88b..207e0a77f9af 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -186,6 +186,7 @@ void sctp_stream_free(struct sctp_stream *stream)
 	int i;
 
 	sched->unsched_all(stream);
+	stream->out_curr = NULL;
 	for (i = 0; i < stream->outcnt; i++)
 		sctp_stream_free_ext(stream, i);
 	genradix_free(&stream->out);
-- 
2.54.0

