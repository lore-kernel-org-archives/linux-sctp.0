From: David Miller <davem@davemloft.net>
Date: Fri, 20 Jan 2017 19:00:34 +0000
Subject: Re: [PATCHv4 net-next 3/5] sctp: implement sender-side procedures for SSN/TSN Reset Request Paramete
Message-Id: <20170120.140034.1018095629148946810.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1484934853.git.lucien.xin@gmail.com>
        <ae54d06e442d8fba6a5983fb81fb4c8ae4bee3ef.1484934853.git.lucien.xin@gmail.com>
        <20170120182521.GV3781@localhost.localdomain>
In-Reply-To: <20170120182521.GV3781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Jan 2017 16:25:22 -0200

> I talked offline with Xin about this and we cannot do it this way.
> Unfortunatelly we will have to take the long road here, because then
> we may send data while sending the request, as the streams are not
> closed yet.  We really need to close team, send the request, and
> re-open if the send fails.

I am expecting another spin of this series, correct?
