From: David Miller <davem@davemloft.net>
Date: Sat, 11 Aug 2018 19:36:20 +0000
Subject: Re: [PATCH v3 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180811.123620.1211840066709410941.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <deb7cbdc-55b9-3ff5-8f13-cfa61e08eebe@virtuozzo.com>
        <20180810171143.21592-1-khorenko@virtuozzo.com>
In-Reply-To: <20180810171143.21592-1-khorenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: khorenko@virtuozzo.com
Cc: marcelo.leitner@gmail.com, oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, lucien.xin@gmail.com, aryabinin@virtuozzo.com

From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 10 Aug 2018 20:11:41 +0300

> Each SCTP association can have up to 65535 input and output streams.
> For each stream type an array of sctp_stream_in or sctp_stream_out
> structures is allocated using kmalloc_array() function. This function
> allocates physically contiguous memory regions, so this can lead
> to allocation of memory regions of very high order, i.e.:
> 
>   sizeof(struct sctp_stream_out) = 24,
>   ((65535 * 24) / 4096) = 383 memory pages (4096 byte per page),
>   which means 9th memory order.
> 
> This can lead to a memory allocation failures on the systems
> under a memory stress.
> 
> We actually do not need these arrays of memory to be physically
> contiguous. Possible simple solution would be to use kvmalloc()
> instread of kmalloc() as kvmalloc() can allocate physically scattered
> pages if contiguous pages are not available. But the problem
> is that the allocation can happed in a softirq context with
> GFP_ATOMIC flag set, and kvmalloc() cannot be used in this scenario.
> 
> So the other possible solution is to use flexible arrays instead of
> contiguios arrays of memory so that the memory would be allocated
> on a per-page basis.
> 
> This patchset replaces kvmalloc() with flex_array usage.
> It consists of two parts:
> 
>   * First patch is preparatory - it mechanically wraps all direct
>     access to assoc->stream.out[] and assoc->stream.in[] arrays
>     with SCTP_SO() and SCTP_SI() wrappers so that later a direct
>     array access could be easily changed to an access to a
>     flex_array (or any other possible alternative).
>   * Second patch replaces kmalloc_array() with flex_array usage.

Looks good, series applied, thanks!
