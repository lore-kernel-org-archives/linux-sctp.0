From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 02 Mar 2018 20:04:29 +0000
Subject: Re: [PATCH] selinux: Fix ltp test connect-syscall failure
Message-Id: <20180302200429.GC3888@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180302195434.15435-1-richard_c_haines@btinternet.com>
In-Reply-To: <20180302195434.15435-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Fri, Mar 02, 2018 at 07:54:34PM +0000, Richard Haines wrote:
> Fix the following error when running regression tests using LTP as follows:
> cd /opt/ltp/
> cat runtest/syscalls |grep connect01>runtest/connect-syscall
> ./runltp -pq -f connect-syscall
> 
> Running tests.......
> connect01    1  TPASS  :  bad file descriptor successful
> connect01    2  TPASS  :  invalid socket buffer successful
> connect01    3  TPASS  :  invalid salen successful
> connect01    4  TPASS  :  invalid socket successful
> connect01    5  TPASS  :  already connected successful
> connect01    6  TPASS  :  connection refused successful
> connect01    7  TFAIL  :  connect01.c:146: invalid address family ;
> returned -1 (expected -1), errno 22 (expected 97)
> INFO: ltp-pan reported some tests FAIL
> LTP Version: 20180118
> 
> Reported-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  security/selinux/hooks.c | 42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 28a5c4e..d614df1 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4470,22 +4470,29 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
>  		 * need to check address->sa_family as it is possible to have
>  		 * sk->sk_family = PF_INET6 with addr->sa_family = AF_INET.
>  		 */
> -		if (address->sa_family = AF_INET) {
> -			if (addrlen < sizeof(struct sockaddr_in)) {
> -				err = -EINVAL;
> -				goto out;
> -			}
> +		switch (address->sa_family) {
> +		case AF_INET:
> +			if (addrlen < sizeof(struct sockaddr_in))
> +				return -EINVAL;
>  			addr4 = (struct sockaddr_in *)address;
>  			snum = ntohs(addr4->sin_port);
>  			addrp = (char *)&addr4->sin_addr.s_addr;
> -		} else {
> -			if (addrlen < SIN6_LEN_RFC2133) {
> -				err = -EINVAL;
> -				goto out;
> -			}
> +			break;
> +		case AF_INET6:
> +			if (addrlen < SIN6_LEN_RFC2133)
> +				return -EINVAL;
>  			addr6 = (struct sockaddr_in6 *)address;
>  			snum = ntohs(addr6->sin6_port);
>  			addrp = (char *)&addr6->sin6_addr.s6_addr;
> +			break;
> +		default:
> +			/* Note that SCTP services expect -EINVAL, whereas
> +			 * others expect -EAFNOSUPPORT.
> +			 */
> +			if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> +				return -EINVAL;
> +			else
> +				return -EAFNOSUPPORT;
>  		}
>  
>  		if (snum) {
> @@ -4589,16 +4596,27 @@ static int selinux_socket_connect_helper(struct socket *sock,
>  		 * need to check address->sa_family as it is possible to have
>  		 * sk->sk_family = PF_INET6 with addr->sa_family = AF_INET.
>  		 */
> -		if (address->sa_family = AF_INET) {
> +		switch (address->sa_family) {
> +		case AF_INET:
>  			addr4 = (struct sockaddr_in *)address;
>  			if (addrlen < sizeof(struct sockaddr_in))
>  				return -EINVAL;
>  			snum = ntohs(addr4->sin_port);
> -		} else {
> +			break;
> +		case AF_INET6:
>  			addr6 = (struct sockaddr_in6 *)address;
>  			if (addrlen < SIN6_LEN_RFC2133)
>  				return -EINVAL;
>  			snum = ntohs(addr6->sin6_port);
> +			break;
> +		default:
> +			/* Note that SCTP services expect -EINVAL, whereas
> +			 * others expect -EAFNOSUPPORT.
> +			 */
> +			if (sksec->sclass = SECCLASS_SCTP_SOCKET)
> +				return -EINVAL;
> +			else
> +				return -EAFNOSUPPORT;
>  		}
>  
>  		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
