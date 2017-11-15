From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Nov 2017 15:35:58 +0000
Subject: Re: [PATCHv2 net] sctp: check stream reset info len before making reconf chunk
Message-Id: <20171115153558.GD10083@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <49f43731ffc66c5da5eb3ee3e365d12a0e1fe8cb.1510736411.git.lucien.xin@gmail.com>
In-Reply-To: <49f43731ffc66c5da5eb3ee3e365d12a0e1fe8cb.1510736411.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, syzkaller@googlegroups.com

On Wed, Nov 15, 2017 at 05:00:11PM +0800, Xin Long wrote:
> Now when resetting stream, if both in and out flags are set, the info
> len can reach:
>   sizeof(struct sctp_strreset_outreq) + SCTP_MAX_STREAM(65535) +
>   sizeof(struct sctp_strreset_inreq)  + SCTP_MAX_STREAM(65535)
> even without duplicated stream no, this value is far greater than the
> chunk's max size.
> 
> _sctp_make_chunk doesn't do any check for this, which would cause the
> skb it allocs is huge, syzbot even reported a crash due to this.
> 
> This patch is to check stream reset info len before making reconf
> chunk and return EINVAL if the len exceeds chunk's capacity.
> 
> Thanks Marcelo and Neil for making this clear.
> 
> v1->v2:
>   - move the check into sctp_send_reset_streams instead.
> 
> Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

