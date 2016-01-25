From: David Miller <davem@davemloft.net>
Date: Mon, 25 Jan 2016 06:44:03 +0000
Subject: Re: [PATCH net] sctp: allow setting SCTP_SACK_IMMEDIATELY by the application
Message-Id: <20160124.224403.165607430306052575.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <e066aaa1725a6cafb73ad270376ed2ebc953917a.1453494301.git.marcelo.leitner@gmail.com>
In-Reply-To: <e066aaa1725a6cafb73ad270376ed2ebc953917a.1453494301.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 22 Jan 2016 18:29:49 -0200

> This patch extends commit b93d6471748d ("sctp: implement the sender side
> for SACK-IMMEDIATELY extension") as it didn't white list
> SCTP_SACK_IMMEDIATELY on sctp_msghdr_parse(), causing it to be
> understood as an invalid flag and returning -EINVAL to the application.
> 
> Note that the actual handling of the flag is already there in
> sctp_datamsg_from_user().
> 
> https://tools.ietf.org/html/rfc7053#section-7
> 
> Fixes: b93d6471748d ("sctp: implement the sender side for SACK-IMMEDIATELY extension")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
