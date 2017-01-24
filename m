From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Jan 2017 16:34:04 +0000
Subject: Re: [PATCH][V3][net-next] net: sctp: fix array overrun read on sctp_timer_tbl
Message-Id: <CADvbK_cqgUWBVrGvJV5anrWnJaq5QPLCyZ7LtDc-qopWYu-Z1g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170124092554.27019-1-colin.king@canonical.com>
In-Reply-To: <20170124092554.27019-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S . Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Jan 24, 2017 at 5:25 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Table sctp_timer_tbl is missing a TIMEOUT_RECONF string so
> add this in. Also compare timeout with the size of the array
> sctp_timer_tbl rather than SCTP_EVENT_TIMEOUT_MAX.  Also add
> a build time check that SCTP_EVENT_TIMEOUT_MAX is correct
> so we don't ever get this kind of mismatch between the table
> and SCTP_EVENT_TIMEOUT_MAX in the future.
>
> Kudos to Marcelo Ricardo Leitner for spotting the missing string
> and suggesting the build time sanity check.
>
> Fixes CoverityScan CID#1397639 ("Out-of-bounds read")
>
> Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
