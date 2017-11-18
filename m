From: David Miller <davem@davemloft.net>
Date: Sat, 18 Nov 2017 01:35:00 +0000
Subject: Re: [PATCH net] sctp: set frag_point in sctp_setsockopt_maxseg correctly
Message-Id: <20171118.103500.1903485418923407561.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <676049ead9b85fa71b3ccf99e2bf29d0dc826cab.1510899071.git.lucien.xin@gmail.com>
In-Reply-To: <676049ead9b85fa71b3ccf99e2bf29d0dc826cab.1510899071.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com, liuhangbin@gmail.com

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Nov 2017 14:11:11 +0800

> Now in sctp_setsockopt_maxseg user_frag or frag_point can be set with
> val >= 8 and val <= SCTP_MAX_CHUNK_LEN. But both checks are incorrect.
> 
> val >= 8 means frag_point can even be less than SCTP_DEFAULT_MINSEGMENT.
> Then in sctp_datamsg_from_user(), when it's value is greater than cookie
> echo len and trying to bundle with cookie echo chunk, the first_len will
> overflow.
> 
> The worse case is when it's value is equal as cookie echo len, first_len
> becomes 0, it will go into a dead loop for fragment later on. In Hangbin
> syzkaller testing env, oom was even triggered due to consecutive memory
> allocation in that loop.
> 
> Besides, SCTP_MAX_CHUNK_LEN is the max size of the whole chunk, it should
> deduct the data header for frag_point or user_frag check.
> 
> This patch does a proper check with SCTP_DEFAULT_MINSEGMENT subtracting
> the sctphdr and datahdr, SCTP_MAX_CHUNK_LEN subtracting datahdr when
> setting frag_point via sockopt. It also improves sctp_setsockopt_maxseg
> codes.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
