Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [40.65.178.148])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617AB36C597;
	Thu,  6 Aug 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=40.65.178.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786036600; cv=none; b=Lz0EPRSsRztBfdkZvwo0QQlHy0er8MTfkjZfPkyraKzTeml+vKU55CZy1eiY/bu6CTb1uecnF1EWaC0v43DyBOjmMf5xCN5JPpu1FfU50kGGLzUs1n8uc8cymIEOu2QIKhF2UtQxu/hARqt1sqdPLyy/6hFbKcRTmlNknLPtT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786036600; c=relaxed/simple;
	bh=CwuWe3oIk4AzuGunWz+SP2Hs726ScsZkq/Uf4Lf1ouI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iDt2/57NGEeMkW4+uMPPlHpotiK1F7SLt7/CfEov1NXgu3QktCIoDSjkwU15DBjuhNUR++dKppdgXidRUQMWeBG7/oBisFDx24ncnMbYL+ykuTH74z+bQBWh99bd2QwtC9VNJ/ounp6dXcvQ9qwQpgf/JDc9QHTsAuD66DAt5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=OwszU2L3; arc=none smtp.client-ip=40.65.178.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="OwszU2L3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=8Ptg1
	mK2PwCN7Sdld8TRmpv3xMzurCdFmlSv2qo+IKs=; b=OwszU2L3q7fYOa6pQObbA
	XHZp1hbKXDlAclWDXfLXFrzNpttuUurzVObzcfdQWCdb0qILDPdhA4prUFDWbSDD
	n4KG8snUhlM1kj5BQxIvRTtY3tA3dSW6r+l2XAuWV8raQnp8Wl7NXB8w/8uTcH86
	OOwqTI8WqSepdkrygyVb7c=
Received: from gpu-server-2.tailcd67b0.ts.net (unknown [101.52.241.91])
	by web1 (Coremail) with SMTP id yAQGZQCXO8tfwXRqRwFEAQ--.57940S2;
	Fri, 07 Aug 2026 01:16:16 +0800 (CST)
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
Subject: [PATCH net] sctp: fix use-after-free of cached ASCONF chunk
Date: Fri,  7 Aug 2026 01:16:14 +0800
Message-Id: <20260806171614.945331-1-yangyx22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yAQGZQCXO8tfwXRqRwFEAQ--.57940S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr15JFyUGF4UZFy7AF1DJrb_yoW8WFy8p3
	98Zr4rtryUGr18ArZ3JFn0ga1Ikws3J39xKryqyw4fZFs8Xr1Yk347K3WUtr40kF4kAayS
	grW3tF4UXF1qyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4U
	JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I
	0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIE
	Y20_GrWkJr1UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjI
	I2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5
	MxkIecxEwVAFwVW8MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUyE__UUUUU=
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

Clear addip_last_asconf after releasing the cached chunk. This restores the
invariant that a non-NULL pointer always references a live chunk.

Fixes: a000c01e60e4 ("sctp: stop pending timers and purge queues when peer restart asoc")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
---
 net/sctp/associola.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index b6ac096..cf3e807 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1709,6 +1709,8 @@ void sctp_asconf_queue_teardown(struct sctp_association *asoc)
 	sctp_assoc_free_asconf_queue(asoc);
 
 	/* Free any cached ASCONF chunk. */
-	if (asoc->addip_last_asconf)
+	if (asoc->addip_last_asconf) {
 		sctp_chunk_free(asoc->addip_last_asconf);
+		asoc->addip_last_asconf = NULL;
+	}
 }
-- 
2.25.1

