From: Bhaskar Dutta <bhaskie@gmail.com>
Date: Thu, 21 Jan 2010 12:21:07 +0000
Subject: Wrong IP address showing up in SCTP peer address notification for
Message-Id: <571fb4001001210409s52abed68jf3aa1ff9cdf83808@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

While testing out SCTP multihoming, I have run into an issue with the
wrong IP address showing up in the notification received from the SCTP
stack by an application.

I am using kernel 2.6.27 (SuSE 11.1 on 64-bit)

The remote end (IP-A) sends out two IP addresses (A and B) in the INIT-ACK.
I remove the network cable for A and heartbeats fail as expected.
But application receives a notification for B instead of A.
Heartbeats to B are ack'ed and can be seen in the packet traces, and
heartbeats to A are not ack'ed.

     10.214.64.100 --- INIT ---> 10.214.65.200 (A)
(A) 10.214.65.200 --- INIT-ACK ---> 10.214.64.100

INIT-ACK contains: IPv4 address params:
A - 10.214.65.200 (vlan1)
B - 10.215.65.200 (vlan2)

10.214.64.100 --- HEARTBEAT ---> 10.214.65.200 (A) - (Heartbeat fails
since ethernet wire to 10.214.65.200 is pulled out from switch)
No heartbeat-ack received from IP-A.

Application receives SCTP_PEER_ADDR_CHANGE notification with state
SCTP_ADDR_UNREACHABLE for
10.215.65.200 (B) instead of IP-A.

Any help would be appreciated.

Thanks,
Bhaskar
