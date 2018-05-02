From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 May 2018 21:57:11 +0000
Subject: Re: [PATCH V2 net-next 0/6] virtio-net:  Add SCTP checksum offload support
Message-Id: <20180502215705.GI5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
In-Reply-To: <20180502020739.19239-1-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladislav Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, Vladislav Yasevich <vyasevic@redhat.com>

On Tue, May 01, 2018 at 10:07:33PM -0400, Vladislav Yasevich wrote:
> Now that we have SCTP offload capabilities in the kernel, we can add
> them to virtio as well.  First step is SCTP checksum.

SCTP-wise, LGTM:
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
