From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 13 Feb 2013 01:06:57 +0000
Subject: Re: SCTP Hang in reorder queue
Message-Id: <511AE731.3050009@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1360711351.1992.8726.camel@amd.troyhebe>
In-Reply-To: <1360711351.1992.8726.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/12/2013 06:22 PM, Bob Montgomery wrote:
> Below, I've copied the discussion of the reorder lobby hang caused by
> the arrival of a duplicate event tsn.  It was originally presented in
> the thread about renege bugs, but this hang is not a renege problem.
>
> Here are the conditions that cause a tsn mark to be removed from the
> tsn map while we are still holding that event in the lobby:
>
> With a base_tsn of 1000, here is the state of the map after the arrival
> of these tsns:
> 1001
> 1002
> 1003
> 1004
> 1063
> 1064
> 1129
>
>
> bobm@ned4g8:~/Examples$ testtsn <tsnfile2
> mark 1001
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1001, cum_ack: 999
>   0000000000000002
>
> mark 1002
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1002, cum_ack: 999
>   0000000000000006
>
> mark 1003
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1003, cum_ack: 999
>   000000000000000e
>
> mark 1004
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1004, cum_ack: 999
>   000000000000001e
>
> mark 1063
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1063, cum_ack: 999
>   800000000000001e
>
> ^^^^^ Bit 63 set here
>
> mark 1064
> tsnmap len: 128, base_tsn: 1000, max_tsn_seen: 1064, cum_ack: 999
>   800000000000001e 0000000000000001
>
> ^^^^^ Bit 64 causes expansion
>
> mark 1129
> tsnmap len: 256, base_tsn: 1000, max_tsn_seen: 1129, cum_ack: 999
>   800000000000001e 0000000000000000 0000000000000002 0000000000000000
>
> ^^^^^ Bit 64 disappears when bit 129 is added
>
>
> Note that after the arrival of 1064 (bit 64 in the map), the map is
> expanded to 128 and bit 64 is filled in.
>
> When 1129 arrives, the map is expanded in sctp_tsnmap_grow and the old
> part of the map is copied to the new map here:
>
>          new = kzalloc(len>>3, GFP_ATOMIC);
>          if (!new)
>                  return 0;
>
>          bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn);
>
> But the copy is for 64 bits (max_tsn_seen - base_tsn) and it should have been
> for 65 bits to pick up bit 64.  This only hurts us when max_tsn_seen is in the
> LSB.  For all other cases, the logic in bitmap_copy rounds up to the whole 64-bit
> word and gets the max_tsn_seen bit even though we didn't ask for it.
>
> When the max_tsn_seen occupies an LSB in the map, and a subsequent arrival causes
> the map to grow, the previous max_tsn_seen bit will be lost.  This leads to the
> duplicate arrival and to the hang in the reorder queue.
>
> Should be:
>          bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn + 1);

Actually, should be max_tsn_seen - cumulative_tsn_ack_point, but that's 
really the same thing as you have above.

Thanks you for the explanation Bob.  This is indeed a day 1 bug since 
the tsn re-write that happened a while ago and this is tough to hit.

The problem is that base_tsn is bit 0 while max_tsn_seen is the last 
non-zero bit.  Thus the difference between the two always results in the 
off by one copy.

Thanks
-vlad

>
> Which gives this:
>
> mark 1063
> tsnmap len: 64, base_tsn: 1000, max_tsn_seen: 1063, cum_ack: 999
>   800000000000001e
>
> mark 1064
> tsnmap len: 128, base_tsn: 1000, max_tsn_seen: 1064, cum_ack: 999
>   800000000000001e 0000000000000001
>
> mark 1129
> tsnmap len: 256, base_tsn: 1000, max_tsn_seen: 1129, cum_ack: 999
>   800000000000001e 0000000000000001 0000000000000002 0000000000000000
>
> ^^^^^ Bit 64 does not disappear
>
>
> Bob Montgomery
>
> Background material (how a duplicate tsn causes the reorder queue to
> hang):
> ===============================> The second hang does not involve the reasm queue.  It occurs on a test
> where all the events are non-fragmented.  The final state of the
> ulpq lobby is this:
>
> SSN   X
> SSN   X+1
> SSN   X+2
> SSN   X+3
> ...
> SSN   X+last
>
> And the Next expected SSN value in ssnmap is X+1.
> So we're waiting on X+1, but X is the first item in the queue.
>
> I think that is caused under these conditions:
>
> Say the lobby queue had:
>
> ssn  10
> ssn  10  (duplicate)
> ssn  11
> ssn  12
>
> and we're waiting on ssn 9...
>
> call sctp_ulpq_order with event ssn 9:
> ssn_next is incremented to 10
> call sctp_ulpq_retrieve_ordered()
> start down the list and find 10.
> ssn_next is incremented to 11.
> grab ssn 10 off the queue, add to event_list and go around.
> find 10 again and it's != new ssn_next(11), so break.
>
> Now we're hung forever.
>
> We built a module with a BUG statement on putting a duplicate
> into the lobby and hit it.
>
> The duplicate event was at the end of a group of sequential events,
> followed by a gap and then another group of sequential events.
> Coincidentally (or not), at the time the duplicate
> was sent to the lobby, it was represented by a lone bit in a
> word of the tsnmap:
>
> ...
>    ssn = 0x30d,
>    tsn = 0x5505020f,
>
>    ssn = 0x30e,     <<<<<<< About to insert this one again
>    tsn = 0x55050210,
>
> Big actual gap
>
>    ssn = 0x378,
>    tsn = 0x5505027a,
>
>    ssn = 0x379,
>    tsn = 0x5505027b,
> ...
>
> tsn_map = 0xffff8807aa430b80,
> base_tsn = 0x550501d0,
>
> crash-6.0.8bobm> p/x 0x210-0x1d1
> $8 = 0x3f
> So 63 (0x3f) + 1 = 64 bits set,
> then 106 (0x6a) - 1 = 105 bits clear,
> then 12 (0xc) + 1 = 13 bits set.
>
> crash-6.0.5bobm> rd 0xffff8807aa430b80 8
> ffff8807aa430b80:  fffffffffffffffe 0000000000000001   ................
> ffff8807aa430b90:  007ffc0000000000 0000000000000000   ................
>
> fffffffffffffffe   1 off, 63 on
> 0000000000000001   1 on , 63 off
> 007ffc0000000000   42 off,  13 on
>
> The lone bit in the second word describes tsn 0x55050210, our duplicate.
>

