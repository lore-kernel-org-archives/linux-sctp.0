From: David Miller <davem@davemloft.net>
Date: Thu, 16 Jun 2016 21:26:01 +0000
Subject: Re: [PATCH net-next] sctp: change sk state to CLOSED instead of CLOSING in sctp_sock_migrate
Message-Id: <20160616.142601.1563089619805516209.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <9229f8aa0f4324831fc31b5334cde9a258404b62.1466010906.git.lucien.xin@gmail.com>
	<20160616.141139.1258089118185183298.davem@davemloft.net>
	<20160616211322.GW22680@localhost.localdomain>
In-Reply-To: <20160616211322.GW22680@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, daniel@iogearbox.net, xiaolong.ye@intel.com, eric.dumazet@gmail.com

From: marcelo.leitner@gmail.com
Date: Thu, 16 Jun 2016 18:13:22 -0300

> On Thu, Jun 16, 2016 at 02:11:39PM -0700, David Miller wrote:
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Thu, 16 Jun 2016 01:15:06 +0800
>> 
>> > Commit d46e416c11c8 ("sctp: sctp should change socket state when
>> > shutdown is received") may set sk_state CLOSING in sctp_sock_migrate,
>> > but inet_accept doesn't allow the sk_state other than ESTABLISHED/
>> > CLOSED for sctp. So we will change sk_state to CLOSED, instead of
>> > CLOSING, as actually sk is closed already there.
>> > 
>> > Fixes: commit d46e416c11c8 ("sctp: sctp should change socket state when shutdown is received")
>> > Reported-by: Ye Xiaolong <xiaolong.ye@intel.com>
>> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> 
>> Applied.
> 
> I thought Xin was going to post a version with that tag Fixed, but ok.

I fixed the tag.
