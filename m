From: Sun Paul <paulrbk@gmail.com>
Date: Thu, 18 Jun 2015 10:20:42 +0000
Subject: NO TCB to Destory
Message-Id: <CAFXGft+hN7KOqGVWqa1xn0dKNJNarc65YYYFiLnSn7CMYarLHA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi

I suffered a case on a SCTP connection.

HOST A sends INIT chunk to HOST B
HOST B returns INIT_ACK chunk back to HOST A
HOST A sends COOKIE_ECHO chunk to HOST B
HOST B then send ABORT chunk with T-bit set to 1.

Any idea on why ABORT chunk is sent out?
