From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 19:21:07 +0000
Subject: Re: Suboptimal handling of packets containing FORWARD-TSN and DATA chunks
Message-Id: <CAO9aL+DpCs0DvQDiy7_ijbBdVNDSeSD85G_bhyXVwiGxdtgHag@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117130852.GC6494@aomx-netbook>
In-Reply-To: <20170117130852.GC6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Yeah that could be the reason.

If you look for example at the test script
https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-5.pkt

there are two bundled SACK-Chunks sent by the linux kernel. this is
not invalid behaviour but it is inefficien (line 78)t:
+0.0 > sctp: SACK[flgs=0, cum_tsn=2, a_rwnd=..., gaps=[2:2, 4:4], dups=[]];
                    SACK[flgs=0, cum_tsn=4, a_rwnd=..., gaps=[2:2], dups=[]]

The second SACK-Chunk has a higher cum_tsn and it would be more
efficient to only send one SACK-Chunk in these cases. The FreeBSD
implementation only sends the following SACK-Chunk in this case:
+0.0 > sctp: SACK[flgs=0, cum_tsn=4, a_rwnd=..., gaps=[2:2], dups=[]]

2017-01-17 20:07 GMT+01:00 Xin Long <lucien.xin@gmail.com>:
> On Tue, Jan 17, 2017 at 9:08 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
>> WWhenever receiving packets containing FORWARD-TSN chunks bundled with a
>> DATA-Chunk the linux kernel sends currently two SACK-Chunks.
>> This is suboptimal, because after processing both received chunks, it
>> could send one SACK-Chunk.
>>
>>  Testscripts available at:
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-5.pkt
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-12.pkt
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/ordered/ordered-packet-loss-13.pkt
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-2.pkt
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-5.pkt
>>  - https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/receiver-side-implementation/packet-loss/unordered/unordered-packet-loss-12.pkt
>>
> you test script may triggered this:
>
>         /* From 12.2 Parameters necessary per association (i.e. the TCB):
>          *
>          * Ack State : This flag indicates if the next received packet
>          *           : is to be responded to with a SACK. ...
>          *           : When DATA chunks are out of order, SACK's
>          *           : are not delayed (see Section 6).
>          *
>          * [This is actually not mentioned in Section 6, but we
>          * implement it here anyway. --piggy]
>          */
>         if (max_tsn_seen != ctsn)
>                 asoc->peer.sack_needed = 1;
>
> if max_tsn_seen(the highest TSN we've seen) != ctsn(Cumulative TSN ACK Point),
> the sack will send immediately. :)
