From: David Miller <davem@davemloft.net>
Date: Mon, 16 Jan 2017 18:52:57 +0000
Subject: Re: [PATCH net-next] sctp: remove useless code from sctp_apply_peer_addr_params
Message-Id: <20170116.135257.361979191382843875.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <99bc9f227c4c857d2bb258391231231d46c1899d.1484336556.git.marcelo.leitner@gmail.com>
In-Reply-To: <99bc9f227c4c857d2bb258391231231d46c1899d.1484336556.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 13 Jan 2017 18:31:15 -0200

> sctp_frag_point() doesn't store anything, and thus just calling it
> cannot do anything useful.
> 
> sctp_apply_peer_addr_params is only called by
> sctp_setsockopt_peer_addr_params. When operating on an asoc,
> sctp_setsockopt_peer_addr_params will call sctp_apply_peer_addr_params
> once for the asoc, and then once for each transport this asoc has,
> meaning that the frag_point will be recomputed when updating the
> transports and calling it when updating the asoc is not necessary.
> IOW, no action is needed here and we can remove this call.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied, but please put "[PATCH net-next v2]" or some other indication
in your Subject line so that new revisions of a patch are easily
discernable.

Thanks.
