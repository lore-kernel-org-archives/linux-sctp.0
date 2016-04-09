From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 09 Apr 2016 15:19:44 +0000
Subject: Re: [PATCHv2 net-next 1/6] sctp: add sctp_info dump api for sctp_diag
Message-Id: <57091D90.4030905@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460177331.git.lucien.xin@gmail.com>
 <c507274a984bd1b0a7e7a59d1e825352536efd25.1460177331.git.lucien.xin@gmail.com>
 <1460178984.6473.473.camel@edumazet-glaptop3.roam.corp.google.com>
In-Reply-To: <1460178984.6473.473.camel@edumazet-glaptop3.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>, Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

On 16-04-09 01:16 AM, Eric Dumazet wrote:

>
> Lots of holes in this structure...
>
>


I may have mentioned to you that there is 8 bit hole in tcp_info too ;->
(above tcpi_rto). Adding an 8 bit explicit pad seems useful
since it is already in the wild. I was going to send the patch after
netdev11 but  forgot.

cheers,
jamal
