From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 13 Apr 2016 08:08:29 +0000
Subject: Re: uapi header mismatch with kernel ? //[PATCH] net: sctp: fix ABI through sctp_assoc_to_state help
Message-Id: <570DFE7D.5010603@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CA+js23Fr8vHUZi4VnrR7OSAfOqtEK6832WsXCmVNy4W-w=kDxw@mail.gmail.com>
In-Reply-To: <CA+js23Fr8vHUZi4VnrR7OSAfOqtEK6832WsXCmVNy4W-w=kDxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

Le 13/04/2016 04:39, Steven Ding a =C3=A9crit :
> Hi All,
>
> This is Steven DING working with sooqing (sooqing@gmail.com).
>
> He ever contacted in the year 2014 for the Linux kernel 3.x issue
> where the SCTP states definition differ between kernel space and user
> space. Daniel Borkmann confirmed the issue and provided a private fix
> for it. He also planned to submit to the kernel later.
>
> Now I'm using Debian kernel 3.2.0-4-amd64, and it seems the issue is still
> there. I looked up the branches 3.14.x and I failed to find the fix.
> So I'm not sure whether the fix has been in the Linux kernel, or which
> load has the fix,
> or probably I just missed it somewhere? Could anyone help me?
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id8a=
b1fa981d5

$ git describe --contains 38ab1fa981d5
v3.17-rc5~41^2~34

=3D> patch has been included in v3.17.


Regards,
Nicolas
