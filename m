From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 07 Mar 2019 12:11:27 +0000
Subject: Re: [PATCH net 0/3] sctp: process the error returned from sctp_sock_migrate()
Message-Id: <20190307121127.GB8030@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Sun, Mar 03, 2019 at 05:54:52PM +0800, Xin Long wrote:
> This patchset is to process the errs returned by sctp_auth_init_hmacs()
> and sctp_bind_addr_dup() from sctp_sock_migrate(). And also fix a panic
> caused by new ep->auth_hmacs was not set due to net->sctp.auth_enable
> changed by sysctl before accepting an assoc.
> 
> Xin Long (3):
>   sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
>   sctp: move up sctp_auth_init_hmacs() in sctp_endpoint_init()
>   sctp: call sctp_auth_init_hmacs() in sctp_sock_migrate()
> 
>  net/sctp/auth.c        |  6 ------
>  net/sctp/endpointola.c | 18 ++++++++++--------
>  net/sctp/socket.c      | 44 ++++++++++++++++++++++++++++++++++----------
>  3 files changed, 44 insertions(+), 24 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
