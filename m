From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 17 Dec 2018 11:38:21 +0000
Subject: Re: [PATCH] Fix error->errno typo
Message-Id: <20181217113821.GD9056@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181217085615.12481-1-jijianwen@gmail.com>
In-Reply-To: <20181217085615.12481-1-jijianwen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Dec 17, 2018 at 04:56:15PM +0800, Jianwen Ji wrote:
> Signed-off-by: Jianwen Ji <jijianwen@gmail.com>
> ---
>  src/apps/sctp_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
> index 4aa2d13..cd7654b 100644
> --- a/src/apps/sctp_test.c
> +++ b/src/apps/sctp_test.c
> @@ -870,7 +870,7 @@ int receive_r(int sk, int once)
>  		DEBUG_PRINT(DEBUG_MIN, "\trecvmsg(sk=%d) ", sk);
>  
>  		error = recvmsg(recvsk, &inmessage, MSG_WAITALL);
> -		if (error < 0 && error != EAGAIN) {
> +		if (error < 0 && errno != EAGAIN) {

There is a similar one in sctp_status:

apps]$ git grep -B1 'error....E'
sctp_status.c-          error = recvmsg(sk, &inmessage, MSG_WAITALL);
sctp_status.c:          if (error < 0 && error != EAGAIN) {
--
sctp_test.c-            error = recvmsg(recvsk, &inmessage, MSG_WAITALL);
sctp_test.c:            if (error < 0 && error != EAGAIN) {

mind sending a patch fixing it too? Thanks.

>  			if (errno = ENOTCONN && socket_type = SOCK_STREAM &&
>  			    role = SERVER) {
>  				printf("No association is present now!!\n");
> -- 
> 2.9.5
> 
