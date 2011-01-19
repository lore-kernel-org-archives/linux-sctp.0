From: Schoch Christian <e0326715@student.tuwien.ac.at>
Date: Wed, 19 Jan 2011 22:27:32 +0000
Subject: Inconsistency in spinfo_state between Linux and FreeBSD sctp
Message-Id: <20110119232732.1605564zwkq5jj9w@webmail.tuwien.ac.at>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I could figure a problem with spinfo_state between Linux and FreeBSD  
sctp stack.

While in linux stack the return value of spinfo_state is defined as  
enum with four items, FreeBSD defines a lot more states. The problem  
is that these values do not match with each other. For example if  
FreeBSD means INACTIVE this value in linux results in UNCONFIRMED.

In sctp socket api these states are namely defined but not assoziated  
with any value.

Is there any possibility to standardize these values ??

Regards,
Schoch Christian
