Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9BF5B67BC;
	Mon, 19 Oct 2026 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418445; cv=none; b=OdLXZW7DtyggFIPxNaXhbXikDz1vkyShciP0zoPgG2tK2e55GW6xfqC59Oe6vWTbPSgN8P+OdYXeWeGoqwMi+7GUKxWpCN9Dz9nBf4DgUIZimZEIOxsKceQw46TxMDgGiHLl+FtVe6q4cH2CIf0hduEjsSxedTaO3veS9LDoblQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418445; c=relaxed/simple;
	bh=AJlwbBz5hu9qk6tcGpKoYI14lMBX3Ih9zAw/WqN8b9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftMznlZDejBi29TghaXqIk7pKG2IVCXN8nErPYEfIUgiYyc/Uc3Ei8tsX/gp6ulYaEl3dWQZ9j7m04XcA7ghJGM81/6KLAuOYnhftl5UaflHI4XAqK5tWqnU9IvHrwlF3JQo8cGW9xt+MwsJv6ABergeNeMzHStbGaUi4AWtj1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxLnJ/ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxLnJ/ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A441F000CA;
	Mon, 19 Oct 2026 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418442;
	bh=xy3kLagWdTJP6ZfDbHny/OxnWXLKiOpy4Ok4SL2BMpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxLnJ/ej0mHR3ugRcGnN1bCZLaUIwFPQJCjO8GCcRh9jvH9mlEZ4iDvUt5meLJquk
	 5k9OFVfJ2ikRyqqKTr7G7be5wGyOHNzm7FKcfgyl58zAoGsx3FNkapyZRs8ff1tWgV
	 x/WVBJBdn/iHvO0EGLVpL34+qz1QWtEnjm2C0ZSYANpJ/rbQMz9uPNR0+RHJSDjz8W
	 V++9h4WtwvY27VrKVw36HXFa/R2vnUR7ANFzm0HW2agZ95PpibBOY6octsMuVzhiTV
	 pXlOUvWvybFnn6UVFYzUzB4UozKMSLJXYD9tt4jSzynvjOk/hRIGfoZ5CckIY+VO8B
	 6I8cDbOEWjlfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	marcelo.leitner@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] sctp: auth: propagate HMAC calculation errors to callers
Date: Mon, 19 Oct 2026 09:49:03 -0400
Message-ID: <20261019135441.1420968-252-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit 5d3ae80ecddeb82b492a2cf31ac3e44412b426f4 ]

sctp_auth_calculate_hmac() can fail when building the association secret
under memory pressure, but its void return silently leaves the HMAC digest
zeroed.  On the receive path, sctp_sf_authenticate() compares this zeroed
digest against the peer-supplied one using crypto_memneq(), potentially
accepting an all-zero HMAC from the peer if the allocation failed.  On the
send path, sctp_packet_pack() transmits a packet with a zeroed HMAC that
the peer would reject.

Improve error handling by making sctp_auth_calculate_hmac() return int:
- sctp_sf_authenticate() returns SCTP_IERROR_NOMEM instead of accepting
  a zero HMAC.
- sctp_packet_pack() drops the packet on failure instead of transmitting
  a zeroed HMAC.

Update the declaration in auth.h accordingly.

Assisted-by: LLM
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260807064314.500742-1-l1138897701@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real SCTP-AUTH fail-open under memory pressure, and the buggy
`void` HMAC helper is present in this 6.12 tree. The fix is small,
reviewer-acked, and backportable with a trivial `auth.c` context tweak.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[sctp/auth] [propagate] HMAC calculation errors to callers` —
turn `sctp_auth_calculate_hmac()` from `void` into an `int` so ENOMEM is
not swallowed.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- `Assisted-by: LLM` (author used an LLM)
- `Signed-off-by: Qing Luo <luoqing@kylinos.cn>` (author)
- `Acked-by: Xin Long <lucien.xin@gmail.com>` (SCTP maintainer)
- `Link:
  https://patch.msgid.link/20260807064314.500742-1-l1138897701@163.com`
- `Signed-off-by: Paolo Abeni <pabeni@redhat.com>` (netdev)
- No `Reported-by`, `Tested-by`, `Reviewed-by` on the committed message
- No `Fixes:` / `Cc: stable` on the committed v4 text (expected for this
  review queue; see Phase 4 — they were present on v2/v3, and Xin Long
  re-added `Fixes:` when acking v4)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `sctp_auth_calculate_hmac()` can fail while building the
  association secret; it still returns void and leaves the HMAC field
  zeroed.
