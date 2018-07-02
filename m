From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 02 Jul 2018 02:12:32 +0000
Subject: Re: =?utf-8?B?6L2s5Y+R?= =?utf-8?Q?=3A?= I meet a problem about sctp and linux policy route
Message-Id: <20180702021232.GB26991@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jul 02, 2018 at 09:18:18AM +0800, peicaiyun wrote:
> We config our system a policy route as follow:
> 
> echo "100 my" >> /etc/iproute2/rt_tables ip route add to 0.0.0.0/0 via
> 192.168.0.2 dev eth0 table my /sbin/ip rule add from 12.34.0.0/32 table my
> 
> When I send sctp package from 12.34.0.100 in my machine(12.34.0.100 is ip of
> this machine), to  12.34.0.111 Then I find the package was send to
> 12.34.0.111,not through gw 192.168.0.2 Is the sctp package not follow policy
> route?

Correct.

> Why the package is not routed to 192.168.0.2?

This has been asked quite a few times already. You should be able to
find the answer in the archives.

  Marcelo
