From: Joe Perches <joe@perches.com>
Date: Sat, 05 Oct 2019 16:46:40 +0000
Subject: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
Message-Id: <cover.1570292505.git.joe@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-sctp@vger.kernel.org
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Kan Liang <kan.liang@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Shawn Landden <shawn@git.icu>, x86@kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, clang-built-linux@googlegroups.com, Jonathan Corbet <corbet@lwn.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-doc@vger.kernel.org, netdev@vger.kernel.org

Add 'fallthrough' pseudo-keyword to enable the removal of comments
like '/* fallthrough */'.

Add a script to convert the fallthrough comments.

The script can be run over any single file or treewide.

For instance, a treewide conversion can be done using:

$ git ls-files -- '*.[ch]' | \
  xargs scripts/cvt_style.pl -o --convert=FAllthrough

This currently produces:

$ git diff --shortstat
 1839 files changed, 4377 insertions(+), 4698 deletions(-)

Example fallthrough conversion produced by the script:

$ scripts/cvt_style.pl -o --convert=FAllthrough arch/arm/mm/alignment.c

a/arch/arm/mm/alignment.c
b/arch/arm/mm/alignment.c
@@ -695,8 +695,7 @@ thumb2arm(u16 tinstr)
 			return subset[(L<<1) | ((tinstr & (1<<8)) >> 8)] |
 			    (tinstr & 255);		/* register_list */
 		}
-		/* Else, fall through - for illegal instruction case */
-
+		fallthrough;	/* for illegal instruction case */
 	default:
 		return BAD_INSTR;
 	}
@@ -751,8 +750,7 @@ do_alignment_t32_to_handler(unsigned long *pinstr, stru=
ct pt_regs *regs,
 	case 0xe8e0:
 	case 0xe9e0:
 		poffset->un =3D (tinst2 & 0xff) << 2;
-		/* Fall through */
-
+		fallthrough;
 	case 0xe940:
 	case 0xe9c0:
 		return do_alignment_ldrdstrd;

Joe Perches (4):
  net: sctp: Rename fallthrough label to unhandled
  compiler_attributes.h: Add 'fallthrough' pseudo keyword for switch/case u=
se
  Documentation/process: Add fallthrough pseudo-keyword
  scripts/cvt_style.pl: Tool to reformat sources in various ways

 Documentation/process/coding-style.rst |   2 +-
 Documentation/process/deprecated.rst   |  33 +-
 include/linux/compiler_attributes.h    |  17 +
 net/sctp/sm_make_chunk.c               |  12 +-
 scripts/cvt_style.pl                   | 808 +++++++++++++++++++++++++++++=
++++
 5 files changed, 855 insertions(+), 17 deletions(-)
 create mode 100755 scripts/cvt_style.pl

--=20
2.15.0
