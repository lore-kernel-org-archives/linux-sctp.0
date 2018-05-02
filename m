From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 02 May 2018 09:06:39 +0000
Subject: non-blocking connect for kernel SCTP sockets
Message-Id: <20180502090639.j55mnclmkzdts6xb@unicorn.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Gang He <ghe@suse.com>, GuoQing Jiang <gqjiang@suse.com>

Hello,

while investigating a bug, we noticed that DLM tries to connect an SCTP
socket in non-blocking mode using

	result = sock->ops->connect(sock, (struct sockaddr *)&daddr, addr_len,
				    O_NONBLOCK);

which does not work. The reason is that inet_dgram_connect() cannot pass
its flags argument to sctp_connect() so that __sctp_connect() which does
the actual waiting resorts to checking sk->sk_socket->file->f_flags
instead. As the socket used by DLM is a kernel socket with no associated
file, it ends up blocking.

TCP doesn't suffer from this problem as for TCP, the waiting is done in
inet_stream_connect() which has the flags argument. I also checked other
proto::connect handlers and sctp_connect() seems to be the only one with
this kind of problem.

This could be worked around in DLM and further experiments indicate
current DLM code wouldn't actually handle the non-blocking connect
properly. But I still feel ignoring the flags argument is rather a trap
that should be fixed.

I have prepared a series adding flags argument to proto::connect and
using it in sctp_connect() and __sctp_connect(). But I'm not sure if
it's not too big hammer to address issue only affecting one handler.
So my question is: would such generic approach be preferred or should we
rather make SCTP work the way TCP does, i.e. move the waiting from
proto::connect() to proto_ops::connect()? This would require introducing
inet_seqpacket_connect() as inet_dgram_connect() is primarily intended
for use with UDP.)

Michal Kubecek
