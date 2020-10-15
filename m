From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 15 Oct 2020 03:34:16 +0000
Subject: Re: [PATCHv3 net-next 00/16] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Message-Id: <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

On Tue, 13 Oct 2020 15:27:25 +0800 Xin Long wrote:
> Description From the RFC:
> 
>    The Main Reasons:
> 
>    o  To allow SCTP traffic to pass through legacy NATs, which do not
>       provide native SCTP support as specified in [BEHAVE] and
>       [NATSUPP].
> 
>    o  To allow SCTP to be implemented on hosts that do not provide
>       direct access to the IP layer.  In particular, applications can
>       use their own SCTP implementation if the operating system does not
>       provide one.

Marcelo, Neil - please review if you want this one to make 5.10.

Otherwise we can defer until after the merge window.
