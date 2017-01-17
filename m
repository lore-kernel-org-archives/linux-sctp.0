From: Julian Cordes <julian.cordes@gmail.com>
Date: Tue, 17 Jan 2017 18:57:00 +0000
Subject: Re: Fragmented ordered user messages with inconsistent stream sequence numbers are accepted and deli
Message-Id: <CAO9aL+B9ca245NrX7Qn0GBK4vL=S89Qv5p5ixMm0Auya5ewjWw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170117131311.GF6494@aomx-netbook>
In-Reply-To: <20170117131311.GF6494@aomx-netbook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

2017-01-17 19:49 GMT+01:00 Xin Long <lucien.xin@gmail.com>:
> On Tue, Jan 17, 2017 at 9:13 PM, Julian Cordes <julian.cordes@gmail.com> wrote:
>> When fragmented ordered user messages are sent to the linux kernel user
>> messages with inconsistent stream sequence numbers are accepted and
>> delivered to the application. Take for example an look at the following test case:
>> https://github.com/nplab/PR_SCTP_Testsuite/blob/master/forward-tsn/error-cases/packet-loss/ordered/ordered-packet-loss-2.pkt
>>
>> Here I first inject two DATA-Chunks with sid/ssn 1/1, 2/1 into the
>> kernel with packetdrill:
>> line 67: +0.0 < sctp: DATA[flgs=E, len16, tsn=2, sid=1, ssn=1,
>> ppid=0]
>> line 69: +0.1 < sctp: DATA[flgs=E, len16, tsn=4, sid=2, ssn=1,
>> ppid=0]
>>
>> After 0.1 seconds i then inject an FORWARD-TSN with cum_tsn=2 bundled
>> with an DATA-Chunk that looks like this:
>> DATA[flgs=B, len16, tsn=3, sid=2, ssn=0, ppid=0]
>>
>> This "looks" like the first segment of the user message where already a
>> fragment (tsn=4) was received. But the ssn-values are  not consistent.
>> The DATA-Chunk with tsn=3 has ssn=0 and the ssn=1 therefore they should
>> be ignored by the IUT and not be delivered to the userland application when
>> calling sctp_recvmsg. Unfortunatly the linux kernel implementation does
>> currently deliver these inconsistent user messages.
> sorry, I may misunderstand you.
>
> after FORWARD-TSN, "DATA[flgs=E, len16, tsn=2, sid=1, ssn=1"
> should be received, then only "sctp: DATA[flgs=E, len16, tsn=4,
> sid=2, ssn=1" is in the queue, then "DATA[flgs=B, len16, tsn=3,
> sid=2, ssn=0, ppid=0]" is processed, these two chunks (tsn=3 and
> tsn=4) should be recvmsg, as their sid are the same and ssn are
> consistent (ssn=0 and ssn=1).
> and your sctp_recvmsg is after above, so it should be right.
>
> did I miss something?
>
>
Shouldnt the ssn be 0 for both DATA-Chunks with sid=2, because they
consistent to the same first fragmented user message of stream with
sid=2?
>>
>> There are many test-cases that all reproduce this
>> issue. Just take a look at the README at
>> https://github.com/nplab/PR_SCTP_Testsuite/tree/master/forward-tsn/error-cases/packet-loss/ordered.
