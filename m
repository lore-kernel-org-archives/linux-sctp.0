From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 23 Jun 2017 20:39:18 +0000
Subject: Re: [PATCH v2] net/sctp/ulpevent.c: Deinline sctp_ulpevent_set_owner, save 1616 bytes
Message-Id: <20170623203918.GJ18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170621170327.4873-1-dvlasenk@redhat.com>
In-Reply-To: <20170621170327.4873-1-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Wed, Jun 21, 2017 at 07:03:27PM +0200, Denys Vlasenko wrote:
> This function compiles to 147 bytes of machine code. 13 callsites.
> 
> I'm no expert on SCTP events, but quick reading of SCTP docs tells me that
> SCTP events are not happening on every packet.
> They are ASSOC_CHANGE, PEER_ADDR_CHANGE, REMOTE_ERROR and such.
> Does not look performance critical.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: David Miller <davem@davemloft.net>
> CC: linux-sctp@vger.kernel.org
> CC: netdev@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
> Changed since v1:
> * reindented function argument list

Dave, this patch is marked as Changes Requested on patchwork, but the v2
here looks good. There was no change request on it, only on the v1, and
they were satified on v2. The only info I asked on v2 was to know he had
a bigger plan for this, not sure if that's what caused confusion or not.

Thanks,
Marcelo

