From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sun, 24 Nov 2019 02:25:45 +0000
Subject: Re: [PATCH] sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook
Message-Id: <20191123182545.2c73268a@cakuba.netronome.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191122221759.32271-1-navid.emamdoost@gmail.com>
In-Reply-To: <20191122221759.32271-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, emamd001@umn.edu

On Fri, 22 Nov 2019 16:17:56 -0600, Navid Emamdoost wrote:
> In the implementation of sctp_sf_do_5_2_4_dupcook() the allocated
> new_asoc is leaked if security_sctp_assoc_request() fails. Release it
> via sctp_association_free().
> 
> Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied, queued for stable, thanks!
