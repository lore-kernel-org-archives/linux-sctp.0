From: David Miller <davem@davemloft.net>
Date: Wed, 02 May 2018 15:16:37 +0000
Subject: Re: [PATCH net] sctp: init active key for the new asoc in dupcook_a and dupcook_b
Message-Id: <20180502.111637.1201522056104570616.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <96c2191206cb67ccec250ca1ec66d83dc9f40c9a.1525239464.git.lucien.xin@gmail.com>
In-Reply-To: <96c2191206cb67ccec250ca1ec66d83dc9f40c9a.1525239464.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  2 May 2018 13:37:44 +0800

> When processing a duplicate cookie-echo chunk, for case 'A' and 'B',
> after sctp_process_init for the new asoc, if auth is enabled for the
> cookie-ack chunk, the active key should also be initialized.
> 
> Otherwise, the cookie-ack chunk made later can not be set with auth
> shkey properly, and a crash can even be caused by this, as after
> Commit 1b1e0bc99474 ("sctp: add refcnt support for sh_key"), sctp
> needs to hold the shkey when making control chunks.
> 
> Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
