From: xiong wei <xiongwei@skyge.com>
Date: Thu, 15 Aug 2013 10:25:11 +0000
Subject: one-to-many question
Message-Id: <520CAC87.5020402@skyge.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi, experts

For one-to-many mode. Suppose I have a socket which contain several
associations in it. that means there are several clients connect with
server.

If I use sendmsg(...) function to send msg from server, How does sctp
identify which association will receive the data? Does all clients will
receive the msg?

And, Does sctp provide a way for server to send msg to all associations
in one syscall ?

Thanks.
