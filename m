From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 20 Mar 2020 01:17:09 +0000
Subject: Re: general protection fault in sctp_ulpevent_nofity_peer_addr_change
Message-Id: <20200320011709.GE3756@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <00000000000074219d05a139e082@google.com>
 <00000000000041ca9305a13ea3e0@google.com>
In-Reply-To: <00000000000041ca9305a13ea3e0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+3950016bd95c2ca0377b@syzkaller.appspotmail.com>
Cc: linux-fbdev@vger.kernel.org, mareklindner@neomailbox.ch, nhorman@tuxdriver.com, b.zolnierkie@samsung.com, netdev@vger.kernel.org, vyasevich@gmail.com, b.a.t.m.a.n@lists.open-mesh.org, a@unstable.cc, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, syzkaller-bugs@googlegroups.com, lkundrak@v3.sk, linux-sctp@vger.kernel.org, sw@simonwunderlich.de, kuba@kernel.org, davem@davemloft.net

On Thu, Mar 19, 2020 at 05:48:02PM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit da2648390ce3d409218b6bbbf2386d8ddeec2265
> Author: Lubomir Rintel <lkundrak@v3.sk>
> Date:   Thu Dec 20 18:13:09 2018 +0000
> 
>     pxa168fb: trivial typo fix

Certainly not ;-)
