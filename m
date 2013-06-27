From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 27 Jun 2013 15:14:32 +0000
Subject: Re: [PATCH net-next v2 2/2] net: sctp: rework debugging framework to use pr_debug and friends
Message-Id: <51CC56D8.4020805@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372326225-19203-1-git-send-email-dborkman@redhat.com>  <1372326225-19203-3-git-send-email-dborkman@redhat.com> <1372344595.2060.15.camel@joe-AO722>
In-Reply-To: <1372344595.2060.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06/27/2013 04:49 PM, Joe Perches wrote:
> On Thu, 2013-06-27 at 11:43 +0200, Daniel Borkmann wrote:
>>    - Changed %pIg into %pIS, thanks Joe Perches
>
> Hi Daniel.
>
>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> []
>> +	pr_debug("%s: association:%p addr:%pIS port:%d\n",
>> +		 __func__, asoc, &peer->ipaddr.sa,
>> +		 ntohs(peer->ipaddr.v4.sin_port));
>
> This is why I think %pIS should have an option
> to print port/flow, etc.

Ok, agreed, that will be more clean and can be applied there.

I'll work that in, and when finished send a 3rd version of the set.

Thanks Joe!

> In this case it's using v4 and you are mixing
> unknown and known forms.  It looks untidy.
> You should probably use peer->sa.sin_port instead.
>
>> @@ -636,12 +638,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
>>   	/* AF_INET and AF_INET6 share common port field. */
>>   	port = ntohs(addr->v4.sin_port);
>>
>> -	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_add_peer:association %p addr: ",
>> -				 " port: %d state:%d\n",
>> -				 asoc,
>> -				 addr,
>> -				 port,
>> -				 peer_state);
>> +	pr_debug("%s: association:%p addr:%pIS port:%d state:%d\n", __func__,
>> +		 asoc, &addr->sa,port , peer_state);
>
> here too, but port may be unused when !CONFIG_DEBUG
>
> I didn't look at the rest of the patch.
