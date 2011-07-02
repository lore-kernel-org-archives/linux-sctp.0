From: David Miller <davem@davemloft.net>
Date: Sat, 02 Jul 2011 11:55:17 +0000
Subject: Re: [PATCH] sctp: fix missing send up SCTP_SENDER_DRY_EVENT when
Message-Id: <20110702.045517.375409425542144540.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4E0F6F20.5020505@gmail.com>
In-Reply-To: <4E0F6F20.5020505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyj.lk@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Michael.Tuexen@lurchi.franken.de, seggelmann@fh-muenster.de

From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Sun, 03 Jul 2011 03:18:56 +0800

> @@ -2073,10 +2073,33 @@ static int
> sctp_setsockopt_disable_fragments(struct sock *sk,

Patch corrupted by your email client.
