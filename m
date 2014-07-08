From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 08 Jul 2014 08:51:45 +0000
Subject: Re: [PATCH net-next 3/5] net: sctp: implement rfc6458, 5.3.5. SCTP_RCVINFO cmsg support
Message-Id: <53BBB121.5020907@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-4-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-4-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/07/2014 10:54 AM, David Laight wrote:
> From: Daniel Borkmann
>> From: Geir Ola Vaagland <geirola@gmail.com>
>>
>> This patch implements section 5.3.5. of RFC6458, that is, support
>> for 'SCTP Receive Information Structure' (SCTP_RCVINFO) which is
>> placed into ancillary data cmsghdr structure for each recvmsg()
>> call.
>>
>> This option can be enabled/disabled via setsockopt(2) on SOL_SCTP
>> level by setting an int value with 1/0 for SCTP_RECVRCVINFO in user
>> space applications as per RFC6458, section 8.1.29.
>>
>> The sctp_rcvinfo structure is defined as per RFC as below ...
>>
>>    struct sctp_rcvinfo {
>>      uint16_t rcv_sid;
>>      uint16_t rcv_ssn;
>>      uint16_t rcv_flags;
>>      <-- 2 bytes hole  -->
>>      uint32_t rcv_ppid;
>>      uint32_t rcv_tsn;
>>      uint32_t rcv_cumtsn;
>>      uint32_t rcv_context;
>>      sctp_assoc_t rcv_assoc_id;
>>    };
>>
>> ... and provided under cmsg_level IPPROTO_SCTP, cmsg_type
>> SCTP_RCVINFO, while cmsg_data[] contains struct sctp_rcvinfo.
>> An sctp_rcvinfo item always corresponds to the data in msg_iov.
>>
>> Joint work with Daniel Borkmann.
> ...
>> +/* RFC6458, Section 5.3.5 SCTP Receive Information Structure
>> + * (SCTP_SNDRCV)
>> + */
>> +void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
>> +				struct msghdr *msghdr)
>> +{
>> +	struct sctp_rcvinfo rinfo;
>> +
>> +	if (sctp_ulpevent_is_notification(event))
>> +		return;
>> +
>> +	memset(&rinfo, 0, sizeof(struct sctp_rcvinfo));
>> +	rinfo.rcv_sid = event->stream;
>> +	rinfo.rcv_ssn = event->ssn;
>> +	rinfo.rcv_ppid = event->ppid;
>> +	rinfo.rcv_flags = event->flags;
>> +	rinfo.rcv_tsn = event->tsn;
>> +	rinfo.rcv_cumtsn = event->cumtsn;
>> +	rinfo.rcv_assoc_id = sctp_assoc2id(event->asoc);
>> +	rinfo.rcv_context = event->asoc->default_rcv_context;
>> +
>> +	put_cmsg(msghdr, IPPROTO_SCTP, SCTP_RCVINFO,
>> +		 sizeof(rinfo), &rinfo);
>> +}

Sorry for the late answer, as I'm on travel this week.

> This gets called for every receive data chunk (since the user needs to
> verify the ssn and stream).
>
> It really ought to be possible to write the 'cmsg' data with quite so
> many memory accesses.
>
> Perhaps you should add named fields for the pads so they can be explicitly zeroed.

I really dislike the idea to put padding members into a uapi struct, we
should stick to the RFC though it specified it with holes in the struct.
