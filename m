Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF10233941;
	Sun,  9 Aug 2026 04:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786250331; cv=none; b=Zc9Qkyl29kzRu/keGrls52IH1oq3GJhcQFL/h1WEqXWdm30LGvFLZFrO35rvxNxrqiB7BAx2MUrpOkRPsSkbnr8UFnoWLAgeqv+YDN99qkrJHxwrPTV9X45tkwx67+PjQKM6hINFovJyDp9dMJmjpkTpcyuQ7TmdqbRgvvb7ZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786250331; c=relaxed/simple;
	bh=4DIx6TkWapH+ISFuWKKjHgUAXSUWtPV2eFJMZdqjAjE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SA8iVNOf4TFlDE+TTC6o/FsKrtlIHcYvWMF/AXOR5rdlrKjOJ9mbsnK/zTd/q3SVaTOb7J/W82SuwMocvCpHMFoINWknZF+08NPlZCIPuCwUGhUj0HYI3YVb5kH1WZrAqGpVxm1iC4bzYIu9AuIU2WDJMkUR0pHcDKyrwL008AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=q5my3BhW; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="q5my3BhW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=pbc1D
	ygPU5FHcCkiV34sTFvKLefj9qBIwFd2cDmn6F4=; b=q5my3BhW7BcBIBjKV2xYa
	UgbV+cwnClQZyDHfrVichjSQjzhKVFue4mEBZKd44ZUxnUkIrTmIaO5TrpLjc+Nh
	TX+TlaL5l8PymItODPp0KHncpamB+y3h87b506g1WJktlkb0wHhCtwotqiLfl0dM
	7xDc1BLhzV4VN5RZaYy9ag=
Received: from gpu-server-2.tailcd67b0.ts.net (unknown [101.52.241.91])
	by web3 (Coremail) with SMTP id ygQGZQD3xhUvBHhqvt11AA--.31585S2;
	Sun, 09 Aug 2026 12:38:17 +0800 (CST)
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
Subject: [PATCH net v3] sctp: fix use-after-free of cached ASCONF chunk
Date: Sun,  9 Aug 2026 12:38:06 +0800
Message-Id: <20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygQGZQD3xhUvBHhqvt11AA--.31585S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4kuw43CFyfZrWrAr4rGrg_yoW5CFWDpa
	yDWr4ayry3Ary8urWfJrnruw47KFs5J39xGr95twsYyFs8XryYkry7Ka4jqrZ5CF4kAa45
	K34YqF1DCr90yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l
	84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1lnxkEFVAIw20F6cxK64vIFxWle2I262
	IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx2
	6r4rKr1UJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4
	CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF
	04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4rKr1UJr1l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUzSoXUUUUU
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
Changes in v3:
- Resend as a new, independent thread as requested by pv-bot. No code
  changes.
- Link to v2:
  https://lore.kernel.org/netdev/20260808005748.1981039-1-yangyx22@mails.tsinghua.edu.cn/

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

