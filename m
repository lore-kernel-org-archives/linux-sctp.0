From: David Miller <davem@davemloft.net>
Date: Sun, 29 Jan 2017 18:41:12 +0000
Subject: Re: [PATCHv3 net-next 3/4] sctp: add support for generating stream reconf add incoming/outgoing stre
Message-Id: <20170129.134112.544286618637799283.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6DB026B8E0@AcuExch.aculab.com>
        <20170123.105810.222331205902181203.davem@davemloft.net>
        <20170129143117.GK3781@localhost.localdomain>
In-Reply-To: <20170129143117.GK3781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: David.Laight@ACULAB.COM, lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: marcelo.leitner@gmail.com
Date: Sun, 29 Jan 2017 12:31:17 -0200

> On Mon, Jan 23, 2017 at 10:58:10AM -0500, David Miller wrote:
>> If this is "so critical" for end to end communication, why the heck
>> do you not see __packed sprinkled all over our definitions for IPV4,
>> IPV6, TCP, UDP, etc. headers?
>> 
>> Do you know why?  Because it's completely unnecessary...
> 
> Btw, virtually all sctp headers are currently tagged with __packed,
> since forever.
 ...
> I'm reviewing them all and will probably post a patch to remove them.

Thanks.
