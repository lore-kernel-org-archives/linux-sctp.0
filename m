From: Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 04 Nov 2019 10:57:22 +0000
Subject: Re: [PATCH linux-4.14.y 0/2] sctp: fix a memory leak
Message-Id: <20191104105722.GA1945210@kroah.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1572844054.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1572844054.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: stable@vger.kernel.org, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org

On Mon, Nov 04, 2019 at 01:16:24PM +0800, Xin Long wrote:
> These 2 patches are missed in linux-4.14.y, it will cause crash
> when commit 63dfb7938b13 ("sctp: change sctp_prot .no_autobind
> with true") is backported only.
> 
> Conflicts:
>   - Context difference in Patch 1/2 due to the lack of
>     Commit c981f254cc82.
> 
> Xin Long (2):
>   sctp: fix the issue that flags are ignored when using kernel_connect
>   sctp: not bind the socket in sctp_connect

Thanks for these, now queued up.

greg k-h
