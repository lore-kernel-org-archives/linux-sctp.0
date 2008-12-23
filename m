From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 23 Dec 2008 19:23:11 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <49513A9F.7010707@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> 
> At this point, I am starting to think that this is a race, but I am not sure
> what/who is racing what/who.
> 
> When I add an SCTP level setsockopt call in the accept() loop of the server, I
> get 4+ hours of normal operation (I killed the test at this point).  It doesn't
> matter what the socket option does.  As a test, I used SCTP_DISABLE_FRAGMENTS
> with a value of 0 which is essentially a no-op with locks around it, and it worked.
> 
> The few crashes I've received on 2.6.28-rc6 seem to always eminate from
> the retransmission timeout.  After poking around the crash dump, I see
> the following:
> 
> crash> sctp_transport.packet 0xffff88013dd830d8
>   packet = {
>     source_port = 10003,
>     destination_port = 36107,
>     vtag = 4043516048,
>     chunk_list = {
>       next = 0xffff88013c395e80,
>       prev = 0xffff88013c395e80
>     },
>     ...
> crash> struct sctp_chunk 0xffff88013c395e80
> struct sctp_chunk {
>   list = {
>     next = 0xffff88013c395e80,
>     prev = 0xffff88013c395e80
>   },
>   refcnt = {
>     counter = 2
>   },
>   transmitted_list = {
>     next = 0xffff88013dd83228,
>     prev = 0xffff88013dd83228
>   },
> 
> 
> Note that the transmitted_list is good (it points back to the association).
> However, the list{} in the sctp chunk points to itself, while chunk_list in
> the packet also points to it.  This results an infinite iteration over the same
> chunk while trying to copy it into the transmission skb and triggers the skb
> overflow that we BUG() with.
> 
> I am going to see if I can poison the chunk->list from the start and see who
> dies.
> 
> -vlad
> 
> p.s.  the crash I am seeing is with locks added around packet->chunk_list
> manipulations.
> 

Ok, I was able to prove that there is a race condition accessing the packet and
the chunk_list.  The way to do this is by adding a "void *last_thread" to the
sctp_chunk structure and then using the following code:

in scpt_packet_init:
	packet->last_thread = NULL;

in sctp_packet_free:
	packet->last_thread = 0xdeadbeef; /* to catch errors */

in sctp_packet_append:

	spin_lock_bh(&packet->lock);
	if (packet->last_thread && packet->last_thread != current) {
		/* print warning with interesting info. I printed the packet */
		BUG();
	}
	packet->last_thread = current;
	...
	spin_unlock_bh(&packet->lock);

in sctp_packet_reset:
	/* after the loop to free chunks */
	packet->last_thread = NULL;


In my builds with 2.6.28-rc6 + my patches, it tripped the BUG in sctp_packet_append() with two
different threads accessing the same packet structure.  Looking in crash, sure enough, one CPU was
spinning on a lock in packet_reset, while the other CPU was holding the lock while adding a chunk.

As you can tell, you need locks enabled around the chunk list handling.

I can't do much more since my company has shut down for the holidays and I'll restart in the new
year.  Meanwhile, if you still have access to equipment, you can do some looking to see if you can
figure out the race.

-vlad
