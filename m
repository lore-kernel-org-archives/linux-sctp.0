From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 19:19:08 +0000
Subject: [PATCH 0/2] sctp: socket cleanups
Message-Id: <cover.1305227620.git.joe@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Size trivially reduced as well.

$ size net/sctp/socket.o
   text	   data	    bss	    dec	    hex	filename
  55720	    442	  14988	  71150	  115ee	net/sctp/socket.o.new
  55730	    442	  14996	  71168	  11600	net/sctp/socket.o.old

Joe Perches (2):
  sctp: sctp_sendmsg: Don't initialize default_sinfo
  sctp: sctp_sendmsg: Don't test known non-null sinfo

 net/sctp/socket.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

-- 
1.7.5.rc3.dirty

