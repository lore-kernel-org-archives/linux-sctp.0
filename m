From: David Miller <davem@davemloft.net>
Date: Fri, 09 Aug 2013 20:10:08 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: convert sctp_checksum_disable module param into sctp sysctl
Message-Id: <20130809.131008.773918164482459670.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1375816693-7697-1-git-send-email-dborkman@redhat.com>
	<20130809.113320.681399334989952629.davem@davemloft.net>
	<52053A00.80808@gmail.com>
In-Reply-To: <52053A00.80808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 09 Aug 2013 14:50:40 -0400

> Please revert this.  This isn't a knob that that should be
> so freely exposed.  I thought my response to Daniel made
> that clear.

Done, sorry about that.
