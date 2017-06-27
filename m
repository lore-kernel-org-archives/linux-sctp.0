From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 27 Jun 2017 11:48:57 +0000
Subject: Re: sctp send socket buffer overflow
Message-Id: <CADvbK_eawMZNg6HStRo0RTmJA_TcEM02Mtfvj+bDLdenUXr3qQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftJgaHT8SvinLm4NVyonDJBf1nq4TWHb7b0mOA5j2caoGg@mail.gmail.com>
In-Reply-To: <CAFXGftJgaHT8SvinLm4NVyonDJBf1nq4TWHb7b0mOA5j2caoGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jun 27, 2017 at 2:28 PM, Sun Paul <paulrbk@gmail.com> wrote:
> Hi
>
> I am referring to an old thread "sctp send socket buffer overflow"
> which iss asking about how to monitor the send/receive socket buffer
> and if there is any socket buffer overflow happening.there is any
> socket buffer overflow happen.
> (https://sourceforge.net/p/lksctp/mailman/message/25545174/)
>
> the last update is there may be a patch, is it possible to direct me
> whether this is already include in the release? if yes, which one
> should I referring to?
by now, I didn't see any interface for this, but sctp_diag's dump_one
api can be faster than 'cat /proc/net/sctp/assocs' and 'ss --sctp',
but you need to write netlink socket to dump it with laddr + lport +
daddr + dport.

But yes,  Vlad may have some patch for exactly what you want.


>
> Thanks
>
> - RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
