From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 23 May 2014 15:05:20 +0000
Subject: Re: [PATCH] lksctp-tools: make bind_test can do while disable IPV6
Message-Id: <537F63B0.8000201@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <537EBD19.2030003@huawei.com>
In-Reply-To: <537EBD19.2030003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 05/22/2014 11:14 PM, Wang Weidong wrote:
> From e496cc0da4b43f4686e91aa9ffa73869e1f4c91d Mon Sep 17 00:00:00 2001
> From: Wang Weidong <wangweidong1@huawei.com>
> Date: Mon, 9 Jun 2014 23:32:39 +0800
> Subject: [PATCH] lksctp-tools: make bind_test can do while disable IPV6
> 
> When disable IPv6, the bind_test can't work for IPv4. So add
> a variable 'domain' for support working for IPv4.
> 
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>  src/apps/bindx_test.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/apps/bindx_test.c b/src/apps/bindx_test.c
> index b1c9ffa..ff3de86 100644
> --- a/src/apps/bindx_test.c
> +++ b/src/apps/bindx_test.c
> @@ -42,6 +42,7 @@ int main (int argc, char **argv)
>  	void *addr_buf_size = 0;
>  	size_t addrs, cnt;
>  	int sd, result, port;
> +	int domain = PF_INET6;
>  
>  	if (argc < 3) {
>  		fprintf(stderr,
> @@ -84,6 +85,7 @@ int main (int argc, char **argv)
>  		} else if (strchr(argv[cnt], '.')) {
>  			struct sockaddr_in *sa; 
>  
> +			domain = PF_INET;
>  			sa = (struct sockaddr_in *)buf_ptr;
>  			printf (" IPv4 address number %zu", addrs);
>  			sa->sin_family = AF_INET;
> @@ -103,7 +105,7 @@ int main (int argc, char **argv)
>  	printf ("bindx_test: INFO: Got %zu addrs\n", addrs);
>    
>  	/* Create the socket */
> -	sd = socket(PF_INET6, SOCK_SEQPACKET, IPPROTO_SCTP);
> +	sd = socket(domain, SOCK_SEQPACKET, IPPROTO_SCTP);
>  	if (sd = -1) {
>  		perror("bindx_test: ERROR: Cannot open socket");
>  		return 1;
> 

