From: Jeff Carter <J.Carter@F5.com>
Date: Tue, 01 Jul 2014 13:59:57 +0000
Subject: RE: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <c9bf89508e4a46aa8db05982c14a2a1c@LWLEXCHMBX01.olympus.F5Net.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140628190435.AF72.327CAA51@tspi.com.ph>
In-Reply-To: <20140628190435.AF72.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Also notice that the RFC states this:

" The Sender-Specific Heartbeat Info field should normally include
  information about the sender's current time when this HEARTBEAT
  chunk is sent and the destination transport address to which this
  HEARTBEAT is sent (see Section 8.3)."

So that is perfectly well expected that the HEARTBEAT ACK source
address won't be the destination address of the HEARTBEAT.

Jeff Carter


-----Original Message-----
From: linux-sctp-owner@vger.kernel.org [mailto:linux-sctp-owner@vger.kernel.org] On Behalf Of Michael Tuexen
Sent: Tuesday, July 01, 2014 7:58 AM
To: Daniel Borkmann
Cc: Neil Horman; Winston V. Tizon; linux-sctp@vger.kernel.org
Subject: Re: SCTP Multihoming Heartbeat ACK Behavior

On 01 Jul 2014, at 13:38, Daniel Borkmann <dborkman@redhat.com> wrote:

> On 07/01/2014 01:20 PM, Neil Horman wrote:
>> On Tue, Jul 01, 2014 at 03:48:32PM +0800, Winston V. Tizon wrote:
> ...
>>> (***) -> Based on SCTP RFC4960, expected behavior is secondary IP address
>>>          should be used as path in sending the HB_ACK.
>>> 
>> Actually, its quite the opposite, this confirms that the sctp protocol is
>> functioning normally.  RFC 4960 says this about HB_ACK's:
>> 
>> 3.3.6.  Heartbeat Acknowledgement (HEARTBEAT ACK) (5)
>> 
>>    An endpoint should send this chunk to its peer endpoint as a response
>>    to a HEARTBEAT chunk (see Section 8.3).  A HEARTBEAT ACK is always
>>    sent to the source IP address of the IP datagram containing the
>>    HEARTBEAT chunk to which this ack is responding.
>> 
>> The only thing that a peer has to do regarding a HB frame is sent an HB_ACK to
>> the source ip address of the corresponding HB frame (in this case172.168.39.4),
>> which we do my recording the inbound transport that the HB frame arrived on.
> 
> I agree with you, Neil, the RFC only mentions that we need to "sent to the
> source IP address", which was what I've quoted earlier on as well, so above
> statement to use "secondary IP address should be used as path in sending
> the HB_ACK" is not a MUST.
RFC 4960 does not make explicit statements about source address selection
in general...

Best regards
Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
