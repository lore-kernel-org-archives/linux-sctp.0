From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 05 Feb 2013 15:56:03 +0000
Subject: Re: Suspected renege problem in sctp
Message-Id: <51112B93.8060600@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5109DDE8.9050700@gmail.com>
In-Reply-To: <5109DDE8.9050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 02/04/2013 06:47 PM, Bob Montgomery wrote:
> On Thu, 2013-01-31 at 10:08 -0500, Vlad Yasevich wrote:
>> On 01/30/2013 11:30 PM, Roberts, Lee A. wrote:
>>> Vlad,
>>>
>>> The test code that I'm running at the moment has changes similar to the following.
>>> I think we want to peek at the tail of the queue---and not dequeue (or unlink) the
>>> data until we're sure we want to renege.
>>
>> You are right.  If Bob can send a signed-off patch linux-sctp and
>> netdev, we can get it upstream and into stable releases.
>>
>> -vlad
>
> Vlad,
>
> This is just one of many things we suspect, and doesn't explain (or fix)
> the hang we're looking at.  Lee and I are working on a list of problems
> around renege, tsnmap management, reassembly, and partial delivery mode.
>
> Here's a current favorite potential issue (documented by Lee):
>
> In sctp_ulpq_renege():
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
> sctp_tsnmap_mark is called *before* calling sctp_ulpq_tail_data().  But
> sctp_ulpq_tail_data can fail to allocated memory and return -ENOMEM.  So
> potentially we've marked this tsn as present and then failed to actually
> keep it, right?

The sctp_tsnmap_mark() here is not needed since sctp_ulpq_tail_data() 
will mark the TSN properly.

>
>
> Here's another potential issue:
>
> Since an event in the lobby has a single tsn value, but it might have
> been reassembled from several fragments (with sequential tsn's), the
> renege_list operation only calls sctp_tsnmap_renege with the single
> tsn.  So now I've discarded multiple tsn's worth of data, but only
> noted one of them in the map, right??
>

Right.  I noticed this one as well.  Not only do we fail to clean up the 
TSN map but we also do not compute the freed space correctly.  That 
could result in us discarding more data then necessary.

> And another:
>
> Under normal operation, an event that fills a hole in the lobby will
> result in a list of events (the new one and sequential ones that had
> been waiting in the lobby) being sent to sctp_ulpq_tail_event().  Then
> we do this:
>           /* Check if the user wishes to receive this event.  */
>          if (!sctp_ulpevent_is_enabled(event, &sctp_sk(sk)->subscribe))
>                  goto out_free;
>
> In out_free, we do
>                  sctp_queue_purge_ulpevents(skb_list);
>
>
> So if the first event was a notification that we don't subscribe to,
> but the remaining 100 were data, do we really throw out all the
> other data with it??

No and for 2 reasons.
   1. sctp_ulpevent_is_enabled only checks for notification events, not 
DATA.
   2. Notification events aren't ordered and are always singular.

So, you will either have all data in the list or a singular notification 
that you don't subscribe to.

-vlad


>
> These don't explain my favorite hang either, but I think I'm finally
> getting close to that problem.
>
> These things uncovered while trying to understand this code, and the
> fact that we're not testing and debugging on the current kernel is why
> we're not sending in any patches yet.
>
> Thanks for any confirmation or insight you can provide :-)
>
> Bob Montgomery
>
>

