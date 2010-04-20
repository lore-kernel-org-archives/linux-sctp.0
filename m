From: "B N Srikant-A21035" <srikantbn@motorola.com>
Date: Tue, 20 Apr 2010 17:42:17 +0000
Subject: COOKEI_ACK with wrong IP for multi homing case
Message-Id: <2B7783B1E18B2C4984C3979954E10AFC078F499D@ZMY16EXM67.ds.mot.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

 
Hi,
 
We are facing some issue with COOKEI_ACK being sent to the wrong dest in
multi homing scenario. This is the scenario we are testing.
 
1. We have two sctp process running on two different machine one with
single home IP address 192.168.1.1 and other dual home with IP address
192.168.1.2 (Primary) and 192.168.1.3 (Secondary)
 
2. The process on machine1 (192.168.1.1) sends SCTP_INT to process on
192.168.1.2 and establishes the sctp association. The SCTP ack sent by
machine2 has both the primary and secondary ip address.
 
3. After some time the process at machine restarts and sends SCTP_INIT
from 192.168.1.2 (secondary ip) on existing association. The process on
machine1 reply back with INIT_ACK to 192.168.1.2.  After INIT_ACK
successful the machine2 sends COOIKE_ECHO from 192.168.1.2 but machine1
sends COOKIE_ACK to old primary address (192.168.1.1). 
 
Due to this association gets tear down later. 
 
Is this bug ? we are using 2.6.18-128.el5 kernel with cent os. We are
using default sctp provided with cent os 5.3
 
 
Appreciate your help
 
thanks
Srikant
