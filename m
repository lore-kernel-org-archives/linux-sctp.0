From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 10 Dec 2015 12:02:33 +0000
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Message-Id: <20151210120233.GA2084@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
In-Reply-To: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz

Hi Marcelo,

On Tue, Dec 08, 2015 at 11:11:10AM -0200, Marcelo Ricardo Leitner wrote:
> Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
> support") allowed creating conntrack entries based on the heartbeat
> exchange, so that we can track secondary paths too.
> 
> This patch adds a vtag verification to that. That is, in order to allow
> a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
> vtag) must be already known.

This infrastructure that you're adding in this patch looks very
similar to me to conntrack expectations.

Did you evaluate this possibility?

The idea would be to add the vtag to the tuples since it allows us to
uniquely identify the SCTP flow. Then, if you see the hearbeat, you
can register an expectation for the tuple (any-src-ip, any-dst-ip,
sctp, specific-sport, specific-dport, specific-vtag-value).

Then, any secondary STCP flow matching that expectation in the future
will be accepted as RELATED traffic.
