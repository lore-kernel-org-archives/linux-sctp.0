From: Lionel Van Bemten <lionel.van_bemten.ext@nokia.com>
Date: Thu, 18 Feb 2016 11:22:41 +0000
Subject: Handle notifications and data separately
Message-Id: <20160218112240.GG18164@devws092.be.alcatel-lucent.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I am writing a user-space layer to manage SCTP sockets and provide a
high-level API for various applications to exchange data. This layer is
responsible for handling notifications (e.g. generate traces and logs),
but I would like the data messages to be handled directly by the
application. Since notifications are delivered in-band by the SCTP
stack through recvmsg(), I have something like:

  ---------------------------------------------------------
  APP
                                  SCTP_receive()
                                        |
  --------------------------------------|------------------
  SCTP layer                            |
                     NOTIFICATION      DATA
                                \      /
                                recvmsg()
  user-space                       |
  =================|===========  kernel                           |

A trivial implementation is the following:

  int SCTP_receive(int sd, void *buf, size_t count)
  {
    do {
      len = recvmsg(sd, &msg, MSG_WAITALL);
  
      if (flags & MSG_NOTIFICATION)
        handle_sctp_notification(snp);
      else
        return len;
    } while (true);
  }

Problem is that I rely on the application to call SCTP_receive() to read
any notification. In the case of a send-only application, I never read
the notifications. So I have to decouple recvmsg() from SCTP_receive()
and do the system call in my own context. Then I have to buffer all data
messages until the application calls SCTP_receive(). This overhead I
would rather not have. Ideally I would like to go read the notifications
out-of-band, but that does not seem to be possible.

  ---------------------------------------------------------
  APP
                                  SCTP_receive()
                                        |
  --------------------------------------|------------------
  SCTP layer                            |
                 NOTIFICATION          DATA
                      |                 |
                  recvnotif()        recvmsg()
  user-space          |                 |
  ==========|=========|=========
  kernel              |                 |

Any suggestions?

Lionel
