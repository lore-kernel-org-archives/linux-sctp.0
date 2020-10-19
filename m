From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Oct 2020 22:15:45 +0000
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-Id: <20201019221545.GD11030@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
>  
>  	Default: 1
>  
> +udp_port - INTEGER

Need to be more verbose here, and also mention the RFC.

> +	The listening port for the local UDP tunneling sock.
        , shared by all applications in the same net namespace.
> +	UDP encapsulation will be disabled when it's set to 0.

	"Note, however, that setting just this is not enough to actually
	use it. ..."

> +
> +	Default: 9899
> +
>  encap_port - INTEGER
>  	The default remote UDP encapsalution port.
>  	When UDP tunneling is enabled, this global value is used to set

When is it enabled, which conditions are needed? Maybe it can be
explained only in the one above.
