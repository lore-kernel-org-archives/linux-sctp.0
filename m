From: Joe Perches <joe@perches.com>
Date: Sat, 05 Oct 2019 16:46:41 +0000
Subject: [PATCH 1/4] net: sctp: Rename fallthrough label to unhandled
Message-Id: <2e0111756153d81d77248bc8356bac78925923dc.1570292505.git.joe@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570292505.git.joe@perches.com>
In-Reply-To: <cover.1570292505.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Kan Liang <kan.liang@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Shawn Landden <shawn@git.icu>, x86@kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, clang-built-linux@googlegroups.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

fallthrough may become a pseudo reserved keyword so this only use of
fallthrough is better renamed to allow it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sctp/sm_make_chunk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e41ed2e0ae7d..48d63956a68c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2155,7 +2155,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_SET_PRIMARY:
 		if (ep->asconf_enable)
 			break;
-		goto fallthrough;
+		goto unhandled;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */
@@ -2166,11 +2166,11 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_FWD_TSN_SUPPORT:
 		if (ep->prsctp_enable)
 			break;
-		goto fallthrough;
+		goto unhandled;
 
 	case SCTP_PARAM_RANDOM:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		/* SCTP-AUTH: Secion 6.1
 		 * If the random number is not 32 byte long the association
@@ -2187,7 +2187,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_CHUNKS:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		/* SCTP-AUTH: Section 3.2
 		 * The CHUNKS parameter MUST be included once in the INIT or
@@ -2203,7 +2203,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_HMAC_ALGO:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		hmacs = (struct sctp_hmac_algo_param *)param.p;
 		n_elt = (ntohs(param.p->length) -
@@ -2226,7 +2226,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 			retval = SCTP_IERROR_ABORT;
 		}
 		break;
-fallthrough:
+unhandled:
 	default:
 		pr_debug("%s: unrecognized param:%d for chunk:%d\n",
 			 __func__, ntohs(param.p->type), cid);
-- 
2.15.0
