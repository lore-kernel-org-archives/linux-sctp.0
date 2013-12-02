From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 02 Dec 2013 08:45:30 +0000
Subject: Re: [PATCH] lksctp: fix a problem when do test_1_to_1_sockopt
Message-Id: <529C48AA.2090209@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529C3B45.3020401@huawei.com>
In-Reply-To: <529C3B45.3020401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 2013/12/2 15:48, Wang Weidong wrote:
> From: Wang Weidong <wangweidong1@huawei.com>
> 
> When I do the test_1_to_1_sockopt, I got a Segmentation fault:
> DUMP_CORE test_1_to_1_sockopt.c: 343.
> I used the kernel is 3.12.
> The problem is that the SOCK_MIN_SNDBUF is (TCP_SKB_MIN_TRUESIZE * 2)
> while TCP_SKB_MIN_TRUESIZE is 2048 + SKB_DATA_ALIGN(sizeof(struct sk_buff))
> The SKB_DATA_ALIGN I test is 256, so I make the sndbuf_val_set to 2304.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>  src/func_tests/test_1_to_1_sockopt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/func_tests/test_1_to_1_sockopt.c b/src/func_tests/test_1_to_1_sockopt.c
> index e222991..986533b 100644
> --- a/src/func_tests/test_1_to_1_sockopt.c
> +++ b/src/func_tests/test_1_to_1_sockopt.c
> @@ -320,7 +320,7 @@ main(void)
>  			 "got value differs Set Value=%d Get Value=%d",
>  			 (2*rcvbuf_val_set), rcvbuf_val_get);
>  
> -	sndbuf_val_set = 2048;
> +	sndbuf_val_set = 2304;
>  	/* TEST17: Test case for setsockopt SO_SNDBUF */
>  	error = setsockopt(sk2, SOL_SOCKET, SO_SNDBUF, &sndbuf_val_set, len);
>  	if (error < 0)
> 

Sorry for that I didn't send it to Vlad and Daniel. Just ignore it.
I will resend it.


