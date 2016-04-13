From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 13 Apr 2016 08:08:16 +0000
Subject: Re: uapi header mismatch with kernel ? //[PATCH] net: sctp: fix ABI through sctp_assoc_to_state help
Message-Id: <570DFE70.8090805@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CA+js23Fr8vHUZi4VnrR7OSAfOqtEK6832WsXCmVNy4W-w=kDxw@mail.gmail.com>
In-Reply-To: <CA+js23Fr8vHUZi4VnrR7OSAfOqtEK6832WsXCmVNy4W-w=kDxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Steven,

On 04/13/2016 04:39 AM, Steven Ding wrote:
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

Patch was applied and can be found here:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id8ab1fa981d543e1b00f4ffbce4ddb480cd2effe

$ git describe 38ab1fa981d543e1b00f4ffbce4ddb480cd2effe
v3.17-rc1-188-g38ab1fa

> BTW, I applied Daniel's patch with 3.14.58 and it worked well.

Cheers,
Daniel
