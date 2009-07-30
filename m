From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 30 Jul 2009 17:05:09 +0000
Subject: Re: [PATCH] Fix piggybacked ACKs
Message-Id: <4A71D2C5.4090509@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20090729160557.GC29475@nortel.com>
In-Reply-To: <20090729160557.GC29475@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Doug Graham wrote:
> On Thu, Jul 30, 2009 at 05:51:18PM +0800, Wei Yongjun wrote:
>> The sender should create a SACK only if the size of the final SCTP
>> packet does not exceed the current MTU. Base on RFC 4960:
>>
>>   6.1.  Transmission of DATA Chunks
>>
>>     Before an endpoint transmits a DATA chunk, if any received DATA
>>     chunks have not been acknowledged (e.g., due to delayed ack), the
>>     sender should create a SACK and bundle it with the outbound DATA
>>     chunk, as long as the size of the final SCTP packet does not exceed
>>     the current MTU.
> 
> [patch deleted]
> 
> I think you're right that there's a real problem here, and that a patch
> similar to yours is needed, but this is not a new problem introduced
> with my patch.  I only changed the conditions under which a SACK chunk
> was bundled with a DATA chunk, but the same bundling would have been
> happening before under different conditions.
> 
> I'd really need to study the code more than I have to be able to say
> whether or not your fix is correct (and who cares what I think anyway
> :-)), but I've just spent all of about 15 minutes looking at parts of the
> code that I'd never looked at before, and I see something that off the
> top of my head looks a bit scary.  That is that sctp_packet_bundle_sack()
> calls sctp_packet_append_chunk(), which calls sctp_packet_bundle_sack().
> Aside from the possibility of infinite recursion (presumably this must
> be prevented somehow, because it doesn't seem to happen), the logic of
> this seems strangely circular to me.  If bundle_sack() is going to call
> append_chunk(), I'd have guessed that append_chunk() would be a lower
> level routine that just appends the chunk you give it, not one that
> itself tries to bundle other chunks in.

sctp_append_chunk() tries to be very smart.  It's a generic routine that you
call that also then tries to figure out if any special bundle can also be done.

The circular bundling doesn't happen because the chunk one passes to
sctp_packet_bundle_sack() changes.   The first time in, the chunk is a data
chunk that makes us go into the whole added the SACK in.  At this time,
append_chunk() is called with a SACK chunk and a seemingly recursive call to
bundle_sack() bails since the chunk is not data.

I think the Wei's patch for mtu checking should probably move into bundle_sack().

-vlad

> 
> Anyway, you've got me curious now.  I'll have a go at better understanding
> the code when I get some time.
> 
> --Doug.
> 

