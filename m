Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794154331;
	b=soSel4dv36WAa+rglHaeK0grB9k4AMg/Dnb9ceISTgMjreTRxshyIZKdU+HyI9NQmbXq
	 92/jpDQ9wMxqD2CkTEQD2yJh8DpOWst9PvatJo6GbVTOVrqtgD2DiuHhnzEVtJbUALTmR
	 XHOlyDD4U5niUX4ous1KoNe6pCrRYaiBeE34qr9ObpVWEbryTd6jtw1m+tm3rqcMAYNTc
	 hkzSqMPp4ZuBsEDhVPqMhegCizdI/hW6W4l59qTVJJ/BmjxN6DdfMyzhgl1++ukkf98z6
	 a/4TNuaUfiTjjTe1RFHxod27cGhw7bNE40gV6gElaD6YtPCEHLgYiYCHHbplNRIn6dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794154331;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=89T9eyf/7pt2w5bHMloyOSyIASgmUej+LCY3qWFQwTs=;
	b=ZtKERGUBPZqrAZHE14Y5+FDHA86/hSfXi/uHGLNBi3gDAtWwbMf0iN7SfODzXBbASs+Q
	 gwa54kyUcYhqkSz6JD6qWua4ro4mzKp4TJGZnMRONlvRWevkxd5TCkNOo2Rg0TMHRil5i
	 OWftPLcPFugOnJS3hcx9DmSfqgoVOsfSGexIBl4/DhSlKF0i3EJdn4gpljrqVB4KQ8svu
	 16O4m3Zhd/ODyT8FBE/Rj6HGiMvuds7vettUWuVZY842t0m9znK/NcXhKkrETXpdltbJM
	 7aPIHjkMJfIE/DMHUonZYsgITOIQDqkXg+6PLwkrLMGaxDo1QbXfM3L55eCx6XuwB0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JZ4Gby2F;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BED606A31C
	for <linux-sctp@vger.kernel.org>; Sun,  8 Nov 2026 16:12:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5BED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JZ4Gby2F
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1931ff67a29so447756c88.1
        for <linux-sctp@vger.kernel.org>; Sun, 08 Nov 2026 08:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794154330; x=1794759130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=89T9eyf/7pt2w5bHMloyOSyIASgmUej+LCY3qWFQwTs=;
        b=JZ4Gby2FvC2DBELHKFx4SybDLlGtuB7SQ5XgQ5eR59R2j4Wg931xxWyqTJsGcWV8FI
         leBHwUTE0i6796d8QedyDtdwFxpDyWOw+9Y4q7WcrU7TRHMlMTw3w76jZSSajMGMDJ4v
         4XdIGavyeSMSmY6yumPOTrqDSGHXfU6Z85RMvzjKYX87Gd4vmexl0CSQ6jbxpB2/YLRC
         NstZsnB6mkmNZ1PoEAGSqdyn6ZZ9Ohhg4+7TwwfTeOLfE+ggP9wOjYQkp8+DdpD+bxW/
         vQi5cFukX7xg1v0XtHq39C7mVEfVv0amHiDB67Ntg0Zh87z0aGO6trfKrcugE6gm+8Qa
         BxWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794154330; x=1794759130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=89T9eyf/7pt2w5bHMloyOSyIASgmUej+LCY3qWFQwTs=;
        b=xgak+TQRT+mE6aA/GJ38bhosSu3/TYqL7cAL+GaUfoEcpduDb8su0F+CirJL+onWbH
         6fT9gsMPqVOOMq0mA7SfFfxfqLkGbuYwfUJNIS8dmw61jMn5hrhI76nTllZcjJxA1YOo
         VEsDli+Ypo8qGl2aD2DvyUFGP5vRGRL5Ep2MCjJpxoINO2CIAxnL5Vhz00MiVl+K+nV3
         xCNUgPLpXIgtLpOx1VNsIxM+rIrJdJabIYHS8hYSTC/2a/b8vrnYKNGiHtYeUAQqwgQM
         fhSZUzM3YNCWvFHZWAoQpOrM6LwAAzUouVGnPl+lbBkLnzkqM2/2DJUGmdEr7U48PIZQ
         tr5g==
