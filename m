From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 16 Jul 2008 13:35:47 +0000
Subject: Re: [PATCH net-next] sctp: Don't abort initialization when CONFIG_PROC_FS=n
Message-Id: <487DF933.6000505@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1215954560-31702-1-git-send-email-fw@strlen.de>
In-Reply-To: <1215954560-31702-1-git-send-email-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Westphal <fw@strlen.de>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Florian Westphal wrote:
> This puts CONFIG_PROC_FS defines around the proc init/exit functions
> and also avoids compiling proc.c if procfs is not supported.
> Also make SCTP_DBG_OBJCNT depend on procfs.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

applied.  Thanks.

-vlad
