From: David Miller <davem@davemloft.net>
Date: Tue, 13 Aug 2013 05:14:18 +0000
Subject: Re: [PATCH net v3] net: sctp: sctp_transport_destroy{,_rcu}: fix potential pointer corruption
Message-Id: <20130812.221418.587541295527206954.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1376058321-2461-1-git-send-email-dborkman@redhat.com>
	<5204FFDD.5060703@gmail.com>
In-Reply-To: <5204FFDD.5060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 09 Aug 2013 10:42:37 -0400

> On 08/09/2013 10:25 AM, Daniel Borkmann wrote:
>> Probably this one is quite unlikely to be triggered, but it's more
>> safe
>> to do the call_rcu() at the end after we have dropped the reference on
>> the asoc and freed sctp packet chunks. The reason why is because in
>> sctp_transport_destroy_rcu() the transport is being kfree()'d, and if
>> we're unlucky enough we could run into corrupted pointers. Probably
>> that's more of theoretical nature, but it's safer to have this simple
>> fix.
>>
>> Introduced by commit 8c98653f ("sctp: sctp_close: fix release of
>> bindings
>> for deferred call_rcu's"). I also did the 8c98653f regression test and
>> it's fine that way.
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
