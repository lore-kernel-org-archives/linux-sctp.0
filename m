From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 09 Apr 2016 17:23:56 +0000
Subject: Re: [PATCHv2 net-next 4/6] sctp: add the sctp_diag.c file
Message-Id: <1460222636.6473.494.camel@edumazet-glaptop3.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1460177331.git.lucien.xin@gmail.com>
	 <c507274a984bd1b0a7e7a59d1e825352536efd25.1460177331.git.lucien.xin@gmail.com>
	 <a3703f4379eeb3a385d3cc000dd621f77540608e.1460177331.git.lucien.xin@gmail.com>
	 <5408d667c2a83b8917a501b92810c82f9a66f584.1460177331.git.lucien.xin@gmail.com>
	 <ac19f4966c7df6399c2a3bfa0f7f9589b9ff536f.1460177331.git.lucien.xin@gmail.com>
	 <1460181116.6473.483.camel@edumazet-glaptop3.roam.corp.google.com>
	 <CADvbK_dZDDCpEm-RF_Zv3Xq6kvnfGnnk822cON5rUJPo-R8Y4Q@mail.gmail.com>
In-Reply-To: <CADvbK_dZDDCpEm-RF_Zv3Xq6kvnfGnnk822cON5rUJPo-R8Y4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem <davem@davemloft.net>

On Sat, 2016-04-09 at 23:40 +0800, Xin Long wrote:

> you meant we can remove it here ?
> yes, it seems similar with INET_DIAG_SKMEMINFO.
> but I do not know if userpace may use  INET_DIAG_MEMINFO now.
> 

You are adding new features here. No problem of legacy code.

Anyway, as I said you really need to reuse code, not copy paste please.


