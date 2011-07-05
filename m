From: Max Matveev <makc@redhat.com>
Date: Tue, 05 Jul 2011 01:57:18 +0000
Subject: [PATCHv2 0/2] Minor documentation updates for ip-related tunables
Message-Id: <20110705015718.32777815DBB1@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org

Confusion about the way SCTP uses its rmem and wmem tunables
prompted a documentation revision.

v2: incorporate suggestions by Shan Wei and Neil Horman.

Max Matveev (2):
  Update description of net.sctp.sctp_rmem and net.sctp.sctp_wmem tunables
  Update documented default values for various TCP/UDP tunables

 Documentation/networking/ip-sysctl.txt |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.7.3.3

