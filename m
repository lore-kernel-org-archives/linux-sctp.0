From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 27 Nov 2017 13:56:31 +0000
Subject: Re: [PATCH net 0/5] sctp: a bunch of fixes for stream reconfig
Message-Id: <20171127135631.GB8850@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sat, Nov 25, 2017 at 09:05:31PM +0800, Xin Long wrote:
> This patchset is to make stream reset and asoc reset work more correctly
> for stream reconfig.
> 
> Thank to Marcelo making them very clear.
> 
> Xin Long (5):
>   sctp: use sizeof(__u16) for each stream number length instead of magic
>     number
>   sctp: only allow the out stream reset when the stream outq is empty
>   sctp: only allow the asoc reset when the asoc outq is empty
>   sctp: avoid flushing unsent queue when doing asoc reset
>   sctp: set sender next_tsn for the old result with ctsn_ack_point plus
>     1
> 
>  net/sctp/stream.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 65 insertions(+), 12 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
