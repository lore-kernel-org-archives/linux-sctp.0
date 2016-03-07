From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 07 Mar 2016 23:27:11 +0000
Subject: Re: [PATCH net] sctp: fix copying more bytes than expected in sctp_add_bind_addr
Message-Id: <56DE0E4F.3050707@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <201603080758.oSIf1B2b%fengguang.wu@intel.com>
In-Reply-To: <201603080758.oSIf1B2b%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, netdev@vger.kernel.org, dvyukov@google.com, nhorman@tuxdriver.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com, kcc@google.com, glider@google.com, sasha.levin@oracle.com, edumazet@google.com, davem@davemloft.net

Hi,

Em 07-03-2016 20:17, kbuild test robot escreveu:
> Hi Marcelo,
>
> [auto build test WARNING on net/master]
>
> url:    https://github.com/0day-ci/linux/commits/Marcelo-Ricardo-Leitner/sctp-fix-copying-more-bytes-than-expected-in-sctp_add_bind_addr/20160308-052009
>
>
> coccinelle warnings: (new ones prefixed by >>)
>
>>> net/sctp/bind_addr.c:458:42-48: ERROR: application of sizeof to pointer
>
> Please review and possibly fold the followup patch.

Oops, nice catch, thanks.

I can fold it if Dave prefers, no problem. I'll wait for a confirmation.

   Marcelo
