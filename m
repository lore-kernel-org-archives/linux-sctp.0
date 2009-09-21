From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Sep 2009 18:24:41 +0000
Subject: Re: sctp send and recv
Message-Id: <4AB7C4E9.5000401@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
In-Reply-To: <a87dbce20909171629h274f02b5h28731245c0cb5ed7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

colin wen wrote:
> On Mon, Sep 21, 2009 at 6:45 AM, Vlad Yasevich
> <vladislav.yasevich@hp.com> wrote:
>> colin wen wrote:
>>> I wrote a simple sctp server and client to test sctp in linux.
>>> after client call connect, server accept return a socket,
>>> but after client call send(fd, "hello", 5, 0) server's recv call
>>> does not return, server's recv return after client close and
>>> re-connect to server.
>>> I wonder if someone could tell me what's the problem.
>>> Thanks,
>>
>> What kernel version are you using?
>>
>> Can you post the source to your client and server?
>>
>> -vlad
>>
> I am using 2.6.28-13-generic (debian-5.0) and also
> tested the kernel 2.6.31 downloaded from kernel.org.
> Please find the following test code.

Ok.  Just ran your server on a 2.6.31 kernel and it works perfectly fine.
I tried running on the same system as well as 2 different ones.

-vlad
