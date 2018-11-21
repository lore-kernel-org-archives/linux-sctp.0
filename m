From: Andreas Fink <afink@list.fink.org>
Date: Wed, 21 Nov 2018 08:46:35 +0000
Subject: Re: Kernel Panic in SCTP driver (Debian 4.18.0-bpo1-amd64)
Message-Id: <6AD8C517-AD1E-48C4-BCC7-82A5501CC35F@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_cOvzTNz+tiSTKNyEEL4VqnEYETuSzBk-Zf0=LxOjb7BQ@mail.gmail.com>
In-Reply-To: <CADvbK_cOvzTNz+tiSTKNyEEL4VqnEYETuSzBk-Zf0=LxOjb7BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



> On 21 Nov 2018, at 08:58, Xin Long <lucien.xin@gmail.com> wrote:
> 
> On Wed, Nov 21, 2018 at 4:41 PM Andreas Fink <afink@list.fink.org> wrote:
>> 
>> Hello all
>> 
>> I have run into a kernel panic I can consistently reproduce within minutes:
>> 
>> 
>> "Kernel panic - not synching: out of memory and no killable processes..."
>> ...
>> 
>> with the following stack trace:
>> ..
>> out of memory
>> ..
>> __slab_alloc
>> __kmalloc:node_track_caller
>> __kmalloc_reserve.isra
>> __alloc
>> sctp_make_datafrag_empty
>> sctp_datamsg_from_user
>> sctp_sendmsg_to_assoc
>> sctp_epaddr_lookup_transport
>> sctp_sendmsg
>> sctp_sendmsg
>> ___sys_sendmsg
>> 
>> 
>> This is with the 4.18.0-0.bpo.1-amd64 kernel of the debian backported repository which should have a fairly new SCTP driver version.
>> 
>> Anyone want to take a closer look at this?
>> 
>> I have an empty VM where I start my software in userspace, wait 2 minutes and the kernel panics.
>> The app's memory usage is around 2% of the system at the time of crash but its CPU load is 100% (probably some busy loop on my side which I will fix soon).
>> 
>> 
>> Anyone want to take a closer look or have some insights on how to debug this?
> 
> Jakub reported a similar one:
> https://www.spinics.net/lists/netdev/msg534371.html
> 
> Would you pls verify this fix in your env:
> 
> diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
> index 0a78cdf..19d596d 100644
> --- a/net/sctp/stream_interleave.c
> +++ b/net/sctp/stream_interleave.c
> @@ -1327,4 +1327,5 @@ void sctp_stream_interleave_init(struct
> sctp_stream *stream)
>        asoc = container_of(stream, struct sctp_association, stream);
>        stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
>                                       : &sctp_stream_interleave_0;
> +       sctp_assoc_update_frag_point(asoc);
> }
> 
> Thanks.


Spot on.

My code does in fact set the path MTU to a fixed value to be able to talk to a Ericsson AXE10 which doesn't do PathMTU discovery correctly and causes problems if too big MTU's arrive (because the IP path works for it) but its internal MTU figure is configured smaller.

When I disable the MTU setting and use path discovery, the problem is gone.
I can't implement that patch as I use prebuilt SCTP driver binaries, but I can work around it with that info.

Thanks a lot


Andreas
