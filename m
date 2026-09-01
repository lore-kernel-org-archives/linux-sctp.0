Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7433D6F7;
	Tue,  1 Sep 2026 03:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234461; cv=none; b=cCpuR6x5uVcV1uQh+ZyxPhjcgjlLT9CY1cm12is5an9W5VPDKIgxFCCVVh7dY0vEApYTJ7jUBH3InotUkx1vGuaoQVs80HzaEUndwNLnmpTSAz9VqfO9WRqDPHOK2xVjeQb5LE4zBgCOQ2XbJjNHrwBx0UDszgl2ok3pGXX5w3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234461; c=relaxed/simple;
	bh=W0Id0Pf68vSruKPAPVofzbJEMCYxPO8Y+jLfSTczdks=;
	h=Message-ID:Date:MIME-Version:To:CC:References:Subject:From:
	 In-Reply-To:Content-Type; b=BBtuOD6eZGxh0XXz/u+haUJq/YmEtKG6Q+BAoE4CVeG8ulL2h6ugPcAiPG3ekI6QOIxx4mXHUKUQq473o4QKnIUMeZO173jHejux4qRpmAwzogY1/VnkGChAcC/SQOrxMjdbf8uWq0V43mqA0EQeGQnWaH1kxK0tpgNWlWFX9eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Iwnj0++u; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Iwnj0++u"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0sIKT5aAMI3AbebxHeg10Bs0qjcH61HwUS46wKZqAHQ=;
	b=Iwnj0++utJzA++JIpLf6EKSwabk8bRjr4beqhMKlvKRXOJIsoH2M4xl7Bcc9i8OeaAbT49aIi
	vV8h+OhqM7uHKJ5o44KoojJCFi7eHMyvIXIZbqruo9H0FT+nebIrFYK6HgC7gTrqaaowWSbV4fC
	onnvoXO+Oj9jLJQbvBADeoE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hYs2x1wVJz1T4Lb;
	Tue,  1 Sep 2026 11:36:09 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F07740561;
	Tue,  1 Sep 2026 11:47:29 +0800 (CST)
Received: from [10.136.112.147] (10.136.112.147) by
 kwepemr100001.china.huawei.com (7.202.195.168) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 1 Sep 2026 11:47:28 +0800
Message-ID: <68cb4941-3668-44f1-a889-6b2f023b2a08@h-partners.com>
Date: Tue, 1 Sep 2026 11:47:27 +0800
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: <syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com>, "David S .
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Simon
 Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	<lucien.xin@gmail.com>, <marcelo.leitner@gmail.com>, Paolo Abeni
	<pabeni@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
	<netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>, gaoxingwang
	<gaoxingwang1@huawei.com>, <huyizhen2@huawei.com>
References: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
Subject: Re: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
Content-Language: en-US
From: xietangxin <xietangxin@h-partners.com>
In-Reply-To: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100001.china.huawei.com (7.202.195.168)

Hi,

I have analyzed this issue and successfully reproduced locally.
The race occurs between the timer callback (`sctp_generate_heartbeat_event`) and
the transport cleanup path (`sctp_transport_free`):

Task 1(Timer Softirq)               Task 2(sctp_transport_free)
==========================              ===============================
sctp_generate_heartbeat_event()
  refcnt = 2

  bh_lock_sock(sk)
  sock_owned_by_user(sk)
  mod_timer(&hb_timer) -> returns 0
                                          sctp_transport_free()
                                            transport->dead = 1
                                            del_timer(&hb_timer) -> returns 1!
                                              sctp_transport_put() (2 -> 1)
                                            sctp_transport_put() (1 -> 0)
                                              sctp_transport_destroy()

  sctp_transport_hold()
    -> refcnt is 0, increment fails
  out_unlock:
    sctp_transport_put() (0 -> -1)
    -> refcount underflow warning!



Adding a small delay  after `mod_timer()` increases the reproduction rate:

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -373,8 +373,10 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);

 		/* Try again later.  */
-		if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
+		if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20))) {
+			mdelay(1);
 			sctp_transport_hold(transport);
+		}
 		goto out_unlock;
 	}

Any feedback or guidance would be greatly appreciated.

-- 
Best regards,
Tangxin Xie

