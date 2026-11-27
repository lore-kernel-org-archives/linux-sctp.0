Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795751308;
	b=M7PjMfA5OJbEoPlum+QhqpmYcNSN2oAP7vcQsu6kHHnn8e5AOeuegU1t0Iw9/I7Gck7e
	 6PhxThdWA0oeIKF6+VKxsQwp3nTgKZ9hg/q2Ms+yzBAMclzIhxCLU2LEIoqEUqCRtVR5w
	 7bUyPGzWPrGCkBgUzVpgZNBk0qc3bqs6TO9/HOPlcjkjh3f7fg7jd6FDUFAme3I13xTfz
	 W1L5Mkr72D30WPI9mnWZRFYMUyfiPQIOHl+t8dKjdf7/inMZ4aoGw5VOeBH/TOmmjyqiE
	 aVGHKvGa+AN1QthcRYoyVdlvEDgJU28yNpXCC7wzX6yJxvjM4kZCHOMv8D1uiY9poYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795751308;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=aDFhCXRtTylWBUSnUQc8h6/Z7DEYYF2E1fptzxvnDCY=;
	b=iWAnQSiBRiwBapGLXjYPi4W8siOca6KujbxpgSVCMui9UZ+fsrlCQlqpCGRS+0I68Q0q
	 SunxbacsrRVWugRSQ0sENmr4qr5ZMvsii0whxN1UVsjTdrWSzyB3xDnZT18twm8ylOwuQ
	 uEw2Sr43KvaHr1AJtplacjqZY0uVfe60xn9I3/ekagYFWH5CRekgTpuJoDrlyUBl6ERRq
	 jb/A7EWJrC0zFebHYRO6eCIEU5VBVYNLoNEAQoZfTHQtkpkKo5sZ92eDVAKQ3cwaeUbX+
	 B07MHKA43rQdIWEoWDPZzXknEjsXpNWwZfWJ3DtdFtYRbvRknH0zlErqegRtXotiUJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kh9FcRva;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF220606A31E;
	Fri, 27 Nov 2026 03:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kh9FcRva
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795751308;
	b=B6aXvx78L0zi4DPk0u79JIdQGMF7/o7m5rByHE0V9PSIg8oQ+5MT0HCEnImVT4iD66ll
	 B5UkNVlnNxBs33/ohOhbLXvb9yLY8j108o/pM6ppW2Of50YSsDs6NzUKxar5DcLUjQoxX
	 miIoszVq9UrSZKlrxHpfg1QmJuCLn6bQu7v2KvOBPAdYd25RP0qg+lWeKa166cjxP7XXR
	 wFlyAayfBRE5rONkyMuHoYjkxOsbYzz+qFuXwvHJ0tLopKtASQlpXXjt8vWFw3kB1/AfU
	 IhMOSWh98Uu8GN/Ll51FEh/+XukkQPfJty9FgxKRO6gfx9saSIYKZ7QWr2ZBZlXj5Ug==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795751308;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=aDFhCXRtTylWBUSnUQc8h6/Z7DEYYF2E1fptzxvnDCY=;
	b=21JPrK9gKtyZOMyo0qjMd2kodmgjyIuP+r6SIvajqbOVAhhVYY4YymNtIY1nSLBTa5HY
	 9WkrxYFWmfUrtwEbNMIY7+W0Cm2g9+GB+W+UfASLl3IQDhVPpm7HRtXXBwWo1YZvK8itP
	 D9gi46V3hSeP36t9A4nY4yMdNEISQUvoC0oP/sx0GyE+XAXPaWXz76/CQFAXq4fKsow1j
	 n7NWqPDQH4fMRgmtao8J3cb0MKzvKWSHHYUpug0A9ys/oH0zpG7AcKMX+vZztBes4/EY/
	 uCMCiE3P6jLTolcTtwShAfPi9XmTRmJagqH/uHctn5KDnO/1PvfG7MuZv61z/vJ/icg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EBFBA1F000C1;
	Fri, 27 Nov 2026 03:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795751308;
	bh=aDFhCXRtTylWBUSnUQc8h6/Z7DEYYF2E1fptzxvnDCY=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Kh9FcRvaZDj5Pg+gnLikH44wyf+wqZyJr8HrRje+wiaM159/MC1J8JE3AHb3SUIte
	 rD+tQom7BbJSEiMEmZbz9wg+PEq8PY2MIgtkRpGAdLxyfP9rATS9aBZm2d3dTpqWvb
	 z9S7gn+EklXd1CnWwy+oMz2ykxltfS0rgVd2yd/sPmbMthY7xbnBklYS+ly/waE05Q
	 JFZrDDt2ugtsboNFmu5bN501S3rJXpxMsJGGRyld/nq3g6vJVVYF8nd61j6vQFe/96
	 uFvZvr/BthIPsROSRSX1Z6KlPppUBBIpx1F0TRIPayIh9GGsnHb7QaiNMp03T3qglL
	 WOWQbF9/iqRFw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7E2D54B548;
	Fri, 27 Nov 2026 03:48:27 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Subject: [PATCH 5.15.y 0/3] sctp: validate the cached INIT in COOKIE_ECHO
