From: Al Gambardella <agam.email@gmail.com>
Date: Wed, 05 Oct 2016 15:33:24 +0000
Subject: 64000 simultaneous connections
Message-Id: <CADz2ZUCDHyskrezX4mqFgnzHXZD3i=tC3MFXapDaEZniacyJBg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Is there a how-to on what linux parameters and resources to check and
or modify to support 64000 simultaneous SCTP connections.

Its for a load test scenario. Each connection would only have to
exchange one message with the remote side then just do keep alives.
