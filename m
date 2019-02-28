From: David Miller <davem@davemloft.net>
Date: Thu, 28 Feb 2019 18:34:12 +0000
Subject: Re: [PATCH] sctp: chunk.c: correct format string for size_t in printk
Message-Id: <20190228.103412.1079788847751298444.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190228113652.55552-1-maennich@google.com>
In-Reply-To: <20190228113652.55552-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: maennich@google.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthias Maennich <maennich@google.com>
Date: Thu, 28 Feb 2019 11:36:52 +0000

> According to Documentation/core-api/printk-formats.rst, size_t should be
> printed with %zu, rather than %Zu.
> 
> In addition, using %Zu triggers a warning on clang (-Wformat-extra-args):
> 
> net/sctp/chunk.c:196:25: warning: data argument not used by format string [-Wformat-extra-args]
>                                     __func__, asoc, max_data);
>                                     ~~~~~~~~~~~~~~~~^~~~~~~~~
> ./include/linux/printk.h:440:49: note: expanded from macro 'pr_warn_ratelimited'
>         printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
> ./include/linux/printk.h:424:17: note: expanded from macro 'printk_ratelimited'
>                 printk(fmt, ##__VA_ARGS__);                             \
>                        ~~~    ^
> 
> Fixes: 5b5e0928f742 ("lib/vsprintf.c: remove %Z support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Matthias Maennich <maennich@google.com>

Applied, thanks.
