From: Karl Heiss <kheiss@gmail.com>
Date: Mon, 06 Jan 2014 16:33:57 +0000
Subject: SCTP SIOCOUTQ ioctl
Message-Id: <CAGugRbX9kWb0zDAG69tbENGzcY3vjqtigie2QXmTAuMUrN0d+Q@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Is there any reason why there is a SIOCINQ ioctl for SCTP sockets, but
SIOCOUTQ is not supported?  It seems on the surface like it should be
trivial to implement, but is there a more complex reason why it is not
present?

Regards,
Karl
