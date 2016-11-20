From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 20 Nov 2016 17:22:56 +0000
Subject: Re: Adding SCTP_SENDALL support
Message-Id: <CADvbK_c1ZRAK0BPZ9b4gQ06utsZoQpu9QWVBdgE1B_C723xfuA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <87vavii953.fsf@shlevy-laptop.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87vavii953.fsf@shlevy-laptop.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Sun, Nov 20, 2016 at 9:16 PM, Shea Levy <shea@shealevy.com> wrote:
> Hi all,
>
> I'd like to add SCTP_SENDALL support to the kernel and lksctp-tools to
> port a FreeBSD project to Linux. Does anyone have pointers on where to
> get started or who to talk to about this? Is there any reason it's not
> already implemented besides just no one doing the work yet?
SCTP_SENDALL is also an api from rfc6458, I think it's just not yet
done in Linux.

I guess you have to do some adjustments in sctp_sendmsg, considering
there is no sctp_iterator_work unlike in BSD.

I don't think we need to add some things in lkscp-tools to support this,
as long as we update uapi sctp.h in our system.
