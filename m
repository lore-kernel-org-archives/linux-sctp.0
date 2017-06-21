From: David Miller <davem@davemloft.net>
Date: Wed, 21 Jun 2017 19:25:41 +0000
Subject: Re: [PATCH] net/sctp/ulpevent.c: Deinline sctp_ulpevent_set_owner, save 1616 bytes
Message-Id: <20170621.152541.1977800544203723274.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170621162809.4305-1-dvlasenk@redhat.com>
        <1498072750.3337.4.camel@perches.com>
In-Reply-To: <1498072750.3337.4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: dvlasenk@redhat.com, linux-kernel@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 21 Jun 2017 12:19:10 -0700

> On Wed, 2017-06-21 at 18:28 +0200, Denys Vlasenko wrote:
>> This function compiles to 147 bytes of machine code. 13 callsites.
>> 
>> I'm no expert on SCTP events, but quick reading of SCTP docs tells me that
>> SCTP events are not happening on every packet.
>> They are ASSOC_CHANGE, PEER_ADDR_CHANGE, REMOTE_ERROR and such.
>> Does not look performance critical.
> 
> Thanks.
> 
> But:
> 
>> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> []
>> @@ -88,7 +88,7 @@ int sctp_ulpevent_is_notification(const struct sctp_ulpevent *event)
>>  /* Hold the association in case the msg_name needs read out of
>>   * the association.
>>   */
>> -static inline void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
>> +static void sctp_ulpevent_set_owner(struct sctp_ulpevent *event,
>>  					   const struct sctp_association *asoc)
>>  {
>>  	struct sctp_chunk *chunk = event->chunk;
> 
> This now misaligns the next line after the inline removal.

Agreed, the argument indenation must be fixed.
