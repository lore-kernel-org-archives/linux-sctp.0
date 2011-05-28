From: =?UTF-8?B?Tmd1eeG7hW4gUGjGsOG7m2MgVGjDoG5o?= <ht22.pt@gmail.com>
Date: Sat, 28 May 2011 14:44:08 +0000
Subject: [Question] Demo apps myftp
Message-Id: <4DE10A38.6000908@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In code myftp.c, function command_recv. If filename to save =NULL, fd=1

if ( filename = NULL ) fd = 1;
     else if ( (fd = 
open(filename,O_WRONLY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE)) = -1 )

When if receiver file ,Where is this endpoint will save file?
I am trying send file 300MB, but it slow (than 2 hours).And I don't know 
where myftp save this file.
