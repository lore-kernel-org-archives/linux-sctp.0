From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Oct 2020 22:14:29 +0000
Subject: Re: [PATCHv4 net-next 07/16] sctp: add encap_port for netns sock asoc and transport
Message-Id: <20201019221429.GC11030@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

On Mon, Oct 19, 2020 at 08:25:24PM +0800, Xin Long wrote:
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2640,6 +2640,15 @@ addr_scope_policy - INTEGER
>  
>  	Default: 1
>  
> +encap_port - INTEGER
> +	The default remote UDP encapsalution port.
                                     ^^^ typo

> +	When UDP tunneling is enabled, this global value is used to set
> +	the dest port for the udp header of outgoing packets by default.
                              ^^^ uppercase as well
> +	Users can also change the value for each sock/asoc/transport by
> +	using setsockopt.

Please also add something like:
	For further information, please refer to RFC6951.

> +
> +	Default: 0
> +
