From: David Miller <davem@davemloft.net>
Date: Wed, 13 Feb 2013 18:42:45 +0000
Subject: Re: [PATCH net] net: sctp: sctp_v6_get_dst: fix boolean test in dst cache
Message-Id: <20130213.134245.1682004516494856058.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360709645.git.dborkman@redhat.com>
	<4a07201201d7bac08468d17dea3dbc1ea9a67205.1360709645.git.dborkman@redhat.com>
In-Reply-To: <4a07201201d7bac08468d17dea3dbc1ea9a67205.1360709645.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 13 Feb 2013 00:30:16 +0100

> We walk through the bind address list and try to get the best source
> address for a given destination. However, currently, we take the
> 'continue' path of the loop when an entry is invalid (!laddr->valid)
> *and* the entry state does not equal SCTP_ADDR_SRC (laddr->state !> SCTP_ADDR_SRC).
> 
> Thus, still, invalid entries with SCTP_ADDR_SRC might not 'continue'
> as well as valid entries with SCTP_ADDR_{NEW, SRC, DEL}, with a possible
> false baddr and matchlen as a result, causing in worst case dst route
> to be false or possibly NULL.
> 
> This test should actually be a '||' instead of '&&'. But lets fix it
> and make this a bit easier to read by having the condition the same way
> as similarly done in sctp_v4_get_dst.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
