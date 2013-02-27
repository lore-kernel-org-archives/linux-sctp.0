From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 27 Feb 2013 19:36:50 +0000
Subject: Re: [PATCH v2 0/4] sctp: fix association hangs due to reassembly/ordering logic
Message-Id: <512E6052.6050301@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361889376-22171-1-git-send-email-lee.roberts@hp.com> <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
In-Reply-To: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Lee A. Roberts" <lee.roberts@hp.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 02/27/2013 07:54 PM, Lee A. Roberts wrote:
> From: "Lee A. Roberts" <lee.roberts@hp.com>
>
> This series of patches resolves several SCTP association hangs observed during
> SCTP stress testing.  Observable symptoms include communications hangs with
> data being held in the association reassembly and/or lobby (ordering) queues.
> Close examination of reassembly/ordering queues may show either duplicated
> or missing packets.

Just nitpicking here ... all of your 4 patches have the same first paragraph,
which can actually be left out completely if it is already in your patch cover
letter stated.

> Lee A. Roberts (4):
>    sctp: fix association hangs due to off-by-one errors in
>      sctp_tsnmap_grow()
>    sctp: fix association hangs due to reneging packets below the
>      cumulative TSN ACK point
>    sctp: fix association hangs due to errors when reneging events from
>      the ordering queue
>    sctp: fix association hangs due to partial delivery errors
>
>   net/sctp/tsnmap.c   |   13 ++++----
>   net/sctp/ulpqueue.c |   87 +++++++++++++++++++++++++++++++++++++++++----------
>   2 files changed, 78 insertions(+), 22 deletions(-)
