From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Sep 2009 13:45:00 +0000
Subject: Re: sctp send and recv
Message-Id: <4AB7835C.5050906@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
In-Reply-To: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

colin wen wrote:
> I wrote a simple sctp server and client to test sctp in linux.
> after client call connect, server accept return a socket,
> but after client call send(fd, "hello", 5, 0) server's recv call
> does not return, server's recv return after client close and
> re-connect to server.
> I wonder if someone could tell me what's the problem.
> Thanks,


What kernel version are you using?

Can you post the source to your client and server?

-vlad
