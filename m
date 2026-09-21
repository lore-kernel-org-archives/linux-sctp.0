Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B6A1CAA92
	for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999081; cv=none; b=coKwg28ryp/OWigQlo7uhdxGE+c+Tz1HS3kDP5Vflb/jiSHWrAuhr/8vElCaG/X81HyqzcvRj/x/OdCJmB1x+iJCsEjY+EFzWwURiiE3/5dauDjuO1xPOjrX2UYUIniLtpvJ24GhtR0y8NncG+SbwZN3il35wgfSQwocOTo8PIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999081; c=relaxed/simple;
	bh=scCajsGDahX0/C42DoxVM831Xi0Na9KZ5VIUIH33XnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dLdYy499T7WXHVoINVmmi7uJL0OvolDnr8BVSZ4LGGf29rDsy5y8445gwdVn77w2NgYx1+A5j8PYWzlIOeD6iwYtUKdIkiXq1ORpNB4CQGsMZNYVl5rVgNLIcuRBOWbxOzoN0WBJe8KAVZCTafQ6r7y8wsYUfRY8clBgsk5j/h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=OTj8RqEG; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="OTj8RqEG"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a58so454052266b.2
        for <linux-sctp@vger.kernel.org>; Mon, 21 Sep 2026 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1789999076; x=1790603876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EYb9djJ650f+j77K71sOdKHCCKyIjN5iGG67MyIXzHI=;
        b=OTj8RqEGF+l7bCcbT5hmWzczPcMMCF04cVxsA9gd8KK9TkWoWZaTjN8rAcrIV9djmR
         KuUDyAGWBG9Upx0+NyW0m7phkvCSPBelDgHxyra+2VIHQWaiWpZlzT3gHbNqtpK+rMYV
         GZSsUF9GASy/7ger6mdq1WWdjsBvVBf/5ZhKIQHQX8Rryz2j9r2ySIXAOak/xegY0Tm/
         JOUl9HDSegQU3C6kLhEgY3Q9pFVZ+H/FXdF4f/nsumDThPlKH7KjCPMoOxSvnFRyClzI
         /3DqWw7OxSk2+FN7IzoturcTIB5J6s8xdMiBS2u2OSlHeCcZmBROeAbapk6nNZQf5wxp
         9Z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999076; x=1790603876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYb9djJ650f+j77K71sOdKHCCKyIjN5iGG67MyIXzHI=;
        b=T0+wmvDY9zeAmDvWwkzSSmcVpa7ZOaRfGuInni8KTltp0BRLD3MfElnNhTF+AJVvNX
         GKT8qHludzEQgSY6BhR83sEPJ8h60rUKJNUj7nEDOFG8Vlu+v4RjMFkKrvYeTzXd7z7X
         un5inld3choceOz6kicgrPiObIdhWek/qUo+To48HciD1M5vUsuxxStyAMzIDjGqkGzw
         MjVC/gNJEUGd9RJw89SjaiNjryWGFGNLYAgBqxmH7Xl6BtbRht4fSajli2uBf8q0U4So
         /IINbT/u+QMFIiU1McenDeBZNelFrTMyIXv29eg/5vFeLXXSNm1+wmDy1a/5HhGjIbmJ
         xhzA==
X-Gm-Message-State: AFuF++kvwX/pxEVHJbrMAlSGpIAZNIIT8OpHp+1LQJ5MgbQhoHSMBl5G
	59/z2rQdZLK8F7BLnik6Bss4tKClgObBaoEylNc9lm/5Su+ygz22R+nAUIGe+xDXlL4=
X-Gm-Gg: AYBFou1HC8yqxthhKoYlz6XvmisBh4He9AJmP5iqWGBei8NOTXi2etd2kA83ZJo6K3X
	aEpK4IITcmWjRH0c+EKq681MBypMXWNjQjBNbNjkUd7itOpuFZG9h0o816C1/5YKhXT4HJQTS9b
	tYh6rjHx4W8gp63WUk12MBY/fl9wBO+JZQP1fvE4RtnfgMGuu4VbnYnq0ha4bETTRIPhVewUR6z
	vRe9i0KyOfIqfOaNn+Z+inNaRPdJGf1BogOC2W3tigEngFg4lqMGDhohZN0OCxES/KCREuoykbw
	FduYDrecIa7EBjVRjrFldFY/n82qRexrOAd80qpOUY4aLzQuPKehS3A+AWTaswpviPHFTQsYJmG
	82RwebjYe1akUIdHfWSsDOP2UbK/IG1j4THyq1eeHjfliBWnQYyedLtkLTUak9GA1x1mubB8COU
	fZn6tS5hPOdipZ+GmnEM+txVIE0m+uRBEo8dftiZ0zHHAeZ+G+3tni99z6AyVPqb4RDb46bZko/
	6zv1iR2GHoR/fNWF4cjKX1oVvRG7KN3rKm90n1nS/VM1lF1gC7Qdj5D