- Receive symptom: `sctp_sf_authenticate()` compares that zero digest to
  the peer HMAC with `crypto_memneq()`, so an all-zero HMAC can be
  accepted.
- Send symptom: `sctp_packet_pack()` ships a packet with a zero HMAC,
  which the peer rejects.
- Root cause: silent early return on `sctp_auth_asoc_create_secret()`
  failure.
- No kernel-version range in the message.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit error-propagation fix
for a fail-open AUTH path. v1 understated it as “wrong error code
(BAD_SIG vs NOMEM)”; later revisions correctly describe acceptance of a
zero HMAC.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `include/net/sctp/auth.h`: `void` → `int` for
  `sctp_auth_calculate_hmac()`
- `net/sctp/auth.c`: return `-ENOMEM` on secret allocation failure;
  `return 0` on success
- `net/sctp/output.c`: drop packed skb on HMAC failure; treat `pkt_count
  <= 0` as transmit failure
- `net/sctp/sm_statefuns.c`: on HMAC failure, `kfree(save_digest)` and
  return `SCTP_IERROR_NOMEM`
- Scope: ~24 insertions / 13 deletions, four files, surgical, SCTP-only
- Functions: `sctp_auth_calculate_hmac`, `sctp_packet_pack`,
  `sctp_packet_transmit`, `sctp_sf_authenticate`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- HMAC helper: allocation failure used to `return;` with digest
  untouched → now `-ENOMEM`.
- Receive: digest is `memset` to 0, then HMAC is computed into it. On
  failure, compare is skipped; NOMEM is returned instead of comparing
  against zeros.
- Send: HMAC failure frees `packet->auth`, frees the GSO fragment if
  needed, returns `-ENOMEM`. Non-GSO `nskb == head`, so `nskb` is not
  freed there (avoids double-free); `sctp_packet_transmit` frees `head`
  when `pkt_count <= 0`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / correctness with security impact (AUTH fail-open),
  plus missing error-path handling.
- Mechanism: RFC 4895 requires the AUTH HMAC field to be zero during
  computation. The receive path zeros it, then writes the computed MAC.
  If computation is skipped, the field stays zero, so
  `crypto_memneq(peer_hmac, zeros)` succeeds when the peer sent zeros.
- Trigger: `key_id != asoc->active_key_id` (non-active configured shared
  key) plus `sctp_auth_asoc_create_secret()` GFP_ATOMIC failure.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: callers already have NOMEM handling
  (`sctp_sf_eat_auth` → `SCTP_DISPOSITION_NOMEM`; transmit already drops
  on pack failure).
- Minimal: no API for userspace, no new features.
- Regression risk: low. Send path drops the packet instead of emitting a
  MAC the peer would reject. Receive path no longer accept-on-OOM.
- Residual in this tree: `crypto_shash_setkey()` failure still `goto
  free` without an error (mainline HMAC helpers no longer have that
  path). That is preexisting and outside this commit.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Silent `return` on failed `sctp_auth_asoc_create_secret()` is
from `1f485649f52929` (“[SCTP]: Implement SCTP-AUTH internals”, Vlad
Yasevich, 2007-10-09), first in `v2.6.24-rc1`. Present for the entire
life of SCTP-AUTH.

