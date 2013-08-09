From: David Miller <davem@davemloft.net>
Date: Fri, 09 Aug 2013 18:33:20 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: convert sctp_checksum_disable module param into sctp sysctl
Message-Id: <20130809.113320.681399334989952629.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1375816693-7697-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1375816693-7697-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue,  6 Aug 2013 21:18:12 +0200

> Get rid of the last module parameter for SCTP and make this
> configurable via sysctl for SCTP like all the rest of SCTP's
> configuration knobs.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