X-Received: by 2002:a17:906:f5a8:b0:c29:c356:6984 with SMTP id a640c23a62f3a-c2a1578857bmr907019266b.8.1789999076248;
        Mon, 21 Sep 2026 06:57:56 -0700 (PDT)
Received: from dscRocky-build.localdomain (ip-83-147-170-154.wfd.metro.digiweb.ie. [83.147.170.154])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a35745cfesm323987366b.38.2026.09.21.06.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:57:55 -0700 (PDT)
From: Warren Briggs <wbriggs@cellusys.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Warren Briggs <wbriggs@cellusys.com>
Subject: [PATCH net v3] sctp: carry peer capabilities across an INIT collision
Date: Mon, 21 Sep 2026 09:57:33 -0400
Message-ID: <20260921135733.577647-1-wbriggs@cellusys.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_assoc_update() folds a temporary association into the existing one
when an INIT collision is resolved. It copies asoc->c, peer.rwnd,
peer.sack_needed, peer.auth_capable and peer.i, and nothing else.

The remaining peer capability bits therefore keep whatever the surviving
association was given when it was created, rather than what the peer
advertised in the INIT that caused the collision.

Forward TSN is the visible case. The INIT-ACK is built from the
temporary association, so it advertises Forward-TSN-Supported; once the
collision is resolved the surviving association holds
peer.prsctp_capable == 0, and the first FORWARD TSN chunk the peer sends
is answered with ERROR "Unrecognized chunk type". The peer does not
expect this, having been told the capability was supported. ecn_capable,
asconf_capable, reconf_capable and intl_capable are lost in the same
way.

The two address flags fail the other way round. sctp_process_param()
clears ipv4_address and ipv6_address and sets them from the peer's
Supported Address Types, but only on the temporary association. The
surviving association keeps the permissive defaults from
sctp_association_init(), so it can believe a peer supports an address
family that peer never advertised.

peer.auth_capable is already carried, added by commit 1be9a950c646
("net: sctp: inherit auth_capable on INIT collisions") for the same
reason. This extends that to the rest of the block.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Warren Briggs <wbriggs@cellusys.com>
---
Changes since v2:
 - dropped asoc->peer.hostname_address. The field no longer exists,
   removed by commit bd4b28189469 ("sctp: delete the obsolete code for
   the host name address param").
 - wrapped the commit message at 75 columns.
 - added the Fixes tag.
 - retargeted at net, subject prefix corrected.

Changes since v1:
 - added ecn_capable, asconf_capable, reconf_capable and intl_capable,
   the missing fields identified in review of v1.
 - also added ipv4_address and ipv6_address, which are set from the
   peer's Supported Address Types on the temporary association and are
   lost at the merge in the same way.

Testing. An INIT collision was resolved between two sockets on one host
and the resulting association's peer capabilities read back, with a
second, non-collided association created in the same run as a control,
on an unpatched and a patched kernel:

prsctp_capable   SCTP_PR_SUPPORTED            unpatched 0, patched 1
reconf_capable   SCTP_RECONFIG_SUPPORTED      unpatched 0, patched 1
intl_capable     SCTP_INTERLEAVING_SUPPORTED  unpatched 0, patched 1
asconf_capable   SCTP_ASCONF_SUPPORTED        unpatched 0, patched 1
ecn_capable      SCTP_ECN_SUPPORTED           unpatched 0, patched 1
ipv4_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
                 with the peer advertising IPv6 only
ipv6_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
                 with the peer advertising IPv4 only

Three of those were also confirmed on the wire. An unpatched kernel that
has advertised Forward-TSN-Supported in its INIT-ACK answers a FORWARD
TSN chunk with ERROR cause 6; a patched one accepts it.
SCTP_RESET_STREAMS and sctp_bindx(SCTP_BINDX_ADD_ADDR) put a RE-CONFIG
and an ASCONF on the wire on a patched kernel and produce nothing on an
unpatched one.

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4521be3..0bd0a66 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1107,6 +1107,13 @@ int sctp_assoc_update(struct sctp_association *asoc,
 	asoc->peer.rwnd = new->peer.rwnd;
 	asoc->peer.sack_needed = new->peer.sack_needed;
 	asoc->peer.auth_capable = new->peer.auth_capable;
+	asoc->peer.prsctp_capable = new->peer.prsctp_capable;
+	asoc->peer.ecn_capable = new->peer.ecn_capable;
+	asoc->peer.asconf_capable = new->peer.asconf_capable;
+	asoc->peer.reconf_capable = new->peer.reconf_capable;
+	asoc->peer.intl_capable = new->peer.intl_capable;
+	asoc->peer.ipv4_address = new->peer.ipv4_address;
+	asoc->peer.ipv6_address = new->peer.ipv6_address;
 	asoc->peer.i = new->peer.i;
 
 	if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
