From: Georgios Cheimonidis <gche@kth.se>
Date: Tue, 25 May 2010 16:30:30 +0000
Subject: Source IP not corresponding to interface
Message-Id: <4BFBFB26.6050209@kth.se>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi!

I have observed a problem while doing some tests with dynamic address 
reconfiguration. Let me first describe my setup and application.

Setup: I have two hosts, one that acts as a client and another that acts 
as a server. The client has two IPv4 addresses (one on wlan, let's call 
it X, and another on a 3G p-to-p connection, let's call it Y). There are 
two default routes on the client, and the wlan default has a smaller 
metric than the 3G default. The server is single homed. All addresses 
belong to different subnets.
Both hosts are running the net-next kernel, downloaded from David 
Miller's net-next source tree on 12-May-2010). I have also applied two 
extra patches found in: (a) 
http://www.spinics.net/lists/linux-sctp/msg00881.html and 
(b)http://www.spinics.net/lists/linux-sctp/msg00882.html. I have also 
enabled SCTP debugging messages.

Application: In my simple application, only the server transmits 
messages to the client. The server uses blocking send() and the client 
uses blocking recv(). My client application has a simple policy: When IP 
address X is removed from the system, a monitoring process reports this 
event to my application.  When my application receives this event 
notification, it takes two consecutive actions. First, it calls 
sctp_bindx() to remove IP address X from the association. Immediately 
after that, it calls setsockopt(SET_PEER_PRIMARY_ADDR) to change the 
peer's (server's) primary destination to address Y. So, when I execute 
"sudo dhcpcd -k wlan0" at the client host, the server should eventually 
remove address X from its list of destination addresses and then change 
its primary (destination) address to Y. When I execute the command "sudo 
dhcpcd wlan0", and when the IP address is finally configured, my client 
application gets a notification and calls sctpbindx() to first add the 
wlan's IP address X to the association and then calls setsockopt() to 
change the peer's (server's) primary to address X. In simple words, 
whenever both (wlan and 3G) are available at the client, the client 
would like to receive packets from wlan.

In the following experiment, I start the association with the client 
having both IP addresses (address X is used for the initial handshake) 
and then I execute "sudo dhcpcd -k wlan0" and after one minute I execute 
"sudo dhcpcd wlan0". Everything is OK after removing wlan's IP address 
(which occures after executing "dhcpcd -x". A fast switchover to 3G 
interface is achieved. But after the wlan's address is configured again, 
SOMETIMES (not always!!), all subsequent packets (SACKS and ASCONFs) 
sent from the client to the server are sent from the wlan interface but 
with the 3G IP address!! The source address does not correspond to the 
wlan interface, and the wireless network router discards these packets, 
which consequently never end up to the server. I have to note that the 
first ASCONF for adding the new IP address to the association is 
correctly sent from the 3G interface using the 3G IP address. It is the 
second ASCONF (for setting peer's primary address) and all SACKs that 
are sent from wlan with wrong source IP. Also I observe a delay before 
these packets appear in the wlan interface.

I have played with rp_filter and accept_source_route options in 
/etc/sysctl.conf but I haven't observed any difference. The values that 
I used throughout most of my tests were rp_filter = 0 and 
accept_source_route = 1.

Any help will be highly appreciated. If you need the kernel log file I 
can also send it.

Thanks in advance,
George
