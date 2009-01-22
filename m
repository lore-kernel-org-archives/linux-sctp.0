From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 22 Jan 2009 22:36:04 +0000
Subject: [PATCH] sctp: regression bug fixes
Message-Id: <1232663768-4028-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net

David

This is a set of bug fixes that address various regressions reported to
the sctp list as well and to me privately.

Here is the list:
    1) SCTP checksum produced wrong result on big endian arch.
    2) Sometimes SCTP connection would hang withtout transmitting anything.
       Sometimes it would fail to retrnasmit after the second loss.
    3) The accept code raced with input processing resulting in locking the
       wrong socket.

Please apply and push to stable.

Thank you
-vlad
