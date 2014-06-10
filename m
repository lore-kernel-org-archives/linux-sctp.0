From: Xufeng Zhang <xufengzhang.main@gmail.com>
Date: Tue, 10 Jun 2014 06:27:07 +0000
Subject: sctp bug: sk_ack_backlog wrap-around problem
Message-Id: <CA+=dFzg6gXDTXr6AusZ40_swrjQa-yoS1YLv3=SJAjKYgKzrbQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp <linux-sctp@vger.kernel.org>, netdev <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, xufeng zhang <xufeng.zhang@windriver.com>

Hi Vlad and Neil,

I found a sk_ack_backlog wrap-around problem during handling received
COOKIE_ECHO.

Consider the scenario:
For a TCP-style socket, while processing the COOKIE_ECHO chunk in
sctp_sf_do_5_1D_ce(),
after it has passed a series of sanity check, a new association would
be created in
sctp_unpack_cookie(), but afterwards, some processing maybe failed,
and sctp_association_free()
will be called to free the previously allocated association, in
sctp_association_free(),
sk_ack_backlog value is decremented for this socket, since the initial
value for sk_ack_backlog is 0,
after the decrement, it will be 65535, a wrap-around problem happens,
and if we want to establish
new associations afterward in the same socket, ABORT would be
triggered since sctp deem the
accept queue as full.

Do you have any idea to fix such kind of issue?

Thanks a lot!
Xufeng
