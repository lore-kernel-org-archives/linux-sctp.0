From: Ian Coolidge <icoolidge@google.com>
Date: Sat, 31 Oct 2015 00:03:07 +0000
Subject: Max.Init.Retransmits and ABORT response to INIT
Message-Id: <CAB3A_j95dYXpM9bd1vuSo-1mOjtpwauoxQCcBZLmpFywBmmPMA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

With the Linux SCTP implementation, Max.Init.Retransmits is respected
when INIT messages do not receive a response (ie, if SCTP host is
unavailable). However, if a Linux SCTP host is accessible, but has no
SCTP servers listening for incoming connections, it will quickly reply
ABORT. This doesn't trigger the Max.Init.Retransmits logic, so,
retries occur indefinitely.

I looked through RFC 2960 for some guidance here. Both 3.3.7 and 4
were unclear for how this should be handled. I suspect that these
ABORT responses to INIT should count towards Max.Init.Retransmits.

Is there any clarification that I haven't found?

What do the SCTP experts think should happen here?

Thanks
Ian
