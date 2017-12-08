From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Dec 2017 14:06:04 +0000
Subject: RE: [PATCHv2 net-next 04/12] sctp: implement make_datafrag for sctp_stream_interleave
Message-Id: <2ca21c61e82a44daa29226eac54a4950@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Xin Long' <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

From: Xin Long
> Sent: 08 December 2017 13:04
...
> @@ -264,8 +264,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  				frag |= SCTP_DATA_SACK_IMM;
>  		}
> 
> -		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag,
> -						 0, GFP_KERNEL);
> +		chunk = asoc->stream.si->make_datafrag(asoc, sinfo, len, frag,
> +						       GFP_KERNEL);

I know that none of the sctp code is very optimised, but that indirect
call is going to be horrid.

	David

