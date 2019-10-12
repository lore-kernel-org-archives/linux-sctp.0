From: Joe Perches <joe@perches.com>
Date: Sat, 12 Oct 2019 02:14:33 +0000
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
Message-Id: <01e7fa29d34f210348355c4a507a714e086e7a30.camel@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570292505.git.joe@perches.com>
         <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
         <9fe980f7e28242c2835ffae34914c5f68e8268a7.camel@perches.com>
         <CAHk-=wi1T1m-su8zK5LeESoz_Pgf1-4hnjr516NiDLNyb4USug@mail.gmail.com>
In-Reply-To: <CAHk-=wi1T1m-su8zK5LeESoz_Pgf1-4hnjr516NiDLNyb4USug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sctp@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Kan Liang <kan.liang@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Shawn Landden <shawn@git.icu>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, clang-built-linux <clang-built-linux@googlegroups.com>, Jonathan Corbet <corbet@lwn.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Netdev <netdev@vger.kernel.org>

On Fri, 2019-10-11 at 10:46 -0700, Linus Torvalds wrote:
> On Fri, Oct 11, 2019 at 10:43 AM Joe Perches <joe@perches.com> wrote:
> > Shouldn't a conversion script be public somewhere?
> 
> I feel the ones that might want to do the conversion on their own are
> the ones that don't necessarily trust the script.
> 
> But I don't even know if anybody does want to, I just feel it's an option.

What's the harm in keeping the script in the
tree until it's no longer needed?
