From: David Miller <davem@davemloft.net>
Date: Thu, 26 May 2016 05:14:54 +0000
Subject: Re: [PATCH net] sctp: fix double EPs display in sctp_diag
Message-Id: <20160525.221454.1093609843174055034.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <738ddd5de8d4c5fb8a99cee15de3305215e04962.1464203363.git.lucien.xin@gmail.com>
In-Reply-To: <738ddd5de8d4c5fb8a99cee15de3305215e04962.1464203363.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net, phil@nwl.cc

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 May 2016 03:09:23 +0800

> We have this situation: that EP hash table, contains only the EPs
> that are listening, while the transports one, has the opposite.
> We have to traverse both to dump all.
> 
> But when we traverse the transports one we will also get EPs that are
> in the EP hash if they are listening. In this case, the EP is dumped
> twice.
> 
> We will fix it by checking if the endpoint that is in the endpoint
> hash table contains any ep->asoc in there, as it means we will also
> find it via transport hash, and thus we can/should skip it, depending
> on the filters used, like 'ss -l'.
> 
> Still, we should NOT skip it if the user is listing only listening
> endpoints, because then we are not traversing the transport hash.
> so we have to check idiag_states there also.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
