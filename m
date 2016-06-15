From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Wed, 15 Jun 2016 19:20:03 +0000
Subject: Re: [PATCH net-next] sctp: change sk state to CLOSED instead of CLOSING in sctp_sock_migrate
Message-Id: <512f798b-cabd-36b2-bee5-53157fb48254@cogentembedded.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9229f8aa0f4324831fc31b5334cde9a258404b62.1466010906.git.lucien.xin@gmail.com>
In-Reply-To: <9229f8aa0f4324831fc31b5334cde9a258404b62.1466010906.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, xiaolong.ye@intel.com, davem@davemloft.net, eric.dumazet@gmail.com

Hello.

On 06/15/2016 08:15 PM, Xin Long wrote:

> Commit d46e416c11c8 ("sctp: sctp should change socket state when
> shutdown is received") may set sk_state CLOSING in sctp_sock_migrate,
> but inet_accept doesn't allow the sk_state other than ESTABLISHED/
> CLOSED for sctp. So we will change sk_state to CLOSED, instead of
> CLOSING, as actually sk is closed already there.
>
> Fixes: commit d46e416c11c8 ("sctp: sctp should change socket state when shutdown is received")

    "Commit" not needed here, this tag has well defined form.

> Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
[...]

MBR, Sergei

