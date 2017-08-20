From: Simon Arlott <simon@fire.lp0.eu>
Date: Sun, 20 Aug 2017 16:36:53 +0000
Subject: SOCK_STREAM and EPOLLET
Message-Id: <1ae8a030-75d2-7cd0-8feb-8556e66833fd@simon.arlott.org.uk>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

According to epoll(7):
       Q9  Do I need to continuously read/write a file descriptor until
           EAGAIN when using the EPOLLET flag (edge-triggered behavior) ?

       A9  For  stream-oriented files (e.g., pipe, FIFO, stream socket),
           the condition that the read/write I/O space is exhausted can
           also be detected by checking the amount of data read from /
           written to the target file descriptor.

However, if the remote end of a socket(PF_INET6, SOCK_STREAM,
IPPROTO_SCTP) is making multiple send() calls with 1 byte of data (and
has NODELAY enabled), then a recv() call only returns 1 byte of data at
a time even if there is more data available.

I'd expect a stream socket to return all the available data. Either the
behaviour of recv() is wrong or the advice in epoll(7) is incorrect for
SCTP sockets.

-- 
Simon Arlott
