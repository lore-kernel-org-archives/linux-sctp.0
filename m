From: David Miller <davem@davemloft.net>
Date: Sun, 28 Oct 2018 00:03:33 +0000
Subject: Re: [PATCH] sctp: socket.c validate sprstat_policy
Message-Id: <20181027.170333.305158882844306852.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181027202026.32157-1-tomasbortoli@gmail.com>
        <cb41ca17-4bad-bd21-6938-aee960a8ba9b@gmail.com>
In-Reply-To: <cb41ca17-4bad-bd21-6938-aee960a8ba9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tomasbortoli@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Tomas Bortoli <tomasbortoli@gmail.com>
Date: Sat, 27 Oct 2018 22:43:43 +0200

> I just realized we also have to check for less than 0 indexes..

How about the fact that your original submission didn't even compile?

I hope you realized that first.
