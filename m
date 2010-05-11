From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 11 May 2010 13:23:54 +0000
Subject: Re: [PATCH for net-next-2.6] sctp: fix oops when update assoc retran
Message-Id: <4BE95A6A.8060605@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BE8FC76.40000@cn.fujitsu.com>
In-Reply-To: <4BE8FC76.40000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Shan Wei wrote:
> Wei Yongjun wrote, at 05/11/2010 02:43 PM:
>> commit fbdf501c9374966a56829ecca3a7f25d2b49a305
>>   sctp: Do no select unconfirmed transports for retransmissions
>>
>> added code to make sure that we do not select unconfirmed paths
>> for data transmission.  This caused a problem when there are only
>> 2 paths, 1 unconfirmed and 1 unreachable.  In that case, the next
>> retransmit path returned is NULL and that causes a kernel crash.
>>
>> commit d598b166ced20d9b9281ea3527c0e18405ddb803
>>   sctp: Make sure we always return valid retransmit path
>> try to fix it, but if DEBUG is configured, the oops is still
>> exists.
>>
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
>> ---
>>  net/sctp/associola.c |   15 ++++++++-------
>>  1 files changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
>> index 3912420..1f49af5 100644
>> --- a/net/sctp/associola.c
>> +++ b/net/sctp/associola.c
>> @@ -1323,15 +1323,16 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
>>  		}
>>  	}
>>  
>> -	if (t)
>> +	if (t) {
>>  		asoc->peer.retran_path = t;
>>  
>> -	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
>> -				 " %p addr: ",
>> -				 " port: %d\n",
>> -				 asoc,
>> -				 (&t->ipaddr),
>> -				 ntohs(t->ipaddr.v4.sin_port));
>> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:"
> 
> Try __func__ to simplify code.
> 
>> +					 "association %p addr: ",
>> +					 " port: %d\n",
>> +					 asoc,
>> +					 (&t->ipaddr),
>> +					 ntohs(t->ipaddr.v4.sin_port));
>> +	}
> 
> How about providing debug infos if t is NULL?
> something like "failed to  update retran path", or "no change to retran path".
> 
> Tested-by: Shan Wei <shanwei@cn.fujitsu.com>
> 

Sorry, I didn't run with debug enabled.... Actually, we should probably just
refer back to retran_path so that DEBUG output still shows which path we are
retransmitting on.

-vlad
