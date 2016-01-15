From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 15 Jan 2016 19:05:32 +0000
Subject: Re: [PATCH] net: sctp: Move sequence start handling into sctp_transport_get_idx()
Message-Id: <20160115190532.GH6074@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1452865471-32509-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1452865471-32509-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 15, 2016 at 02:44:31PM +0100, Geert Uytterhoeven wrote:
> net/sctp/proc.c: In function ‘sctp_transport_get_idx’:
> net/sctp/proc.c:313: warning: ‘obj’ may be used uninitialized in this function
> 
> This is currently a false positive, as all callers check for a zero
> offset first, and handle this case in the exact same way.
> 
> Move the check and handling into sctp_transport_get_idx() to kill the
> compiler warning, and avoid future bugs.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Compile-tested only.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

