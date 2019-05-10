From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 10 May 2019 11:27:18 +0000
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Message-Id: <20190510112718.GA4902@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
 <20190509113235.GA12387@hmswarspite.think-freely.org>
 <20190509.093913.1261211226773919507.davem@davemloft.net>
In-Reply-To: <20190509.093913.1261211226773919507.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com

On Thu, May 09, 2019 at 09:39:13AM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Thu, 9 May 2019 07:32:35 -0400
> 
> > This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> > instead of removing it, to use it.  We have 2 locations where we actually call
> > sctp_make_init_ack, and then have to check the return code and abort the
> > operation if we get a NULL return.  Would it be a better solution (in the sense
> > of keeping our control flow in line with how the rest of the state machine is
> > supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> > the state machine queue in the locations where we otherwise would call
> > sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?
> 
> Also, net-next is closed 8-)
> 
Details, details :)