Date: Fri, 27 Nov 2026 03:45:32 +0000
Message-Id: <20261127-so4-sctp-515-v1-0-bbee1a6af200@certik.com>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANz8CGsC/02NzQ7CIBCEX6XZs1sFRE1fxXjgZ2sxBhoWjabpu
 wt68ThfZr5ZgCkHYhi6BTI9A4cUaxCbDtxk4pUw+JpB7uRBCHlETntkV2bUQqNXwrkTKT16BXU
 yZxrD66s7g+6F7t9w+XF+2Bu50lytaQ0T2myimxpiir6kdMfGt/8fsK4fPAkOeaUAAAA=
X-Change-ID: 20261127-so4-sctp-515-d31cc8e35fd3
To: stable@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795751132; l=1453;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=LVWYNEdbhiClvqlIEyEc1OpRS8Vpk0qeBBMYA4BRCsQ=;
 b=GFbFeYMSQoYzOZLTavZHi+OEcIp8lZzvxTghG+D/u8O8ox1dBHi3YeFt4bWjMSoXP8FYMiRp5
 Hn4soDhOudOBn9/FRfP2sMUTr4yKmJu+3dth6T67FUu9wE8iYVjVnM0
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

6.1.y and newer already have these three fixes. 5.15.y keeps the
cached INIT in peer_init[] and tests sctp_sk()->hmac instead of
cookie_auth_enable. In the duplicate cookie path the security hook
still runs before the switch, so the A/B INIT check sits just ahead of
it and the tie-tag compare moves up a few lines.

Tested on v5.15.226:
- x86_64 allmodconfig W=1 builds of net/sctp/bind_addr.o,
  net/sctp/sm_make_chunk.o and net/sctp/sm_statefuns.o, base vs
  patched, no new warnings
- pahole on the base object to check the cookie layout
- booted the patched kernel under QEMU/KVM with SCTP built in. I
  didn't run a malformed COOKIE_ECHO test.

The backports and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

---
Xin Long (3):
      sctp: validate cached peer INIT chunk length in COOKIE_ECHO processing
      sctp: validate embedded INIT chunk and address list lengths in cookie
      sctp: add INIT verification after cookie unpacking

 net/sctp/bind_addr.c     | 11 ++++++++++-
 net/sctp/sm_make_chunk.c | 17 +++++++++++++++--
 net/sctp/sm_statefuns.c  | 46 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 62 insertions(+), 12 deletions(-)
---
base-commit: 4f2df9a01754521fbba3493e8ad91ef65515e68c
change-id: 20261127-so4-sctp-515-d31cc8e35fd3

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>