X-Gm-Message-State: APuU4Z/dB14+4Bo8C0cELoQ+GNLOqky1ZIfrlvHs4NX8hbuES72/AVSG
	SMM61k8wbhuSlds0G2FfgJJpIODa3QDWXc+TrlI5r1Kgx6hHaykaMDf6
X-Gm-Gg: AYBFou28sFI+SHMdsX15SO35qXU1auD9BZkdiyxlEfjWGXY7PdoMc2c94th1vOB3lDm
	f/6d0p2j61fIcJjYyK35qDoJzrBM1TYQtGiYaOMtDW8nuYSCeM45iS5ZMOQe+g+xN0qU4dyOoct
	4tJmymEusFC1HkzboguFdTWdLeVYH36JlAHRXBQUCez//VAQhDoNXNbWV8f8ruUMpj8vTB3D5E7
	tH7vKO95WTsnQ5tDtt2/0s417oo6fDhGbeuOLsjJdmJpxajPuFGkVmF/kdUPEWp2X9HVYwLrVv5
	Byca937B9Ugwne4SFGSKS8SkpRbBvfW7FzigEK50PoN5UO9haLEln2A4WGWKfIxMlxs1r1l6MmN
	wGcOV42gsbG4WJyjmymTXyqQ/I8YEPb18SlCreY+7ijcRgdvuBRoXiYZL6MjX88KgMqv5uk8BAf
	56OK7M8O0xXLEVHG5Zt/rG2cloZOUTvWDiObP2+iWTLooLnDCVsnJrtqDjYzBWKf2rrENnuOUVs
	6sYpZ5xFJL7Yv3saAThnH/3EtfoGb8z7vPgK9qkrRHV+GApIjolHknETzZbKlwPcvIQ/X0sS8r5
	yjKiKlukGE9NeDUQVkqlo7hEII+8Ivd9o+Hsgfcr7dQ5ziybFyyUIRmYW9GTYdXYk5IXhjhGcBF
	nFpc=
X-Received: by 2002:a05:701a:ca05:b0:18d:ac5a:89ef with SMTP id a92af1059eb24-1b39fef0c5cmr3037830c88.31.1794154329553;
        Sun, 08 Nov 2026 08:12:09 -0800 (PST)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3731487edsm7103369c88.2.2026.11.08.08.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 08:12:08 -0800 (PST)
From: Weiming Shi <bestswngs@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Yongjun <yjwei@cn.fujitsu.com>,
	Michio Honda <micchie@sfc.wide.ad.jp>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] sctp: reset stored flag for each association
Date: Sun,  8 Nov 2026 08:11:49 -0800
Message-ID: <20261108161149.2774119-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_send_asconf_del_ip() walks every association on an endpoint. The
stored flag records that the current association took the single-homed
deferral path and therefore did not allocate an ASCONF chunk. It is
currently scoped to the whole function. Once one association sets it,
later eligible multihomed associations allocate chunks but skip
sctp_send_asconf(), leaking each chunk and its skb.

Reset stored for every association so only an association taking the
deferral path skips transmission. In an A/B kmemleak test, the
vulnerable kernel reported 210 leaked objects from this call path and the
fixed kernel reported none.

Cc: stable@vger.kernel.org
Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..ed91ceff45a9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -771,7 +771,6 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 	struct sctp_sockaddr_entry *saddr;
 	int 			i;
 	int 			retval = 0;
-	int			stored = 0;
 
 	chunk = NULL;
 	sp = sctp_sk(sk);
@@ -784,6 +783,7 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		 __func__, sk, addrs, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
+		int stored = 0;
 
 		if (!asoc->peer.asconf_capable)
 			continue;
-- 
2.56.0

