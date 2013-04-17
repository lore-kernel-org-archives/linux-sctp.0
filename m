From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 17 Apr 2013 15:36:55 +0000
Subject: Re: [PATCH net-next 9/9] net: sctp: sctp_ulpq: do not use char as a struct member
Message-Id: <516EC197.1080206@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com> <1366146438-8815-10-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-10-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 04/16/2013 05:07 PM, Daniel Borkmann wrote:
> Replace char with a more appropriate __u8 bitfield for pd_mode.
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>   include/net/sctp/ulpqueue.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/sctp/ulpqueue.h b/include/net/sctp/ulpqueue.h
> index 00e50ba..a2bebd4 100644
> --- a/include/net/sctp/ulpqueue.h
> +++ b/include/net/sctp/ulpqueue.h
> @@ -49,10 +49,10 @@
>
>   /* A structure to carry information to the ULP (e.g. Sockets API) */
>   struct sctp_ulpq {
> -	char pd_mode;
>   	struct sctp_association *asoc;
>   	struct sk_buff_head reasm;
>   	struct sk_buff_head lobby;
> +	__u8 pd_mode:1;
>   };
>
>   /* Prototypes. */
>

This one is a bit pointless.  You are not saving any space and making 
generated code worse.

-vlad
