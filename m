From: Karl Heiss <kheiss@gmail.com>
Date: Thu, 10 Sep 2015 15:13:16 +0000
Subject: SCTP BH locking during sctp_inq_push()
Message-Id: <CAGugRbUFuhFYeEy=7e5ibgpthPsYw_4Rpa4htRf3Lmdbw3N_eA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

While looking through the code in sctp_backlog_rcv(), I noticed a case
whereby sctp_inq_push() can be called outside of a bh_lock_sock()
region if the likely case succeeds and the association has not moved.

The exact line in question:
https://github.com/torvalds/linux/blob/v4.2-rc8/net/sctp/input.c#L350

Intuitively this looks incorrect, as all other calls to
sctp_inq_push() are within a BH socket lock.  Am I missing something
obvious that allows this particular case?

Regards,
Karl
