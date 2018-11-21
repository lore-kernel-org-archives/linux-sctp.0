From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 21 Nov 2018 07:58:54 +0000
Subject: Re: Kernel Panic in SCTP driver (Debian 4.18.0-bpo1-amd64)
Message-Id: <CADvbK_cOvzTNz+tiSTKNyEEL4VqnEYETuSzBk-Zf0=LxOjb7BQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Nov 21, 2018 at 4:41 PM Andreas Fink <afink@list.fink.org> wrote:
>
> Hello all
>
> I have run into a kernel panic I can consistently reproduce within minutes:
>
>
> "Kernel panic - not synching: out of memory and no killable processes..."
> ...
>
> with the following stack trace:
> ..
> out of memory
> ..
> __slab_alloc
> __kmalloc:node_track_caller
> __kmalloc_reserve.isra
> __alloc
> sctp_make_datafrag_empty
> sctp_datamsg_from_user
> sctp_sendmsg_to_assoc
> sctp_epaddr_lookup_transport
> sctp_sendmsg
> sctp_sendmsg
> ___sys_sendmsg
>
>
> This is with the 4.18.0-0.bpo.1-amd64 kernel of the debian backported repository which should have a fairly new SCTP driver version.
>
> Anyone want to take a closer look at this?
>
> I have an empty VM where I start my software in userspace, wait 2 minutes and the kernel panics.
> The app's memory usage is around 2% of the system at the time of crash but its CPU load is 100% (probably some busy loop on my side which I will fix soon).
>
>
> Anyone want to take a closer look or have some insights on how to debug this?

Jakub reported a similar one:
https://www.spinics.net/lists/netdev/msg534371.html

Would you pls verify this fix in your env:

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 0a78cdf..19d596d 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1327,4 +1327,5 @@ void sctp_stream_interleave_init(struct
sctp_stream *stream)
        asoc = container_of(stream, struct sctp_association, stream);
        stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
                                       : &sctp_stream_interleave_0;
+       sctp_assoc_update_frag_point(asoc);
 }

Thanks.
