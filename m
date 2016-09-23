From: David Miller <davem@davemloft.net>
Date: Fri, 23 Sep 2016 10:55:41 +0000
Subject: Re: [PATCH next 0/2] improvements to SSN and TSN handling
Message-Id: <20160923.065541.716099111392174272.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474405559.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1474405559.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com, David.Laight@ACULAB.COM

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 18:19:12 -0300

> First patch fixes a potential issue made visible by the second one
> noticed by David Laight and is a preparation for the next one.
> 
> The second patch changes how SSN, TSN and ASCONF serials are compared so
> they can use typecheck() and are more like time_before() macro.

Series applied, thanks.
