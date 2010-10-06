From: "B N Srikant-A21035" <srikantbn@motorola.com>
Date: Wed, 06 Oct 2010 17:48:05 +0000
Subject: SACK is sent to wrong IP address
Message-Id: <2B7783B1E18B2C4984C3979954E10AFC07E3EAC9@ZMY16EXM67.ds.mot.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,
 
We have multihomed server (IP1, IP2) and single home client (IP3).
Initially client has established association with multi homed server.
Later the server has restarted and sent INIT. The IP1 is temporarily
inactive and IP2 is active. 
So INIT is sent from IP2 and client has sent INIT ACK back to IP2. The
Cookie and Cookie ack are also exchanged on new address.
 
But when data was sent from server (IP2) to client the client is sending
SACK to IP1 instead IP2.
As per the RFC the SACK should be sent to the address from where data is
coming. 
 
Is there any fix for this ? Or any suggestion to fix it is helpful.
 
thanks
Srikant
 
 
 
 
