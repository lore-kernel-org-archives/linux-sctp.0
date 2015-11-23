From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 23 Nov 2015 16:56:21 +0000
Subject: Re: [PATCH] netfilter: nf_ct_sctp: move ip_ct_sctp away from UAPI
Message-Id: <20151123165621.GA6375@salvia>
List-Id: <linux-sctp.vger.kernel.org>
References: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
In-Reply-To: <48dd716ff97dba6dbecfc095c174936888f673cd.1447274676.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Wed, Nov 11, 2015 at 08:17:37PM -0200, Marcelo Ricardo Leitner wrote:
> ip_ct_sctp is an internal structure, embedded by the union
> nf_conntrack_proto to store sctp-specific information at conntrack
> entries. It has no business with UAPI.
> 
> This patch moves it from UAPI to a saner place, together with similar
> structs for other protocols.

Applied, thanks.
