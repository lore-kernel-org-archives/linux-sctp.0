From: David Miller <davem@davemloft.net>
Date: Mon, 03 Apr 2017 21:53:01 +0000
Subject: Re: [PATCHv2 net-next] sctp: add SCTP_PR_STREAM_STATUS sockopt for prsctp
Message-Id: <20170403.145301.1291800992412083707.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0618a2ca7e92ebdfc0953c38da2f727b8b270090.1491037666.git.lucien.xin@gmail.com>
In-Reply-To: <0618a2ca7e92ebdfc0953c38da2f727b8b270090.1491037666.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  1 Apr 2017 17:07:46 +0800

> Before when implementing sctp prsctp, SCTP_PR_STREAM_STATUS wasn't
> added, as it needs to save abandoned_(un)sent for every stream.
> 
> After sctp stream reconf is added in sctp, assoc has structure
> sctp_stream_out to save per stream info.
> 
> This patch is to add SCTP_PR_STREAM_STATUS by putting the prsctp
> per stream statistics into sctp_stream_out.
> 
> v1->v2:
>   fix an indent issue.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
