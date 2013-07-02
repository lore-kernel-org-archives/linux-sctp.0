From: David Miller <davem@davemloft.net>
Date: Tue, 02 Jul 2013 07:24:20 +0000
Subject: Re: [PATCH net-next] net: sctp: prevent checksum.h from double inclusion
Message-Id: <20130702.002420.1956477333608952976.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372695036-10914-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1372695036-10914-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon,  1 Jul 2013 18:10:36 +0200

> The header file checksum.h is missing proper defines that prevents
> it from double inclusion.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
