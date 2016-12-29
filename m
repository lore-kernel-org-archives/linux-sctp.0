From: David Miller <davem@davemloft.net>
Date: Thu, 29 Dec 2016 19:44:14 +0000
Subject: Re: [PATCH net-next] sctp: refactor sctp_datamsg_from_user
Message-Id: <20161229.144414.88701034057801749.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ba007bd30f61decbdae5c23541cbdb397c030b68.1483033905.git.marcelo.leitner@gmail.com>
In-Reply-To: <ba007bd30f61decbdae5c23541cbdb397c030b68.1483033905.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 29 Dec 2016 15:53:28 -0200

> This patch refactors sctp_datamsg_from_user() in an attempt to make it
> better to read and avoid code duplication for handling the last
> fragment.
> 
> It also avoids doing division and remaining operations. Even though, it
> should still operate similarly as before this patch.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
