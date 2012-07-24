From: Xufeng Zhang <xufengzhang.main@gmail.com>
Date: Tue, 24 Jul 2012 01:53:02 +0000
Subject: Re: [PATCH] sctp: Make "Invalid Stream Identifier" ERROR follows SACK when bundling
Message-Id: <CA+=dFziWBDQWyLDNDzgdz2deVpPMnBs6jnvA6iX_LLbckxdu9g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1342677450-21810-1-git-send-email-xufengzhang.main@gmail.com>
	<20120723004932.GB8040@neilslaptop.think-freely.org>
	<500CB74A.4040300@windriver.com>
	<20120723121411.GC16518@hmsreliant.think-freely.org>
In-Reply-To: <20120723121411.GC16518@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: xufeng zhang <xufeng.zhang@windriver.com>, vyasevich@gmail.com, sri@us.ibm.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/23/12, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Jul 23, 2012 at 10:30:34AM +0800, xufeng zhang wrote:
>> On 07/23/2012 08:49 AM, Neil Horman wrote:
>> >
>> >Not sure I understand how you came into this error.  If we get an
>> > invalid
>> >stream, we issue an SCTP_REPORT_TSN side effect, followed by an
>> > SCTP_CMD_REPLY
>> >which sends the error chunk.  The reply goes through
>> >sctp_outq_tail->sctp_outq_chunk->sctp_outq_transmit_chunk->sctp_outq_append_chunk.
>> >That last function checks to see if a sack is already part of the packet,
>> > and if
>> >there isn't one, appends one, using the updated tsn map.
>> Yes, you are right, but consider the invalid stream identifier's
>> DATA chunk is the first
>> DATA chunk in the association which will need SACK immediately.
>> Here is what I thought of the scenario:
>>     sctp_sf_eat_data_6_2()
>>         -->sctp_eat_data()
>>             -->sctp_make_op_error()
>>             -->sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(err))
>>             -->sctp_outq_tail()          /* First enqueue ERROR chunk */
>>         -->sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, SCTP_FORCE())
>>             -->sctp_gen_sack()
>>                 -->sctp_make_sack()
>>                 -->sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
>> SCTP_CHUNK(sack))
>>                 -->sctp_outq_tail()          /* Then enqueue SACK chunk
>> */
>>
>> So SACK chunk is enqueued after ERROR chunk.
> Ah, I see.  Since the ERROR and SACK chunks are both control chunks, and
> since
> we explicitly add the SACK to the control queue instead of going through
> the
> bundle path in sctp_packet_append_chunk the ordering gets wrong.
>
> Ok, so the problem makes sense.  I think the soultion could be alot easier
> though.  IIRC SACK chunks always live at the head of a packet, so why not
> just
> special case it in sctp_outq_tail?  I.e. instead of doing a list_add_tail,
> in
> the else clause of sctp_outq_tail check the chunk_hdr->type to see if its
> SCTP_CID_SACK.  If it is, use list_add_head rather than list_add_tail.  I
> think
> that will fix up both the COOKIE_ECHO and ESTABLISHED cases, won't it?  And
> then
> you won't have keep track of extra state in the packet configuration.

(Please ignore the duplicate messages if you received, sorry for this!)

Yes, it's a good idea, but I think the premise is not correct:
RFC 4960 page 57:
"D) Upon reception of the COOKIE ECHO chunk, endpoint "Z" will reply
   with a COOKIE ACK chunk after building a TCB and moving to the
   ESTABLISHED state. A COOKIE ACK chunk may be bundled with any
   pending DATA chunks (and/or SACK chunks), but the COOKIE ACK chunk
   MUST be the first chunk in the packet."

So we can't put SACK chunk always at the head of the packet.


Thanks,
Xufeng Zhang

>
> Regards
> Neil
>
>
