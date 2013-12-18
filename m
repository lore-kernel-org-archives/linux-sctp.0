From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 18 Dec 2013 13:59:01 +0000
Subject: Send fail notifications
Message-Id: <52B1AA25.3000700@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Lets say  between server and client i have an MTU of 4K.
I send 16K with partial reliability setting.
If the data gets through the receiver sees (I think
SCTP_PARTIAL_DELIVERY_POINT may change this behavior but it probably
defaults to MTU):

Msg1, 4k, !EOR
Msg2, 4k, !EOR
Msg3, 4k, !EOR
Msg4, 4k, EOR

OTOH, at sender if the send fails because PR timeout on some data
chunk occurs i receive from the kernel not 1 but 4 notifications.
Msg1, 4k, Notification(send failed, ssf_length=4k), EOR
Msg2, 4k, Notification(send failed, ssf_length=4k), EOR
Msg3, 4k, Notification(send failed, ssf_length=4k), EOR
Msg4, 4k, Notification(send failed, ssf_length=4k), EOR
.... some last message here to account for notification overhead ....

I was expecting only the last one to have an EOR or least the
ssf_length to be telling me there's more than 4K. Stoopid question:
Is there some  other field I should be looking at?

The only way i could tell the 5 notifications are from the same
original message is when i provide a sinfo_context at sendmsg() time.


cheers,
jamal
