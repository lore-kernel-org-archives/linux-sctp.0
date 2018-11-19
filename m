From: David Miller <davem@davemloft.net>
Date: Mon, 19 Nov 2018 20:42:13 +0000
Subject: Re: [PATCHv2 net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <20181119.124213.78418049979979609.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <44569c3eada8633c11f17c63e2d5ea9f3936f59c.1542525713.git.lucien.xin@gmail.com>
In-Reply-To: <44569c3eada8633c11f17c63e2d5ea9f3936f59c.1542525713.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 15:21:53 +0800

> As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:
> 
>    This socket option allows the enabling or disabling of the
>    negotiation of PR-SCTP support for future associations.  For existing
>    associations, it allows one to query whether or not PR-SCTP support
>    was negotiated on a particular association.
> 
> It means only sctp sock's prsctp_enable can be set.
> 
> Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
> add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
> sctp in another patchset.
> 
> v1->v2:
>   - drop the params.assoc_id check as Neil suggested.
> 
> Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
