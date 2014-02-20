From: Sergey Udalov <sudalov@switchray.com>
Date: Thu, 20 Feb 2014 07:33:05 +0000
Subject: bag in sctp_connectx
Message-Id: <5305AFB1.3030208@switchray.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

I am using sctp_darn with "--connectx" option and when I try to send  
any data then I get the error:
""sctp_darn: error connecting to addrs: Invalid argument.
   connectx failed."

Could you please analyze and fix the problem?

Version lksctp-tools: 1.0.16.
Version OS: 3.11-2-amd64 #1 SMP Debian 3.11.10-1 (2013-12-04) x86_64 
GNU/Linux.

Thank you in advanced.
Sergey Udalov

