From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:13:09 +0000
Subject: [net-next-2.6 PATCH 0/6] sctp: implement IETF SCTP Stream Reconfiguration
Message-Id: <49B48945.7060707@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All

The following series of 6 patches is the implementation of IETF STREAM-RESET
draft (http://tools.ietf.org/html/draft-stewart-tsvwg-sctpstrrst-01).

With this series, we'll implement most of the draft's defines. We skip the
"deferred reset processing" on receiver side procedures for the Outgoing SSN
Reset Request Parameter. This may appear later as a patch.

I'd really appreciate people take a look and review this patches.




