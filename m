From: David Miller <davem@davemloft.net>
Date: Wed, 15 Jul 2015 20:59:18 +0000
Subject: Re: [PATCH v2 0/2] Avoid link dependency of dlm on sctp module
Message-Id: <20150715.135918.1121936842089030351.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1436891629.git.marcelo.leitner@gmail.com>
	<20150715135714.GB24091@hmsreliant.think-freely.org>
In-Reply-To: <20150715135714.GB24091@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: marcelo.leitner@gmail.com, netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Jul 2015 09:57:14 -0400

> Series
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

I don't like this at all.

I know it's a pain in the ass to have this dependency on SCTP, but
calling exported functions is absolutely the right way to handle
this kind of situation.
