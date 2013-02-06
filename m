From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 06 Feb 2013 15:58:07 +0000
Subject: Re: Suspected renege problem in sctp
Message-Id: <51127D8F.9050709@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5109DDE8.9050700@gmail.com>
In-Reply-To: <5109DDE8.9050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/05/2013 06:56 PM, Bob Montgomery wrote:
> On Tue, 2013-02-05 at 10:56 -0500, Vlad Yasevich wrote:
>> On 02/04/2013 06:47 PM, Bob Montgomery wrote:
>>
>>> And another:
>>>
>>> Under normal operation, an event that fills a hole in the lobby will
>>> result in a list of events (the new one and sequential ones that had
>>> been waiting in the lobby) being sent to sctp_ulpq_tail_event().  Then
>>> we do this:
>>>            /* Check if the user wishes to receive this event.  */
>>>           if (!sctp_ulpevent_is_enabled(event, &sctp_sk(sk)->subscribe))
>>>                   goto out_free;
>>>
>>> In out_free, we do
>>>                   sctp_queue_purge_ulpevents(skb_list);
>>>
>>>
>>> So if the first event was a notification that we don't subscribe to,
>>> but the remaining 100 were data, do we really throw out all the
>>> other data with it??
>>
>> No and for 2 reasons.
>>     1. sctp_ulpevent_is_enabled only checks for notification events, not
>> DATA.
>>     2. Notification events aren't ordered and are always singular.
>>
>> So, you will either have all data in the list or a singular notification
>> that you don't subscribe to.
>>
>> -vlad
>
> Thanks.  That's the kind of insight I was referring to :-)  I'll take
> that worry off my list.
>
> We have two different hangs:
>
> I believe the first one is caused by this code under these conditions:
>
>          /* If able to free enough room, accept this chunk. */
>          if (chunk && (freed >= needed)) {
>                  __u32 tsn;
>                  tsn = ntohl(chunk->subh.data_hdr->tsn);
>                  sctp_tsnmap_mark(&asoc->peer.tsn_map, tsn);
>                  sctp_ulpq_tail_data(ulpq, chunk, gfp);
>
>                  sctp_ulpq_partial_delivery(ulpq, chunk, gfp);
>          }
>
>
>
> If the reasm queue looks like this after we renege to make room for
> LAST N+4:
>
> 	FIRST	N
> 	MIDDLE	N+1
>          MIDDLE  N+2
> 	MIDDLE	N+3   <-- cumulative_tsn_ack
> 			<-- base_tsn would be N+4
>
> 	
> 	FIRST	N+10
>
> then the call to sctp_ulpq_tail_data(ulpq, chunk, gfp);
> will reasm and deliver N,N+1,N+2,N+3,N+4 moving the cumulative_ack
> up to N+4 and leaving N+10 as the only item in the reasm queue.
>
> Then we call sctp_ulpq_partial_delivery(ulpq, chunk, gfp);
>
> chunk is ignored (then why even there??) and we'll partial
> deliver FIRST N+10, which is scary because it's ahead of cumulative
> tsn_ack.  And then we set pd_mode = 1.
>
> Now FIRST N+5 arrives and is put in the reasm queue by
> sctp_ulpq_reasm().  But we're in pd_mode = 1 so we call
> sctp_ulpq_retrieve_partial since N+5 is what we're looking
> for.  But sctp_ulpq_retrieve_partial() will bail when it sees
> N+5 (A FIRST_FRAG) because it is only looking for MIDDLE_FRAG
> or LAST_FRAG in the first slot of the reasm queue.
>

This is an interesting find.  Seems to me that 
sctp_ulpq_retrieve_first() should make sure that we don't start pulling
fragments off the reassembly queue with TSN > Cumulative Ack Point 
(essentially no grabbing tsns that are after the gap).

This seems to be Day1 bug in that code as it blindly assumes that the 
next first fragment is the right one to start with.  The same problem 
also exist in sctp_ulpq_retrieve_partial().  There is no guarantee that 
the first fragment on the queue has TSN that is before the gap, so I 
might be possible to get into the exact same situation with middle/last 
fragments as well.

> And now I think we're stuck forever.
> =======================
>
> The second hang does not involve the reasm queue.  It occurs on a test
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

Hmm..  This is very strange.  We should never accept duplicate SSNs as 
they should also have duplicate TSNs as well.

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

This seems like there are 2 gaps in the map.  The first GAP is CTSN+1 
(since bit 0 in the map is not set).  You appear to be filling the 
second very large gap which is OK.  Can you look through the ulpq to see
which other TSN had the SSN 0x30e.  It should still be in the queue.

Thanks
-vlad
>
> The lone bit in the second word describes tsn 0x55050210, our duplicate.
>
>
> It might be a 1 in 64 coincidence that our duplicate was the LSB of an
> otherwise empty 64-bit map word(?) or it might be some map manipulation
> off by 1 error that maybe cleared the bit of an event we already had,
> and let the state machine pass another copy??
>
> We need to capture another example of this duplicate entry.
>
> More later,
> Bob Montgomery
>
>
>
>
>

