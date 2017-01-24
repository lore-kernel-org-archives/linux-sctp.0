From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 24 Jan 2017 10:50:07 +0000
Subject: Re: [patch net-next] sctp: fix some debug output
Message-Id: <20170124105007.GF4201@mwanda>
List-Id: <linux-sctp.vger.kernel.org>
References: <20170124090540.GA27652@mwanda>
 <20170124091411.GE3781@localhost.localdomain>
In-Reply-To: <20170124091411.GE3781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org, Colin King <colin.king@canonical.com>

On Tue, Jan 24, 2017 at 07:14:11AM -0200, Marcelo Ricardo Leitner wrote:
> On Tue, Jan 24, 2017 at 12:05:40PM +0300, Dan Carpenter wrote:
> > We added SCTP_EVENT_TIMEOUT_RECONF but we didn't update this array so
> > it causes an off-by-one read overflow.
> > 
> > Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Weird, seems your patch is missing the --- marker here.

Are there tools that require the --- marker?  I normally leave it out
when it's not required.

regards,
dan carpenter

