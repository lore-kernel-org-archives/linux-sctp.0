Received: from zg8tmtu5ljg5lje1ms4xmtka.icoremail.net (zg8tmtu5ljg5lje1ms4xmtka.icoremail.net [159.89.151.119])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6196D2D6E58;
	Sat,  8 Aug 2026 00:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.89.151.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786150706; cv=none; b=EnRYmAU2K+02JoYAWyb1N9PkU6iMe+SJBPjqJSU046I83Qk3LVssq+CGmRZlJ+1hArRtAydH6AgfhX+YTo/Ks8G2XSVmjpEfzfCIqW+0xjAYkn8yJUfARDVhqCwnZyFCNsQJl9sThowsUWYND3VJGn8UN+WjnkcBt2Q3/bedilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786150706; c=relaxed/simple;
	bh=yZkREdEjHQEDUr57udPnaYwkQLcQxYJhgfKaohafuPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b2rfGKXXLNb+ZsfDbLEXOKo4WyUzY1ITZrqLGqyIYPUykL4dtUZvd3BkBovdLE9WgBdon8EMiA2i4FaVlfku94RqTKNcKJ12d5vOwrpUUgkYyBB04THo1tcEYjPbIa/CA0ajHqP+Pe3Rof5NlytUzpXZ3TjNWUCIFpbkg8ASDz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=QepjMXoc; arc=none smtp.client-ip=159.89.151.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="QepjMXoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=TNDApsOsnp2m2lDrTJuIAVtUvQ2U/qmosQ
	3lDWNOF4A=; b=QepjMXocUszGkTzHW3esG5/gCgz7RAoajs/svlf+M2KcxcwnWs
	Tw9XF/U1iwB2SXPfdwrqjJ5eB87NWOxdorrxSAb3C33RPYEaoyiIApK8ccez4N0e
	tsKxgPwN1eAsWXPSGbqGpMw+JigNC9jpAzsIfRWOfuUjZrYT8ts5DW9KU=
Received: from gpu-server-2.tailcd67b0.ts.net (unknown [101.52.241.91])
	by web2 (Coremail) with SMTP id yQQGZQCHgrQOf3ZqgbvKAA--.21278S2;
	Sat, 08 Aug 2026 08:58:04 +0800 (CST)
From: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
To: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org
Cc: marcelo.leitner@gmail.com,
	lucien.xin@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	stable@vger.kernel.org,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	yyxroy22@gmail.com
Subject: [PATCH net v2] sctp: fix use-after-free of cached ASCONF chunk
Date: Sat,  8 Aug 2026 08:57:48 +0800
Message-Id: <20260808005748.1981039-1-yangyx22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CADvbK_ekVxEzb=-sbphAtmzYYXqfggWX2h3CK24s84MmQvahJg@mail.gmail.com>
References: <CADvbK_ekVxEzb=-sbphAtmzYYXqfggWX2h3CK24s84MmQvahJg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQCHgrQOf3ZqgbvKAA--.21278S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4kuw43CFyfZrWrAr4rGrg_yoW5Ar17pa
	98Wr4ayry5AryxurWfJr1Duw43Krs5J3y3Gr9YqwsYyFs8XryYkry7Ka4jqrWkCF4kAa43
	KryYqFn8Gr90yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0x
	vYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_
	GrWkJr1UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zV
	CS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAI
	w28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUEAp5UUUUU=
X-CM-SenderInfo: 51dqw5r0ssqzpdlo2hxwvl0wxkxdhvlgxou0/

addip_last_asconf caches the outstanding outbound ASCONF chunk. The normal
ASCONF-ACK completion path releases the chunk and clears the pointer.

However, sctp_asconf_queue_teardown() releases the cached chunk without
clearing addip_last_asconf. During peer restart handling,
sctp_sf_do_dupcook_a() queues SCTP_CMD_PURGE_ASCONF_QUEUE, which invokes
sctp_asconf_queue_teardown() while the association remains alive and leaves
the pointer dangling.

A delayed authenticated ASCONF-ACK can then reach sctp_sf_do_asconf_ack(),
which accesses the stale chunk and passes it to sctp_process_asconf_ack(),
causing a use-after-free and a second release.

Clearing the pointer exposes a race with T4 expiry. Peer restart handling
queues the timer stop before the purge, but SCTP_CMD_TIMER_STOP uses
timer_delete(), which does not wait for a callback already running on
another CPU. Such a callback can reach sctp_sf_t4_timer_expire() after
the purge and dereference NULL.

Clear addip_last_asconf after releasing the cached chunk, and make
sctp_sf_t4_timer_expire() consume a stale T4 expiry if no outstanding
ASCONF remains.

Fixes: a000c01e60e4 ("sctp: stop pending timers and purge queues when peer restart asoc")
Cc: stable@vger.kernel.org
Suggested-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
---
Changes in v2:
- Guard sctp_sf_t4_timer_expire() against a cleared cached ASCONF pointer,
  as requested by Xin Long.
- Explain why the T4 callback may run after the restart purge.

 net/sctp/associola.c    | 4 +++-
 net/sctp/sm_statefuns.c | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5b0ae61..737f8ea 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1713,6 +1713,8 @@ void sctp_asconf_queue_teardown(struct sctp_association *asoc)
 	sctp_assoc_free_asconf_queue(asoc);
 
 	/* Free any cached ASCONF chunk. */
-	if (asoc->addip_last_asconf)
+	if (asoc->addip_last_asconf) {
 		sctp_chunk_free(asoc->addip_last_asconf);
+		asoc->addip_last_asconf = NULL;
+	}
 }
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 708fa07..3a8e16b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6145,8 +6145,12 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
 					struct sctp_cmd_seq *commands)
 {
 	struct sctp_chunk *chunk = asoc->addip_last_asconf;
-	struct sctp_transport *transport = chunk->transport;
+	struct sctp_transport *transport;
+
+	if (!chunk)
+		return SCTP_DISPOSITION_CONSUME;
 
+	transport = chunk->transport;
 	SCTP_INC_STATS(net, SCTP_MIB_T4_RTO_EXPIREDS);
 
 	/* ADDIP 4.1 B1) Increment the error counters and perform path failure
-- 
2.25.1

