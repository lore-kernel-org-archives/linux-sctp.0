From: colin wen <colinw21@gmail.com>
Date: Thu, 17 Sep 2009 23:29:50 +0000
Subject: sctp send and recv
Message-Id: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I wrote a simple sctp server and client to test sctp in linux.
after client call connect, server accept return a socket,
but after client call send(fd, "hello", 5, 0) server's recv call
does not return, server's recv return after client close and
re-connect to server.
I wonder if someone could tell me what's the problem.
Thanks,
