From: Holger Hans Peter Freyther <holger@freyther.de>
Date: Mon, 10 Jan 2011 10:58:08 +0000
Subject: [PATCH 0/2] Remove variables that are never read
Message-Id: <1294657090-2789-1-git-send-email-holger@freyther.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The patches remove variables that are never read and where the
assignment has no side-effect.

