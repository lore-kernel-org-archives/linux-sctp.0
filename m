From: "Winston V. Tizon" <wtizon@tspi.com.ph>
Date: Sat, 28 Jun 2014 11:04:35 +0000
Subject: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <20140628190435.AF72.327CAA51@tspi.com.ph>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello everyone!

We are having some issues regarding SCTP multihoming
and we would like to ask your opinion on this matter. 
We have two RHEL6.4 (2.6.32-358.el6.x86_64, lksctp-tools
-1.0.10-5(64 bit)) machines connected by two L2 switch 
and a L3 switch (please see "Environment Setup" below). 
When we execute SCTP connection (using multihoming) between 
the two machines, the following behavior occurred:

      CLIENT           L2 and L3         SERVER      
Secondary Primary           |      Primary Secondary 
    |        |              |          |       |     
    |        |              |          |       |     
    |        |INIT-INIT_ACK |          |       |     
    |        |<-------------|--------->|       |     
    |        |COOKIE_ECHO-COOKIE_ACK   |       |     
    |        |              |          |       |     
    |        |<-------------|--------->|       |     
    |        |HB/HB_ACK     |          |       |     
    |        |              |          |       |     
    |<-------|--------------|----------|       |     
    |        |              |       HB |       |     
    |        |--------------|--------->|       |     
    |        |HB_ACK        |          |       |     
    |        |        :     |          |       |     
    |        |        :     |          |       |     

INIT/INIT_ACK handshake occurred in the primary 
path of both machines which is expected. When a 
Primary path sends HEARTBEAT to another Primary, 
HEARTBEAT_ACK was returned to the sender. But 
when a Primary path sends HEARTBEAT to a 
Secondary path, the HEARTBEAT_ACK chunk was sent 
by the Primary path. We expect that the 
HEARTBEAT_ACK would come from the Secondary.

[Questions]
1. Is this a normal behavior with regards to SCTP multihoming? 
2. Is the SCTP kernel module has something to do with this behavior? 
3. Is there a solution to force Client to use its Secondary path in 
   sending the HEARTBEAT_ACK chunk to Server's primary?

Environment Setup:

    CLIENT                        SERVER     
 172.168.39.91                172.168.40.93  
 +-----------+    +------+    +-----------+  
 |       eth0|----|  L2  |----|eth0       |  
 |           |    +------+    |           |  
 |           |       |        |           |  
 |           |  +----------+  |           |  
 |           |  |    L3    |  |           |  
 |           |  +----------+  |           |  
 |           |       |        |           |  
 |           |    +------+    |           |  
 |       eth1|----|  L2  |----|eth1       |  
 +-----------+    +------+    +-----------+  
 172.168.39.92                172.168.40.94  

Route Setup:

---------- CLIENT ----------
# ip rule show
0:	from all lookup local 
197:	from all to 172.168.39.91 lookup rt2 
198:	from 172.168.39.91 lookup rt2 
199:	from all to 172.168.39.92 lookup rt3 
200:	from 172.168.39.92 lookup rt3 
32766:	from all lookup main 
32767:	from all lookup default 

# ip route show table rt2
172.168.40.0/24 dev eth0  scope link  src 172.168.39.91 
172.168.39.0/24 dev eth0  scope link  src 172.168.39.91 

# ip route show table rt3
172.168.40.0/24 dev eth1  scope link  src 172.168.39.92 
172.168.39.0/24 dev eth1  scope link  src 172.168.39.92 

# ip route show table main
192.168.40.0/24 dev eth1  proto kernel  scope link  src 192.168.40.212 

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.40.0    0.0.0.0         255.255.255.0   U     0      0        0 eth1

---------- SERVER ----------
# ip rule show
0:	from all lookup local 
197:	from all to 172.168.40.93 lookup rt2 
198:	from 172.168.40.93 lookup rt2 
199:	from all to 172.168.40.94 lookup rt3 
200:	from 172.168.40.94 lookup rt3 
32766:	from all lookup main 
32767:	from all lookup default 

# ip route show table rt2
172.168.40.0/24 dev eth0  scope link  src 172.168.40.93 
172.168.39.0/24 dev eth0  scope link  src 172.168.40.93 

# ip route show table rt3
172.168.40.0/24 dev eth1  scope link  src 172.168.40.94 
172.168.39.0/24 dev eth1  scope link  src 172.168.40.94 

# ip route show table main
192.168.40.0/24 dev eth1  proto kernel  scope link  src 192.168.40.127 

# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.40.0    0.0.0.0         255.255.255.0   U     0      0        0 eth1


We are hoping for your kind response and thank you in advance!

Wins

