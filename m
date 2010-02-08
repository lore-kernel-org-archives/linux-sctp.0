From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 08 Feb 2010 01:55:40 +0000
Subject: Re: [PATCH] sctp: avoid irq lock inversion while call sk->sk_data_ready()
Message-Id: <4B6F6F1C.5060404@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B6903D6.8070106@cn.fujitsu.com>
In-Reply-To: <4B6903D6.8070106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Vlad Yasevich wrote:
> Wei Yongjun wrote:
>   
>> Vlad Yasevich wrote:
>>     
>>> Wei Yongjun wrote:
>>>   
>>>       
>>>> sk->sk_data_ready() of sctp socket can be called from both BH and non-BH
>>>> contexts, but the default sk->sk_data_ready(), sock_def_readable(), can
>>>> not be used in this case. Therefore, we have to make a new function
>>>> sctp_data_ready() to grab sk->sk_data_ready() with BH disabling.
>>>>
>>>>     
>>>>         
>>> Wouldn't the same inversion happen in TCP as well?  TCP can call that
>>> function in _bh and user contexts as well.
>>>   
>>>       
>> Not sure, but TCP does not call that function in user context at all.
>>
>>     
>
> Wei
>
> Can you trigger this problem with this patch applied?
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 3a95fcb..dabdc50 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3717,9 +3717,9 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
>  	sp->hmac = NULL;
>
>  	SCTP_DBG_OBJCNT_INC(sock);
> -	percpu_counter_inc(&sctp_sockets_allocated);
>
>  	local_bh_disable();
> +	percpu_counter_inc(&sctp_sockets_allocated);
>  	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
>  	local_bh_enable();
>
> -vlad

This patch did not change anything, the lockdep INFO still exists.

This lockdep INFO happend when I try to make a user abort through
sctp_primitive_ABORT.



