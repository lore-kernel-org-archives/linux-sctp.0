From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 22 Jul 2014 13:25:06 +0000
Subject: Re: [PATCH net] net: sctp: inherit auth_capable on INIT collisions
Message-Id: <53CE6632.1060707@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1405620319-2021-1-git-send-email-dborkman@redhat.com> <53C93157.1050002@gmail.com> <53C972BE.5090700@redhat.com> <53C998DE.2030805@gmail.com>
In-Reply-To: <53C998DE.2030805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: davem@davemloft.net, jgunthorpe@obsidianresearch.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Hi Vlad,

On 07/18/2014 11:59 PM, Vlad Yasevich wrote:
...
> So I think I know why case D ends up not authenticating the COOKIE-ACK.
> Most likely the reason is the following statement:
>   repl = sctp_make_cookie_ack(new_asoc, chunk);
>
> Note that we use new_asoc, instead of current asoc.

Are you sending out a patch for this?

Thanks,

Daniel
