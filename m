From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 23 Nov 2019 13:01:13 +0000
Subject: Re: [PATCH] sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook
Message-Id: <20191123130113.GI388551@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191122221759.32271-1-navid.emamdoost@gmail.com>
In-Reply-To: <20191122221759.32271-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, emamd001@umn.edu

On Fri, Nov 22, 2019 at 04:17:56PM -0600, Navid Emamdoost wrote:
> In the implementation of sctp_sf_do_5_2_4_dupcook() the allocated
> new_asoc is leaked if security_sctp_assoc_request() fails. Release it
> via sctp_association_free().
> 
> Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
