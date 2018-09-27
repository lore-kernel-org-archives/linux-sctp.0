From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 27 Sep 2018 15:03:34 +0000
Subject: Re: [PATCH lksctp-tools] func_tests: fix use of uninitialized var
Message-Id: <20180927150334.GB12328@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <04a0012e5f7a25b2995813c17cd5f38245eb9fe4.1537980726.git.marcelo.leitner@gmail.com>
In-Reply-To: <04a0012e5f7a25b2995813c17cd5f38245eb9fe4.1537980726.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Sep 26, 2018 at 01:53:58PM -0300, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> code-share1 reported that test_1_to_1_events was failing with:
> ./test_1_to_1_events
> test_1_to_1_events.c 1 PASS : COMM_UP notification on client socket - SUCCESS
> test_1_to_1_events.c 2 PASS : COMM_UP notification on server socket - SUCCESS
> test_1_to_1_events.c 3 BROK : Got a datamsg, expecting notification
> DUMP_CORE sctputil.c: 187
> 
> Turns out we were not initializing events, and thus relying on trash in
> the stack to enable sctp_authentication_event for us.
> 
> Fixes #25
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  src/func_tests/test_1_to_1_events.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/src/func_tests/test_1_to_1_events.c b/src/func_tests/test_1_to_1_events.c
> index 46439bf79c5ad5a49dca5d209fef67dc6b04177d..f758d6f701b60e485a63b45d92e7ce938d17be85 100644
> --- a/src/func_tests/test_1_to_1_events.c
> +++ b/src/func_tests/test_1_to_1_events.c
> @@ -92,9 +92,13 @@ main(int argc, char *argv[])
>  	/* Create the client socket.  */
>  	clt_sk = test_socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
>  
> +	memset(&event, 0, sizeof(event));
>  	event.sctp_data_io_event = 1;
>  	event.sctp_association_event = 1;
>  	event.sctp_shutdown_event = 1;
> +#ifdef HAVE_SCTP_AUTH_NO_AUTH
> +	event.sctp_authentication_event = 1;
> +#endif
>  	len = sizeof(struct sctp_event_subscribe);
>  	test_setsockopt(svr_sk, SCTP_EVENTS, &event, len);
>  	test_setsockopt(clt_sk, SCTP_EVENTS, &event, len);
> -- 
> 2.17.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