Step 3.2: FOLLOW THE FIXES: TAG
Record: Committed v4 has no `Fixes:` line. Xin Long added `Fixes:
1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")` on ack. That
commit **is** an ancestor of this tree (`git merge-base --is-ancestor
1f485649f52929 HEAD` succeeded). Mainline fix `5d3ae80ecdde` is **not**
in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent SCTP work here is unrelated (INIT leaks, ASCONF, TOCTOU,
STALE_COOKIE). No prior attempt to propagate HMAC errors.
`hmac_sha1_usingrawkey` is **not** in this tree; this tree still uses
`crypto_shash`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Qing Luo is not the SCTP maintainer. Xin Long **is** (recent
`net/sctp` commits, and he acked this). That ack is the quality signal.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No functional prerequisite. Mainline `auth.c` later switched to
`hmac_sha*_usingrawkey`; this tree still has `crypto_shash`. The error-
return change does not need that conversion. Standalone after a small
context adapt in `auth.c`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 5d3ae80ecdde` →
  https://patch.msgid.link/20260807064314.500742-1-l1138897701@163.com
- Series: v1 net-next (2026-07-30), v2 net (2026-08-04), v3 net
  (2026-08-04), v4 net-next (2026-08-07, applied)
- v1 changelog only mentioned BAD_SIG vs NOMEM.
- Jakub Kicinski forwarded an AI review he treated as valid: the real
  bug is **accepting an all-zero HMAC**, reachable from the wire via a
  configured non-active key id, including delayed COOKIE-ECHO AUTH;
  asked for `Fixes:` and `Cc: stable`.
- v2/v3 retargeted to `net`, added security wording, `Fixes:`, `Cc:
  stable`, and a `sctp_auth_chunk_verify()` refactor.
- Xin Long on v3: “This patch is intended as a **fix**”; drop the
  `sctp_auth_chunk_verify()` churn (send that kind of cleanup to net-
  next). Returning `-ENOMEM` from pack is fine because transmit already
  treats non-positive pack results as drop.
- v4 dropped the verify refactor and was sent to net-next; Xin Long
  acked and re-added `Fixes:`. Paolo applied it to net-next
  (`5d3ae80ecdde`).
- No NAKs. Applied version is v4 (latest).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): netdev maintainers (davem, edumazet, kuba, pabeni,
horms), `linux-sctp@`, `lucien.xin@gmail.com`. Xin Long acked. Jakub’s
review drove the security description.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla/user crash report. Bug was found by code
review (LLM-assisted, then confirmed on the list). Unverified: whether
any production user has hit the zero-HMAC accept path.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single patch, not 2/N. v3’s `sctp_auth_chunk_verify()` NOMEM vs
BAD_SIG split was deliberately **not** merged. Without it, delayed
COOKIE-ECHO treats HMAC-calc ENOMEM as auth failure
(`sctp_auth_chunk_verify` still returns bool / false) and discards —
fail-closed, which is the safe direction.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. From the netdev
thread, v2/v3 carried `Cc: stable`; v4 dropped it only because the
author retargeted after Xin Long asked to strip the verify refactor.
Unverified: no separate stable@ thread found.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `sctp_auth_calculate_hmac`, `sctp_packet_pack`,
`sctp_packet_transmit`, `sctp_sf_authenticate`. (semcode MCP not
available; used grep + reads.)

Step 5.2: TRACE CALLERS
Record: `sctp_auth_calculate_hmac` has exactly two call sites in this
tree:
- `sctp_sf_authenticate()` — receive AUTH, GFP_ATOMIC, reachable from
  the wire
- `sctp_packet_pack()` — transmit path
`sctp_sf_authenticate` is used by `sctp_sf_eat_auth` and by
`sctp_auth_chunk_verify` (delayed COOKIE-ECHO). Softirq/packet receive
context.

Step 5.3: TRACE CALLEES
Record: `sctp_auth_asoc_create_secret()` allocates key vectors
(`sctp_auth_make_local_vector` / `peer_vector` /
`sctp_auth_asoc_set_secret`) with the caller’s `gfp`. Receive uses
`GFP_ATOMIC`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace/peer can trigger this: enable SCTP AUTH
(`net.sctp.auth_enable` is **0 by default**, but applications/sysctl can
turn it on; ADD-IP needs AUTH), configure more than one shared key, send
AUTH with a non-active key id and an all-zero HMAC while the host is
under atomic-allocation pressure. Reachable from the network, not a
local-only path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: No other `sctp_auth_calculate_hmac` copies. Same fail-open
exists on both send and receive via the single helper.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Tree is `pending-6.12` / `6.12.111`
(`p-6.12-3-gc504cf0baa3d8`).
```707:731:net/sctp/auth.c
void sctp_auth_calculate_hmac(...)
{
        ...
                asoc_key = sctp_auth_asoc_create_secret(asoc, ep_key,
gfp);
                if (!asoc_key)
                        return;
```
Receive still zeros the digest then compares unconditionally
(`net/sctp/sm_statefuns.c` ~4426–4433). Bug introduced in v2.6.24, long
before 6.12.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Mainline `auth.c` uses `hmac_sha1_usingrawkey` /
`hmac_sha256_usingrawkey`; this tree uses `crypto_shash_setkey` +
`crypto_shash_tfm_digest`. Exact mainline hunk context in `auth.c` will
not match. The signature change, `-ENOMEM` return, `return 0`, and both
caller sites match this tree. An adapted patch (`void`→`int`, `return
-ENOMEM`, `return 0` after the existing `free:` label, plus the
output/statefuns hunks) applies (`git apply --check` succeeded on that
adaptation). Difficulty: **minor conflicts / trivial rework**, not a
rewrite.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `git merge-base --is-ancestor 5d3ae80ecdde HEAD` failed. No
“propagate HMAC” commit. `sctp_auth_calculate_hmac` is still `void`. No
substitute fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `net/sctp` — IMPORTANT (transport protocol; not mm/core). AUTH
is optional but is the integrity mechanism for SCTP-AUTH / ADD-IP.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (Xin Long and others still landing SCTP
fixes on this branch). Mature protocol; this bug is old, not a new-
subsystem artifact.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Config/protocol-specific: `CONFIG_IP_SCTP` plus AUTH enabled
(`net->sctp.auth_enable` defaults to 0 in `net/sctp/protocol.c`). Users
who enable AUTH (telecom, WebRTC data-channel stacks, ADD-IP) are the
population that matters.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- AUTH enabled and a non-active shared key configured
- Peer uses that key id
- `sctp_auth_asoc_create_secret()` fails (`GFP_ATOMIC` on receive)
- Peer HMAC is all zeros
Allocation failure is not attacker-controlled; key id and zero HMAC are.
Unprivileged remote peer on an AUTH-enabled association can attempt
this. Commonness: uncommon; severity if it hits: high.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Receive: AUTH bypass (`chunk->auth = 1`) for chunks that should have
  been rejected — **HIGH** (security / integrity). Not a panic, but
  fail-open authentication.
- Send: packet with zero HMAC dropped by peer — **LOW/MEDIUM** (failed
  send under OOM; already broken).
Overall: **HIGH** because of the receive fail-open.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for AUTH users — stops accepting unauthenticated chunks
  under OOM.
- Risk: very low — ~20 lines, error paths only, existing NOMEM/drop
  handling.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real AUTH fail-open: zeroed digest compared to peer HMAC after silent
  HMAC-calc failure (verified in `sctp_sf_authenticate`).
- Present in this 6.12 tree since `1f485649f529` (v2.6.24).
- Small, obviously correct; NOMEM already handled on the eat-AUTH path.
- SCTP maintainer acked it as a fix and supplied `Fixes:`.
- Jakub’s review explicitly called for stable.
- Two call sites only; no new APIs.

AGAINST:
- AUTH off by default; needs extra keys + atomic ENOMEM + zero HMAC.
- No syzbot/user crash report.
- Merged via net-next as v4 without `Cc: stable` in the commit text.
- Exact mainline `auth.c` context differs (`crypto_shash` vs
  `hmac_sha*`).
- Delayed COOKIE-ECHO still maps NOMEM to “auth failed” (fail-closed;
  acceptable, and what was merged).

UNRESOLVED:
- No stable@ archive confirmation (lore 403).
- No evidence of a real-world exploit/report.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is local; acked by Xin
   Long; applied to net-next.
2. Fixes a real bug that affects users? **PASS** — fail-open AUTH on a
   wire-reachable path when AUTH is enabled.
3. Important issue? **PASS** — authentication bypass / integrity failure
   (HIGH), not a crash. Narrow trigger, but security-class.
4. Small and contained? **PASS** — four files, ~24 lines, one helper +
   two callers.
5. No new features or APIs? **PASS** — return type only, internal.
6. Can apply to the local tree? **PASS** — buggy code is here; caller
   hunks match; `auth.c` needs a 3-line adapt around `crypto_shash` (not
   a missing subsystem).

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/doc exception). It
qualifies as a normal security/correctness fix.

Step 9.4: MAKE YOUR DECISION
Backport to this 6.12 tree. The bug exists here, the fix is surgical,
and leaving AUTH fail-open under OOM is worse than dropping the packet /
returning NOMEM.

Verification:
- [Phase 1] Tags parsed from the provided message and from the lore
  mbox: Acked-by Xin Long; no Fixes on v4 commit text; v2/v3 had Fixes +
  Cc: stable
- [Phase 2] Diff: void→int, -ENOMEM on secret alloc, receive NOMEM +
  kfree(save_digest), send drop + `pkt_count <= 0`
- [Phase 2] Confirmed receive zeros digest then `crypto_memneq` in
  `sm_statefuns.c` 4426–4433
- [Phase 3] `git blame net/sctp/auth.c`: silent return from
  `1f485649f52929` (2007); `git describe --contains` → v2.6.24-rc1
- [Phase 3] `git merge-base --is-ancestor 1f485649f52929 HEAD`
  succeeded; `5d3ae80ecdde` is not an ancestor
- [Phase 3] `hmac_sha1_usingrawkey` absent in this tree; HMAC still via
  `crypto_shash`
- [Phase 4] `b4 dig -c 5d3ae80ecdde`: v1–v4; Jakub review identified
  zero-HMAC accept and asked for stable; Xin Long: “intended as a fix”,
  drop verify refactor; acked v4 with Fixes
- [Phase 4] lore.kernel.org/stable WebFetch 403 — UNVERIFIED whether
  stable@ discussed it separately
- [Phase 5] grep: only two `sctp_auth_calculate_hmac` call sites;
  `sctp_sf_eat_auth` already handles `SCTP_IERROR_NOMEM`
- [Phase 5] `net->sctp.auth_enable = 0` by default (`protocol.c:1382`)
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] Adapted patch `git apply --check` succeeded; exact mainline
  `auth.c` context would conflict
- [Phase 8] Failure mode: AUTH bypass under ENOMEM + zero HMAC + non-
  active key — HIGH; send of zero HMAC — LOW
- UNVERIFIED: real-world exploitation; whether `crypto_shash_setkey`
  failure is practically reachable for HMAC-SHA1/256 (not required for
  this verdict)

**YES**

 include/net/sctp/auth.h |  6 +++---
 net/sctp/auth.c         | 10 ++++++----
 net/sctp/output.c       | 12 +++++++++---
 net/sctp/sm_statefuns.c |  9 ++++++---
 4 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 3d5879e08e78a..27a098411e4cc 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -84,9 +84,9 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
 		       const struct sctp_association *asoc);
 int sctp_auth_recv_cid(enum sctp_cid chunk,
 		       const struct sctp_association *asoc);
-void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
-			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
-			      struct sctp_shared_key *ep_key, gfp_t gfp);
+int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
+			     struct sk_buff *skb, struct sctp_auth_chunk *auth,
+			     struct sctp_shared_key *ep_key, gfp_t gfp);
 void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
 void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
 
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index fbbfa0c279552..6971cb00f5e30 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -613,9 +613,9 @@ int sctp_auth_recv_cid(enum sctp_cid chunk, const struct sctp_association *asoc)
  *    zero (as shown in Figure 6) followed by all chunks that are placed
  *    after the AUTH chunk in the SCTP packet.
  */
-void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
-			      struct sk_buff *skb, struct sctp_auth_chunk *auth,
-			      struct sctp_shared_key *ep_key, gfp_t gfp)
+int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
+			     struct sk_buff *skb, struct sctp_auth_chunk *auth,
+			     struct sctp_shared_key *ep_key, gfp_t gfp)
 {
 	struct sctp_auth_bytes *asoc_key;
 	__u16 key_id, hmac_id;
@@ -636,7 +636,7 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 		/* ep_key can't be NULL here */
 		asoc_key = sctp_auth_asoc_create_secret(asoc, ep_key, gfp);
 		if (!asoc_key)
-			return;
+			return -ENOMEM;
 
 		free_key = 1;
 	}
@@ -654,6 +654,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 
 	if (free_key)
 		sctp_auth_key_put(asoc_key);
+
+	return 0;
 }
 
 /* API Helpers */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 23e96305cad7c..3d7ead9d40e19 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -517,8 +517,14 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 		}
 
 		if (auth) {
-			sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
-						 packet->auth->shkey, gfp);
+			if (sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
+						     packet->auth->shkey, gfp)) {
+				sctp_chunk_free(packet->auth);
+				packet->auth = NULL;
+				if (gso)
+					kfree_skb(nskb);
+				return -ENOMEM;
+			}
 			/* free auth if no more chunks, or add it back */
 			if (list_empty(&packet->chunk_list))
 				sctp_chunk_free(packet->auth);
@@ -619,7 +625,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
-	if (!pkt_count) {
+	if (pkt_count <= 0) {
 		kfree_skb(head);
 		goto out;
 	}
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 86f26b8b39934..8dc65498763cc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4457,9 +4457,12 @@ static enum sctp_ierror sctp_sf_authenticate(
 
 	memset(digest, 0, sig_len);
 
-	sctp_auth_calculate_hmac(asoc, chunk->skb,
-				 (struct sctp_auth_chunk *)chunk->chunk_hdr,
-				 sh_key, GFP_ATOMIC);
+	if (sctp_auth_calculate_hmac(asoc, chunk->skb,
+				     (struct sctp_auth_chunk *)chunk->chunk_hdr,
+				     sh_key, GFP_ATOMIC)) {
+		kfree(save_digest);
+		return SCTP_IERROR_NOMEM;
+	}
 
 	/* Discard the packet if the digests do not match */
 	if (crypto_memneq(save_digest, digest, sig_len)) {
-- 
2.53.0

