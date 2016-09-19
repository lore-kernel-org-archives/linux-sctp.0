From: David Miller <davem@davemloft.net>
Date: Mon, 19 Sep 2016 02:06:29 +0000
Subject: Re: [PATCH next] sctp: make use of WORD_TRUNC macro
Message-Id: <20160918.220629.1190601768509139321.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b40b1bd4adff2d389588d9a4710af0399ce68d1e.1473963064.git.marcelo.leitner@gmail.com>
In-Reply-To: <b40b1bd4adff2d389588d9a4710af0399ce68d1e.1473963064.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 15 Sep 2016 15:12:30 -0300

> No functional change. Just to avoid the usage of '&~3'.
> Also break the line to make it easier to read.

You're reply later in this thread:

	"to make sure it is correctly adapted to some arch if
	necessary. (even though it's not necessary in this case)"

is inconsistent with your commit log message.

If you think that the word size might possibly be different
on a given arch, then this is in fact a functional change.

This patch just adds ambiguity.  Whereas the existing code is explicit
about "multiple of 4" and there can be no confusion.

I'm not applying this, sorry.
