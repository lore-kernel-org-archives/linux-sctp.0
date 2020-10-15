From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 15 Oct 2020 12:41:37 +0000
Subject: Re: [PATCHv3 net-next 00/16] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Message-Id: <20201015124137.GA11030@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba@kernel.org>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

On Wed, Oct 14, 2020 at 08:34:16PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Oct 2020 15:27:25 +0800 Xin Long wrote:
> > Description From the RFC:
> > 
> >    The Main Reasons:
> > 
> >    o  To allow SCTP traffic to pass through legacy NATs, which do not
> >       provide native SCTP support as specified in [BEHAVE] and
> >       [NATSUPP].
> > 
> >    o  To allow SCTP to be implemented on hosts that do not provide
> >       direct access to the IP layer.  In particular, applications can
> >       use their own SCTP implementation if the operating system does not
> >       provide one.
> 
> Marcelo, Neil - please review if you want this one to make 5.10.

On the works!

> Otherwise we can defer until after the merge window.

Probably not needed.

Thanks,
Marcelo
