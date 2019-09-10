From: David Miller <davem@davemloft.net>
Date: Tue, 10 Sep 2019 17:27:55 +0000
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <20190910.192755.717621354475214603.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
        <cover.1568015756.git.lucien.xin@gmail.com>
        <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Sep 2019 15:56:51 +0800

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

As pointed out you can't add things to this structure without breaking existing
binaries.
