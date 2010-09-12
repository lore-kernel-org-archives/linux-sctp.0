From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:12:27 +0000
Subject: [PATCHv2 0/5] sctp: add multistream scheduling feature
Message-Id: <AANLkTi=3me5AsWLVpy7Xku_Qr2ajxJzHULnhWgSz14k=@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

SCTP supports multistreaming. It solves the head-of-line blocking
problem of TCP and makes SCTP a proper transport for signaling.
However, this feature can be further exploited to provide QoS
scheduling among multiple streams. This is what we want to add in this
patch.

In the current implementation, multiple streams in an SCTP association
are scheduled in a first-come-first-serve (FCFS) fashion. We would
like to augment this simple algorithm with many other scheduling
algorithms and let the application choose which scheduling algorithm
they want to use. We provide a multistream scheduling framework in the
kernel so that different scheduling algorithms can be implemented as
kernel modules. We also extend the SCTP socket API to include a new
socket option for applications to choose and configure the scheduling
algorithm. This approach is inspired by the pluggable TCP congestion
control mechanism in the Linux kernel.

Note that this modification doesn't change the protocol on the wire.
It only changes the internal scheduling. Therefore, it won't cause any
interoperability problem. Further, this modification doesn't change
the congestion control algorithm of SCTP. It only changes which data
chunk should be transmitted first, under the constraints of the
congestion window. Therefore, it's safe to be deployed in the
Internet.
