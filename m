From: "Leppanen, Jere (Nokia - FI/Espoo)" <jere.leppanen@nokia.com>
Date: Thu, 20 Feb 2020 09:18:20 +0000
Subject: Problems with peeled-off sockets
Message-Id: <HE1PR0702MB36104FDAA4369769A3A69704EC100@HE1PR0702MB3610.eurprd07.prod.outlook.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello All,

According to the RFC, a peeled-off socket is a one-to-one socket. But in lksctp a peeled-off socket it not TCP style, it's UDP_HIGH_BANDWIDTH style. Because of this, shutdown() doesn't work, linger probably doesn't work, and so on.

For example, in sctp_shutdown():

static void sctp_shutdown(struct sock *sk, int how)
{
        struct net *net = sock_net(sk);
        struct sctp_endpoint *ep;

        if (!sctp_style(sk, TCP))
                return;

Here we just bail out, because a peeled-off socket is not TCP style.

Is this just a bug, or am I missing something? Asking mostly out of personal curiosity.
