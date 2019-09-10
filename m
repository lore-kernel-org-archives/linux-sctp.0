From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 10 Sep 2019 13:19:21 +0000
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

From: Xin Long
> Sent: 09 September 2019 08:57
> Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> added to allow a user to change ps_retrans per sock/asoc/transport, as
> other 2 paddrthlds: pf_retrans, pathmaxrxt.
> 
> Note that ps_retrans is not allowed to be greater than pf_retrans.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  1 +
>  net/sctp/socket.c         | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index a15cc28..dfd81e1 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
>  	struct sockaddr_storage spt_address;
>  	__u16 spt_pathmaxrxt;
>  	__u16 spt_pathpfthld;
> +	__u16 spt_pathcpthld;
>  };
> 
>  /*
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 5e2098b..5b9774d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,

This code does:
	if (optlen < sizeof(struct sctp_paddrthlds))
		return -EINVAL;

So adding an extra field breaks existing application binaries
that use this option.

I've not checked the other patches or similar fubar.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
