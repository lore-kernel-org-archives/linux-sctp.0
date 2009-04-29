From: Padmalochan Moharana <padman.m@gmail.com>
Date: Wed, 29 Apr 2009 12:38:08 +0000
Subject: regarding SCTP_DELAYED_ACK_TIME
Message-Id: <816fa6970904290526l3f3cf4b4xebc60e0f0b9b3751@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <816fa6970904290514q347cdc9am2b25c123a94af605@mail.gmail.com>
In-Reply-To: <816fa6970904290514q347cdc9am2b25c123a94af605@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

In my application I have tried to set the SACK timer to 400 Milli
second by writing following code.

struct sctp_assoc_value sack_timer ;
bzero(&sack_timer, sizeof(sack_timer));
sack_timer.assoc_id =1 ;
sack_timer.assoc_value = 400 ;
int res = setsockopt(socketFD, IPPROTO_SCTP, SCTP_DELAYED_ACK_TIME,
&sack_timer,sizeof(struct sctp_assoc_value ));

But setsockopt() returns error ("Protocol not available").

The kernel version i have used is : 2.6.9-55.EL
lksctp version: 1.0.8

Please let me know how can i set SCTP_DELAYED_ACK_TIME value in my application.

Br,
Padmalochan
