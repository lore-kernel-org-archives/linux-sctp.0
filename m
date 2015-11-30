From: Julien Pourtet <j.pourtet@gmail.com>
Date: Mon, 30 Nov 2015 23:41:13 +0000
Subject: Not receiving SCTP_SHUTDOWN_COMP notifications
Message-Id: <CAJRTQvywGjd87nbug80Xw0LPv0HUGSRp5zP_vu9-omHsh+kROQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I am digging up a thread from the lksctp-developers mailing list:
http://sourceforge.net/p/lksctp/mailman/message/9054592/

At the time of the post (March, 2005) it looked like
SCTP_SHUTDOWN_COMP SCTP_ASSOC_CHANGE notifications were not delivered
to the application due to too restrictive a check in
ulpqueue.c:sctp_ulpq_tail_event().

As of today, using Linux Kernel 4.4.0-rc3, I experience the same
behaviour. I am using a tweaked version of
https://github.com/tdimitrov/sctp-sandbox/blob/one-to-many_noitf/ to
reproduce the case.

Note that the server app does see SCTP_SHUTDOWN_COMP notifications.
The issue is on the client app.

My "tweak" for the client app is using a one-to-one socket
(SOCK_STREAM) instead of one-to-many. I also perform a
shutdown(SHUT_RDWR) before close() is called, as well as a recvmsg()
[get_reply() in that code base semantics] to receive the notifications
before closing the file descriptor.

Commenting out the following lines in ulpqueue.c does get the
notifications delivered to the client app:
         /* If the socket is just going to throw this away, do not
          * even try to deliver it.
          */
         if (sock_flag(sk, SOCK_DEAD) || (sk->sk_shutdown & RCV_SHUTDOWN))
                 goto out_free;

However, I guess that's not a viable solution as this may have
undesirable side-effects (I am not familiar with this code base). It
was more of a sanity check for me.

Question is, is this a bug? Should we fix it?

[Note: it's my first time writing to this ML, sorry if I am breaking
any implicit rules or explicit conventions].

Cheers,
Julien
