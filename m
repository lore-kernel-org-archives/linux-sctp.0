From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 04:08:24 +0000
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port is set
Message-Id: <20201003040824.GG70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com>
In-Reply-To: <202009300218.2AcHEN0L-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <lkp@intel.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, kbuild-all@lists.01.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> Hi Xin,
> 
> Thank you for the patch! Yet something to improve:

I wonder how are you planning to fix this. It is quite entangled.
This is not performance critical. Maybe the cleanest way out is to
move it to a .c file.

Adding a
#if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
in there doesn't seem good.

>    In file included from include/net/sctp/checksum.h:27,
>                     from net/netfilter/nf_nat_proto.c:16:
>    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
>      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
>          |                               ^~~~
>          |                               ct
> 
