From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 10 Aug 2015 08:36:01 +0000
Subject: DF flag on LKSCTP
Message-Id: <CAFXGft++VpN+uF6C9YT7z3cYYQoOmQgOz0Eo5Xj7_=625wA9QA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi

is there a way to configuration to configure the IPv4 "Don't Fragment"
aligned with the system variable net.ipv4.ip_no_pmtu_disc?

from the testing so far, the DF always set to 1 for those SCTP packet
generated from LKSCTP.

- paul
