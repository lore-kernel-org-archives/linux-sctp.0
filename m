From: George Cheimonidis <gchimon@gmail.com>
Date: Mon, 12 Apr 2010 16:08:52 +0000
Subject: Adding a new IP address to an association when all addresses currently
Message-Id: <4BC34594.60808@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi again!

I am working with the dynamic address reconfiguration features of SCTP. 
I have a single client - server application. Both client and server apps 
are running on Ubuntu 9.10 (kernel 2.6.31).
Initially, the client has only one IPv4 address (on wlan interface) and 
it initiates an association to the server which also has only one IPv4 
address (213.xxx.yyy.vvv). After some time, I bring down the IP address 
of the client. Then, after some seconds I bring up the ethernet 
interface of the client and try to add the ethernet's IPv4 address 
(213.xxx.yyy.zzz) to the association (using sctp_bindx()) and set the 
same address as the peer's primary (using 
setsockopt(SCTP_SET_PEER_PRIMARY_ADDR)). Even though both calls succeed 
on the client and also when I call sctp_getladdrs() I can see both 
addresses on the client's side (wlan's and ethernet's), I don't see any 
ASCONF chunks being sent and consequently the communication between the 
client and the server is not possible.
My question is: Is the LKSCTP implementation capable of handling this 
scenario, I mean trying to add a new IP address to the association using 
as source IP address of the IP packet containing the ASCONF chunk the 
new IP address being added? According to RFC5061 - paragraph 5.3.2, this 
can be feasible given that the IP address included in the Address 
Parameter field of the ASCONF chunk belongs to the association (in my 
scenario it should be the wlan's IP address). If so, then what could be 
the reason for the packet containing the ASCONF chunk not being sent?

I have enabled SCTP debugging in the kernel and I am able to see the 
following lines in /var/log/kern.log when trying to add the new IP 
address (of ethernet interface) to the association:

Apr 12 16:27:54 george-laptop kernel: [23765.692896] 
sctp_setsocktopt_bindx: sk f1069a40 addrs 08ff2368 addrs_size 16 opt 1
Apr 12 16:27:54 george-laptop kernel: [23765.692904] sctp_bindx_add (sk: 
f1069a40, addrs: f3349be0, addrcnt: 1)
Apr 12 16:27:54 george-laptop kernel: [23765.692912] sctp_do_bind(sk: 
f1069a40, new addr: 213.xxx.yyy.zzz, port: 47053, new port: 47053, len: 16)
Apr 12 16:27:54 george-laptop kernel: [23765.692920] sctp_get_port() 
begins, snumG053
Apr 12 16:27:54 george-laptop kernel: [23765.692924] sctp_get_port() 
found a possible match
Apr 12 16:27:54 george-laptop kernel: [23765.692930] 
sctp_send_asconf_add_ip: (sk: f1069a40, addrs: f3349be0, addrcnt: 1)
Apr 12 16:27:54 george-laptop kernel: [23765.692943] sctp_do_sm prefn: 
ep f2273500, EVENT_T_PRIMITIVE, PRIMITIVE_ASCONF, asoc 
c31f4000[STATE_ESTABLISHED], sctp_sf_do_prm_asconf
Apr 12 16:27:54 george-laptop kernel: [23765.692949] sctp_do_sm postfn: 
asoc c31f4000, status: DISPOSITION_CONSUME
Apr 12 16:27:54 george-laptop kernel: [23765.692958] 
sctp_outq_tail(c31f4470, f26d9e40[ASCONF])
Apr 12 16:27:54 george-laptop kernel: [23765.692964] sctp_packet_config: 
packet:eff04318 vtag:0x5246ae45
Apr 12 16:27:54 george-laptop kernel: [23765.692969] 
sctp_packet_transmit_chunk: packet:eff04318 chunk:f26d9e40
Apr 12 16:27:54 george-laptop kernel: [23765.692974] 
sctp_packet_append_chunk: packet:eff04318 chunk:f26d9e40
Apr 12 16:27:54 george-laptop kernel: [23765.692980] 
sctp_packet_append_chunk: packet:eff04318 chunk:f26d9600
Apr 12 16:27:54 george-laptop kernel: [23765.692985] 
sctp_packet_transmit: packet:eff04318
Apr 12 16:27:54 george-laptop kernel: [23765.692992] sctp_v4_get_dst: 
DST:213.xxx.yyy.vvv, SRC:0.0.0.0 -
Apr 12 16:27:54 george-laptop kernel: [23765.693015] NO ROUTE
Apr 12 16:27:54 george-laptop kernel: [23765.693021] 
sctp_assoc_sync_pmtu: asoc:c31f4000, pmtu:1500, frag_point:1432
Apr 12 16:27:54 george-laptop kernel: [23765.693028] sctp_do_sm post 
sfx: error 0, asoc c31f4000[STATE_ESTABLISHED]

Thanks in advance
George
