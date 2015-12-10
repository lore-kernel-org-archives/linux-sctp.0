From: Fabrizio Demaria <fabrizio.f.demaria@gmail.com>
Date: Thu, 10 Dec 2015 15:49:51 +0000
Subject: Kernel crypto framework, sleeping-in-atomic issues
Message-Id: <CACzeOEegCN+pXaa6vM8QQrbRDD=iDaXOQyg=5JCUU9T6zQ5j1g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I am investigating the current usage of kernel crypto-libraries in the
SCTP code, considering to adopt the same crypto framework for the
MPTCP implementation.

In sm_make_chunk.c, the crypto function "crypto_hash_setkey" is called
in an atomic context, despite the fact that this function CAN invoke a
GFP_KERNEL (sleeping) memory allocation. Calling a sleeping function
from an atomic context can end up in deadlock. Has this factor been
considered when adding the crypto functions into the SCTP code or has
it been safely handled/verified in any way?


Thanks,
Fabrizio
