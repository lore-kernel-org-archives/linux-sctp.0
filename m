From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 07 Mar 2019 18:25:03 +0000
Subject: Re: [PATCH net 1/3] sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
Message-Id: <20190307182503.GB13515@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
 <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Sun, Mar 03, 2019 at 05:54:53PM +0800, Xin Long wrote:
> It should fail to create the new sk if sctp_bind_addr_dup() fails
> when accepting or peeloff an association.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index a2771b3..22adb8d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -102,9 +102,9 @@ static int sctp_send_asconf(struct sctp_association *asoc,
>  			    struct sctp_chunk *chunk);
>  static int sctp_do_bind(struct sock *, union sctp_addr *, int);
>  static int sctp_autobind(struct sock *sk);
> -static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> -			      struct sctp_association *assoc,
> -			      enum sctp_socket_type type);
> +static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
> +			     struct sctp_association *assoc,
> +			     enum sctp_socket_type type);
>  
>  static unsigned long sctp_memory_pressure;
>  static atomic_long_t sctp_memory_allocated;
> @@ -4655,7 +4655,11 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
>  	/* Populate the fields of the newsk from the oldsk and migrate the
>  	 * asoc to the newsk.
>  	 */
> -	sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> +	error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> +	if (error) {
> +		sk_common_release(newsk);
> +		newsk = NULL;
> +	}
>  
>  out:
>  	release_sock(sk);
> @@ -5401,7 +5405,12 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
>  	/* Populate the fields of the newsk from the oldsk and migrate the
>  	 * asoc to the newsk.
>  	 */
> -	sctp_sock_migrate(sk, sock->sk, asoc, SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
> +	err = sctp_sock_migrate(sk, sock->sk, asoc,
> +				SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
> +	if (err) {
> +		sock_release(sock);

I'm having a hard time understanding why it needs sock_release() here
and sk_common_release() in the above chunk. AFAICT by here (after
sctp_sock_migrate call) the sockets are pretty much the same. Mind
elaborating please?

> +		sock = NULL;
> +	}
>  
>  	*sockp = sock;
>  
