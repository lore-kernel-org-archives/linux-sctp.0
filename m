From: Yaogong Wang <ywang15@ncsu.edu>
Date: Thu, 03 Jun 2010 05:42:08 +0000
Subject: [PATCH 0/6] sctp: add multistream scheduling feature
Message-Id: <AANLkTin0upoLzQUG6AmYgmAc1YlvxqMkYhaKr85oK8Mm@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org

SCTP supports multistreaming. This feature solves the head-of-line
blocking problem of TCP and makes SCTP a proper transport for
signaling. However, the multistreaming feature of SCTP can be further
exploited to provide QoS scheduling among streams. This is what we
want to add in this patch.

In the current implementation, multiple streams in an SCTP association
is scheduled in a first-come-first-serve (FCFS) fashion. We would like
to augment this simple algorithm with many other scheduling algorithms
and let the application choose which scheduling they want to use. We
provide a general interface in the kernel so that different scheduling
algorithms can be implemented as kernel modules. We also extend the
SCTP socket API to include a new socket option for applications to
choose and configure the scheduling they want. This approach is
inspired by the pluggable TCP congestion control mechanism in the
Linux kernel.

An application of this feature is as follow: suppose two users are
chatting with each other over an SCTP-based instant messenger.
Meantime, they are exchanging photos. So there are two streams in this
scenario: one for instant messages and the other for photo transfer.
In the current implementation, the user cannot specify the scheduling
of the two streams so that the instant messages may be delayed by the
bulk data transfer when the available bandwidth is limited. With our
extension, the user could choose priority queue scheduling among the
streams and put instant messages on the higher priority queue. Thus,
we can prevent the previous problems and decrease the latency
experienced by the instant messages. There may be many other possible
applications of this patch since it provides a general framework to
implement many possible scheduling algorithms.

All following patches should be applied to kernel 2.6.32.8 sequentially.

--
============
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
============
