From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 25 Jun 2018 11:28:47 +0000
Subject: Re: [PATCH net-next 3/5] sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams
Message-Id: <20180625112847.GB16772@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <b63859ce9c0d5b3d69028d9aa32fd2abe9fdbbe9.1529892764.git.lucien.xin@gmail.com>
 <cover.1529892764.git.lucien.xin@gmail.com>
 <adc389159b825d29f2768c61f1428d6be9105819.1529892764.git.lucien.xin@gmail.com>
 <20180625.163126.1464757436422028440.davem@davemloft.net>
In-Reply-To: <20180625.163126.1464757436422028440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com

On Mon, Jun 25, 2018 at 04:31:26PM +0900, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 25 Jun 2018 10:14:35 +0800
> 
> >  struct sctp_paddrparams {
> > @@ -773,6 +775,8 @@ struct sctp_paddrparams {
> >  	__u32			spp_pathmtu;
> >  	__u32			spp_sackdelay;
> >  	__u32			spp_flags;
> > +	__u32			spp_ipv6_flowlabel;
> > +	__u8			spp_dscp;
> >  } __attribute__((packed, aligned(4)));
> 
> I don't think you can change the size of this structure like this.
> 
> This check in sctp_setsockopt_peer_addr_params():
> 
> 	if (optlen != sizeof(struct sctp_paddrparams))
> 		return -EINVAL;
> 
> is going to trigger in old kernels when executing programs
> built against the new struct definition.
> 
I think thats also the reason its a packed aligned attribute, it can't be
changed, or older kernels won't be able to fill it out properly.
Neil

