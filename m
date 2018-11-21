From: Andreas Fink <afink@list.fink.org>
Date: Wed, 21 Nov 2018 07:40:09 +0000
Subject: Kernel Panic in SCTP driver  (Debian 4.18.0-bpo1-amd64)
Message-Id: <D8B116F9-0F11-4A53-B215-E31B6AC7FAED@list.fink.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello all

I have run into a kernel panic I can consistently reproduce within minutes:


"Kernel panic - not synching: out of memory and no killable processes..."
...

with the following stack trace:
..
out of memory
..
__slab_alloc 
__kmalloc:node_track_caller
__kmalloc_reserve.isra
__alloc
sctp_make_datafrag_empty
sctp_datamsg_from_user
sctp_sendmsg_to_assoc
sctp_epaddr_lookup_transport
sctp_sendmsg
sctp_sendmsg 
___sys_sendmsg


This is with the 4.18.0-0.bpo.1-amd64 kernel of the debian backported repository which should have a fairly new SCTP driver version.

Anyone want to take a closer look at this?

I have an empty VM where I start my software in userspace, wait 2 minutes and the kernel panics.
The app's memory usage is around 2% of the system at the time of crash but its CPU load is 100% (probably some busy loop on my side which I will fix soon).


Anyone want to take a closer look or have some insights on how to debug this?



Andreas Fink
