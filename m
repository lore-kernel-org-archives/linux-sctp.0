From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 09 Apr 2016 17:31:15 +0000
Subject: Re: [PATCHv2 net-next 1/6] sctp: add sctp_info dump api for sctp_diag
Message-Id: <1460223075.6473.499.camel@edumazet-glaptop3.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460177331.git.lucien.xin@gmail.com>
	 <c507274a984bd1b0a7e7a59d1e825352536efd25.1460177331.git.lucien.xin@gmail.com>
	 <1460179179.6473.476.camel@edumazet-glaptop3.roam.corp.google.com>
	 <CADvbK_dzvjT=pFYP8uRDa8naNWUp+dkUHSVXP+Y8P0U3=nQM8g@mail.gmail.com>
In-Reply-To: <CADvbK_dzvjT=pFYP8uRDa8naNWUp+dkUHSVXP+Y8P0U3=nQM8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem <davem@davemloft.net>

On Sun, 2016-04-10 at 00:10 +0800, Xin Long wrote:

> 1. sctp_diag_dump_one -> sctp_transport_lookup_process-> sctp_tsp_dump_one
> this one just holds the tsp. and we're using  list_for_each_safe here now,
> isn't it enough ?

list_for_each_safe is 'safe' if you do a list_del() yourself.

It is not safe if other cpus are adding/deleting items in the list while
this thread is iterating it.





