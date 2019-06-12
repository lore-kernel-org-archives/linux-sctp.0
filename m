From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 12 Jun 2019 00:05:06 +0000
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
Message-Id: <CAADnVQKwvfuoyDEu+rB8=btOi33LdrUvk4EkQM86sDpDG61kew@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
In-Reply-To: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shyam Saini <shyam.saini@amarulasolutions.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Network Development <netdev@vger.kernel.org>, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org, mayhs11saini@gmail.com

On Tue, Jun 11, 2019 at 5:00 PM Shyam Saini
<shyam.saini@amarulasolutions.com> wrote:
>
> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
>
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h

please dont. bpf_util.h is a user space header.
Please leave it as-is.
