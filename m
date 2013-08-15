From: Daniel Borkmann <borkmann@iogearbox.net>
Date: Thu, 15 Aug 2013 10:18:46 +0000
Subject: Fwd: [Lksctp-developers] one-to-many question
Message-Id: <520CAB06.4040400@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

(Please use linux-sctp@vger.kernel.org for posting SCTP questions.)

-------- Original Message --------
Subject: [Lksctp-developers] one-to-many question
Date: Thu, 15 Aug 2013 16:21:23 +0800
From: xiong wei <xiongwei@skyge.com>
To: Daniel Borkmann <dborkman@redhat.com>
CC: lksctp-developers@lists.sourceforge.net

Hi, Daniel.

For one-to-many mode. Suppose I have a socket which contain several
associations in it. that means there are several clients connect with
server.

If I use sendmsg(...) function to send msg from server, How does sctp
identify which association will receive the data? Does all clients will
receive the msg?

And, Does sctp provide a way for server to send msg to all associations
in one syscall ?

Thanks.
