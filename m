From: David Miller <davem@davemloft.net>
Date: Thu, 13 Jun 2013 09:44:53 +0000
Subject: Re: [PATCH net-next stable v2] sctp: fully initialize sctp_outq in sctp_outq_init
Message-Id: <20130613.024453.1256276769178191648.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371061604-27312-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1371061604-27312-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, sergei.shtylyov@cogentembedded.com, vyasevich@gmail.com, netdev@vger.kernel.org


'net-next' + 'stable' is an invalid set of targets for a patch.

If the patch is appropriate for 'stable', then it had better be
appropriate for plain 'net' as well.
