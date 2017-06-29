From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 29 Jun 2017 22:56:21 +0000
Subject: Re: [PATCH] sctp: Add peeloff-flags socket option
Message-Id: <20170629225621.GN10672@ZenIV.linux.org.uk>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170629181340.12423-1-nhorman@tuxdriver.com>
In-Reply-To: <20170629181340.12423-1-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, Andreas Steinmetz <ast@domdv.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Thu, Jun 29, 2017 at 02:13:40PM -0400, Neil Horman wrote:
> diff --git a/fs/file.c b/fs/file.c
> index 1c2972e..a4521da 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -807,6 +807,7 @@ void set_close_on_exec(unsigned int fd, int flag)
>  		__clear_close_on_exec(fd, fdt);
>  	spin_unlock(&files->file_lock);
>  }
> +EXPORT_SYMBOL(set_close_on_exec);

Huh?

> +	set_close_on_exec(peeloff->sd, !!(flags & SOCK_CLOEXEC));

Why hadn't you set it when that descriptor had been allocated?
That
        retval = get_unused_fd_flags(0);
could just pass O_CLOEXEC and you'd get it set from the very
beginning...
