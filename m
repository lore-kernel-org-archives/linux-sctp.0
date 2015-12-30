From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 Dec 2015 20:47:32 +0000
Subject: Re: net/sctp: sock memory leak
Message-Id: <20151230204732.GA16265@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+bf9h=vVSb82Jdv2GeV1MQPg15LW_AcV2BOw-XbMfNetw@mail.gmail.com>
In-Reply-To: <CACT4Y+bf9h=vVSb82Jdv2GeV1MQPg15LW_AcV2BOw-XbMfNetw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>

On Wed, Dec 30, 2015 at 09:42:27PM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> The following program leads to a leak of two sock objects:

Damn, Dmitry ;-)
If no one takes care of it by then, I'll look into it next week, thanks.

  Marcelo
