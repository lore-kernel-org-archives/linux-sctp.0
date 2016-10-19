From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 19 Oct 2016 16:57:54 +0000
Subject: Re: net/sctp: use-after-free in __sctp_connect
Message-Id: <20161019165754.GD2958@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAeHK+wX8yxVTpmg-Ps7MKTD-x_HS3GgpzX6yfGh51cQE0oPjA@mail.gmail.com>
In-Reply-To: <CAAeHK+wX8yxVTpmg-Ps7MKTD-x_HS3GgpzX6yfGh51cQE0oPjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>, Dmitry Vyukov <dvyukov@google.com>

On Wed, Oct 19, 2016 at 02:25:24PM +0200, Andrey Konovalov wrote:
> Hi,
> 
> I've got the following error report while running the syzkaller fuzzer:
> 
> =================================
> BUG: KASAN: use-after-free in __sctp_connect+0xabe/0xbf0 at addr
> ffff88006b1dc610

Seems this is the same that Dmitry Vyukov had reported back in Jan 13th.
So far I couldn't identify the reason.
"Good" to know it's still there, thanks for reporting it.

