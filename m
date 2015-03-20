From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Fri, 20 Mar 2015 02:15:28 +0000
Subject: modprobe sctp error
Message-Id: <CAAyB5cLYfj24-+fGiZtGWa3Ae=c2=xpz2=3Ok3s=iMGxu5Abcw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello everyone,

We had another problem today, where modprobe shows an error in
/var/log/message when we ran an sctp application:

modprobe: FATAL: Error inserting sctp
(/lib/modules/2.6.32.12-0.7-default/kernel/net/sctp/sctp.ko): Invalid
argument

I'm wondering what might be possible causes of this and how should we
bypass this.... Appreciate any comments and suggestions.

Regards,
Jerry
