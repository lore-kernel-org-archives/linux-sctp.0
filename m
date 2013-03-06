From: Jon Leighton <leighton@cis.udel.edu>
Date: Wed, 06 Mar 2013 17:14:37 +0000
Subject: sctp client not binding to all available addresses
Message-Id: <5137797D.3000706@cis.udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I'm almost certain that calling connect() on an unbound socket used to 
result in an INIT being sent with all available IP addresses advertised, 
but that's not happening with the code I'm running right now. Has there 
been a change in the default behaviour, or do I misremember it? Thanks.

- Jon
