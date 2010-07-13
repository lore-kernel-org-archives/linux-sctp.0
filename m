From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 07:26:49 +0000
Subject: about the sctpCurrEstab MIB item
Message-Id: <4C3C1539.5030302@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The sctpCurrEstab MIB item is defined in RFC3873 as 
the number of associations for which the current state is
either ESTABLISHED, SHUTDOWN-RECEIVED or SHUTDOWN-PENDING.

So, an association for which the current state is SHUTDOWN-SENT
or SHUTDOWN-ACK-SENT should not counted in SctpCurrEstab. Right?

But, actually, the implementation of Linux is not consistent with the spec.
An association is thought as "established" with the current state of
ESTABLISHED, SHUTDOWN-RECEIVED, SHUTDOWN-PENDING. SHUTDOWN-SENT
or SHUTDOWN-ACK-SENT.

Has any reasons for this implementation?
If not, I think we should fix it.

-- 
Best Regards
-----
Shan Wei


