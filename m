From: David Miller <davem@davemloft.net>
Date: Wed, 03 Jul 2019 18:41:41 +0000
Subject: Re: [PATCH net] sctp: count data bundling sack chunk for outctrlchunks
Message-Id: <20190703.114141.21086700743761959.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
In-Reply-To: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  3 Jul 2019 18:20:20 +0800

> Now all ctrl chunks are counted for asoc stats.octrlchunks and net
> SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
> than the chunk maked and bundled in sctp_packet_bundle_sack, which
> caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.
> 
> This issue exists since very beginning, here to fix it by increasing
> both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
> chunk is maked and bundled in sctp_packet_bundle_sack.
> 
> Reported-by: Ja Ram Jeon <jajeon@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
