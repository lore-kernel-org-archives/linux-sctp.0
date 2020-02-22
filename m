From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 22 Feb 2020 06:55:50 +0000
Subject: Re: Problems with peeled-off sockets
Message-Id: <CADvbK_cmZdbVxpjxuXKaqyjTBSXsRUovxAAxC4syWnmu6Y+9yA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <HE1PR0702MB36104FDAA4369769A3A69704EC100@HE1PR0702MB3610.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB36104FDAA4369769A3A69704EC100@HE1PR0702MB3610.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Feb 20, 2020 at 5:18 PM Leppanen, Jere (Nokia - FI/Espoo)
<jere.leppanen@nokia.com> wrote:
>
> Hello All,
>
> According to the RFC, a peeled-off socket is a one-to-one socket. But in lksctp a peeled-off socket it not TCP style, it's UDP_HIGH_BANDWIDTH style. Because of this, shutdown() doesn't work, linger probably doesn't work, and so on.
>
> For example, in sctp_shutdown():
>
> static void sctp_shutdown(struct sock *sk, int how)
> {
>         struct net *net = sock_net(sk);
>         struct sctp_endpoint *ep;
>
>         if (!sctp_style(sk, TCP))
>                 return;
>
> Here we just bail out, because a peeled-off socket is not TCP style.
>
> Is this just a bug, or am I missing something? Asking mostly out of personal curiosity.
I would say, it's because .shutdown is tcp_prot thing and udp_prot doesn't
have. sctp doesn't have to implement it for UDP style socket. But for TCP-
style socket, sctp is trying to be compatible with TCP protocol user API.
But even though,  sctp's .shutdown is still not fully compatible with TCP
protocol due to sctp's 3-way shakehands for finishing a connection.
