From: David Miller <davem@davemloft.net>
Date: Tue, 07 Feb 2017 19:11:23 +0000
Subject: Re: [PATCH net-next] sctp: drop __packed from almost all SCTP structures
Message-Id: <20170207.141123.633919678220393477.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <bb920bcd9cec538d7fe7abc548b56606f3c836a5.1486474498.git.marcelo.leitner@gmail.com>
In-Reply-To: <bb920bcd9cec538d7fe7abc548b56606f3c836a5.1486474498.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, David.Laight@ACULAB.COM

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue,  7 Feb 2017 11:37:56 -0200

> __packed is considered harmful as it potentially generates code that
> doesn't perform well and its usage should be avoided as much as
> possible.
> 
> This patch drops __packed from all SCTP structures except one, which is
> sctp_signed_cookie. In there it's required, as per changelog on
> commit 9834a2bb4970 ("[SCTP]: Fix sctp_cookie alignment in the packet.").
> 
> After this patch, no alignment changes neither in x86 or x86_64 and
> no exceptions were noticed during testing on both archs.
> 
> Code size for SCTP module also didn't change with this patch.
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Looks great, thanks so much for following through on this!

Applied.
