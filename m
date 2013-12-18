From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 18 Dec 2013 14:06:12 +0000
Subject: Re: Send fail notifications
Message-Id: <52B1ABD4.1060108@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B1AA25.3000700@mojatatu.com>
In-Reply-To: <52B1AA25.3000700@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


A little more info:
- When i have MTU > 16K, no problem, 1 notification makes it through 
with an EOR and proper info
EOR.
- ssf_flags are always zero (thats one other place that may have carried
such extra info)
- kernel 3.12.0 (with other non-sctp patches)

cheers,
jamal

On 12/18/13 08:59, Jamal Hadi Salim wrote:
>
> Lets say  between server and client i have an MTU of 4K.
> I send 16K with partial reliability setting.
> If the data gets through the receiver sees (I think
> SCTP_PARTIAL_DELIVERY_POINT may change this behavior but it probably
> defaults to MTU):
>
> Msg1, 4k, !EOR
> Msg2, 4k, !EOR
> Msg3, 4k, !EOR
> Msg4, 4k, EOR
>
> OTOH, at sender if the send fails because PR timeout on some data
> chunk occurs i receive from the kernel not 1 but 4 notifications.
> Msg1, 4k, Notification(send failed, ssf_length=4k), EOR
> Msg2, 4k, Notification(send failed, ssf_length=4k), EOR
> Msg3, 4k, Notification(send failed, ssf_length=4k), EOR
> Msg4, 4k, Notification(send failed, ssf_length=4k), EOR
> .... some last message here to account for notification overhead ....
>
> I was expecting only the last one to have an EOR or least the
> ssf_length to be telling me there's more than 4K. Stoopid question:
> Is there some  other field I should be looking at?
>
> The only way i could tell the 5 notifications are from the same
> original message is when i provide a sinfo_context at sendmsg() time.
>
>
> cheers,
> jamal

