Received: from mailfilter04-out30.webhostingserver.nl (mailfilter04-out30.webhostingserver.nl [195.211.73.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1574087B
	for <linux-sctp@vger.kernel.org>; Wed, 28 Feb 2024 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.211.73.156
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709143019; cv=pass; b=Ne/5O3aEXlb7u3RYkkiwtdE+9ZMCIm6RlF0TITQLNEvV1uTcT01W4JJpAr1E4gn/auswIrHehPliWsb7olP07qRZfhIzQNP9wtN8n6B6VIkQL2e6bsUeR8M1bkGgnj8UWv/l9B5ZhC0borPhMrN+E0vOli9GNwwsNo2xDeqwxX4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709143019; c=relaxed/simple;
	bh=DNtOWTC8Q72vrNJB7Cym30ezAaA0toGcvVDm1uL1xoo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=rNRVOAdj30113iZwB0iU0FGD4iO3sO8aw3PzkVd5YBOEq8+pVvKYNXPAfI2OEEJbv4oYm19Pmh7F1DrtKlBsEhDKrIDMsSV0hN6ahJGD1FQTLET6MywlScti5Y2OwNMa+XI2OCc49F5jg1TxdYjR8zxq9ER1eVLQZ3pRDmsPh6s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=broadforward.com; spf=pass smtp.mailfrom=broadforward.com; arc=pass smtp.client-ip=195.211.73.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=broadforward.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=broadforward.com
ARC-Seal: i=2; a=rsa-sha256; t=1709142945; cv=pass;
	d=webhostingserver.nl; s=whs1;
	b=FSGYJQ6n9UhQPjid8H9+dj07jRhNWVV7JZ5ZfyGj/KZCftOzHcR0sUoggZsqdyMOcGVxUw2DPHjWH
	 U6j09+ra1GBoegjX76iluKTbotDBUtDztO2FXmxjRi81JYtXRUdVOU3Octg62EZdLiJ4OIfKZX57st
	 FO5WH49Mc7uYRbesWOJZ6H9hVb+ZkRrdnXBBI4U4vZs0FTlw0DRlytuC9ihXVNh/0HNHILEOkGdPu4
	 Vvr4ZQgOpcatMgTqw/sgiLhhzy4dPHNHwneioObD4hYhx9Pb+I8Yf/ki5TEl0+s1sbdI/pLW57Y/29
	 ZBvU78Ki/oCDxGRVqhfWS3cMntf7X8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
	d=webhostingserver.nl; s=whs1;
	h=content-transfer-encoding:content-type:subject:from:to:mime-version:date:
	 message-id:from;
	bh=XRh21eDBSPDt2rCAvBrI4eLy+yumdx4oq9ZPfk+NTSM=;
	b=YYiBUFYrypaRNqrhgh3iHUohJVNzP+hiZ+k0do5RvrJwARKf8DKjDzVEfqmTEb9ENopu5FGbNYkY2
	 JeE1WcMlQ7FAXNij0gE8PIE7SoUbTZLgAhOy+3Gl769JzJXRxs9+CA9aC/XN1m7orB9JxOkFytCUv8
	 +O6o+QqQmeG7wKacnVr/5GmrSeKaFfcQI0X7ri3u/zmfN85UfHMzR9ZcFXHucFLIAh+MIO2WGhQ2ta
	 v0UzEr4ITs5DPlZ2Y0F/waLCySEHV3pJEQHLIroOUB2fARTzmRAfJE5UuhM4m2hFRYxKySfum7cNBx
	 WooQAmcj1q1z8feRp2zDcqjq6EZjjPg==
ARC-Authentication-Results: i=2; mailfilter04.webhostingserver.nl;
	spf=pass smtp.mailfrom=broadforward.com smtp.remote-ip=141.138.169.221;
	dmarc=pass header.from=broadforward.com;
	arc=pass header.oldest-pass=0;
X-Halon-ID: 98048a92-d662-11ee-b0d1-001a4a4cb95f
Received: from s221.webhostingserver.nl (s221.webhostingserver.nl [141.138.169.221])
	by mailfilter04.webhostingserver.nl (Halon) with ESMTPSA
	id 98048a92-d662-11ee-b0d1-001a4a4cb95f;
	Wed, 28 Feb 2024 18:55:44 +0100 (CET)
ARC-Seal: i=1; cv=none; a=rsa-sha256; d=webhostingserver.nl; s=whs1; t=1709142944;
	 b=weD+mhiIJ+Brj7YmiQBmBcZaCXaiwedg3/hAHRL5CsyZfMilMyvBYOK5Q8MwaXQ5M2yW676vOq
	  T/a1YAvBKX1CweMody3r9gvd0r3P7HOpRdD4RGdfrH7jT5Pt6/IKv6gsiw8FLTP6EV5GMEqSqu
	  C9pSSW62vndYapZaVTN2MwQ0Qog3fbRS5K6+hpN9Yz0qwXeeyVg0I1NgDsyeSWFvtlJxcoIqPi
	  1OGGCpaWSb+mHZ7GWHltbDBvf40r1hPgrYt4zVrNByqUUOVMmDcG1EXCkyFHQ0aMzDh3u+Suc/
	  B1mxfHYgtrnopkuGOz4r4tFOGXU+q6DZG1bJKBhkzofZXA==;
ARC-Authentication-Results: i=1; webhostingserver.nl; smtp.remote-ip=2a02:a469:25ab:1:928b:8bfc:144:24ef;
	iprev=pass (2a02-a469-25ab-1-928b-8bfc-144-24ef.fixed6.kpn.net) smtp.remote-ip=2a02:a469:25ab:1:928b:8bfc:144:24ef;
	auth=pass (PLAIN) smtp.auth=marc.frederiks@broadforward.com;
	spf=softfail smtp.mailfrom=broadforward.com;
	dmarc=skipped header.from=broadforward.com;
	arc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed; d=webhostingserver.nl; s=whs1; t=1709142944;
	bh=DNtOWTC8Q72vrNJB7Cym30ezAaA0toGcvVDm1uL1xoo=;
	h=Content-Transfer-Encoding:Content-Type:Subject:From:To:MIME-Version:Date:
	  Message-ID;
	b=FbyT+PDQSeM7bAvW8kesja/63IA4nW/FBnQsaDCUVO6Ns2TbhpYleKZsIggK9ta+MUM0vrve0Q
	  hJm53BJAVnwEKyqO4F+7Zp2hf8jfTm79/eszC7PgrWPnVjLcZeYuCATqu6Rf/IoMhpS2a8Ia0d
	  HxGLFxuK44A8jSyprFuzQp8bwjqo6k72U59gwRwAyfQ+FEYbCP8k6bud2rzZR0lw1UE5smQ3jW
	  oK+VQwqqxU3oBgK9gzaKtl9lqPGI4sJA/TLwc0wuLCpC0y6DGEg/KsieyvNkp5Yl9TFzRQogdS
	  rzLoddIK6KzgAyaluPzRxlDBEYBQ8PzzIbT/Yx03ovhJIw==;
Authentication-Results: webhostingserver.nl;
	iprev=pass (2a02-a469-25ab-1-928b-8bfc-144-24ef.fixed6.kpn.net) smtp.remote-ip=2a02:a469:25ab:1:928b:8bfc:144:24ef;
	auth=pass (PLAIN) smtp.auth=marc.frederiks@broadforward.com;
	spf=softfail smtp.mailfrom=broadforward.com;
	dmarc=skipped header.from=broadforward.com;
	arc=none
Received: from 2a02-a469-25ab-1-928b-8bfc-144-24ef.fixed6.kpn.net ([2a02:a469:25ab:1:928b:8bfc:144:24ef] helo=smtp)
	by s221.webhostingserver.nl with esmtpa (Exim 4.97.1)
	(envelope-from <marc.frederiks@broadforward.com>)
	id 1rfO9f-00000008wg4-3DtW
	for linux-sctp@vger.kernel.org;
	Wed, 28 Feb 2024 18:55:43 +0100
Message-ID: <dfd9791f-bafa-4592-b819-c805e98b5140@broadforward.com>
Date: Wed, 28 Feb 2024 18:55:42 +0100
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-sctp@vger.kernel.org
From: Marc Frederiks <marc.frederiks@broadforward.com>
Subject: Question about SCTP_UNKNOWN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus

Hi,

Sometimes we observe that the remote address state (spinfo_state in 
struct sctp_paddrinfo) of a single-homed SCTP association is set to 
SCTP_UNKNOWN (0xffff).

At that time, nothing seems wrong with the single homed association; the 
association is established and transmitting data.

Can someone explain to me what SCTP_UNKNOWN means? Is something wrong, 
we do not know about?

The only thing I could find about SCTP_UNKNOWN, is the description in 
sctp.h:

"UNKNOWN: Peer address passed by the upper layer in sendmsg or 
connect[x] calls."

Not very helpful...

B.t.w. we use Rocky Linux 8.

Regards,

Marc

