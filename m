From: "Winston V. Tizon" <wtizon@tspi.com.ph>
Date: Tue, 01 Jul 2014 07:48:32 +0000
Subject: Re[2]: SCTP Multihoming Heartbeat ACK Behavior
Message-Id: <20140701154832.6400.327CAA51@tspi.com.ph>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140630165836.0FB7.327CAA51@tspi.com.ph>
In-Reply-To: <20140630165836.0FB7.327CAA51@tspi.com.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, 30 Jun 2014 08:30:20 -0400
Neil Horman <nhorman@tuxdriver.com> wrote:

> How are you determining which transport is getting used to send the HEARTBEAT
> ACK?  Are you looking at the chunks destination IP address?  Looking at
> sctp_outq_flush in RHEL6 it appears we should always use the inbound transport
> to send the response, which is the correct thing to do. Sometimes however, while
> the destination ip address is correct, funny routing tables can lead to a single
> source address getting selected.
> 
> Neil

Thanks for the reply Neil.

We've just performed test to check if Multihoming Heartbeat ACK Behavior 
I've mentioned is related to routing table configuration or 
SCTP Primary IP address setting. Please see below test information and results.

"Test case1" (Set the primary in "172.168.39.2")

[client]
# sctp_darn -H 172.168.39.2 -B 172.168.39.3 -P 9099 -h 172.168.39.4 -p 
9099 -s

[server]
# sctp_darn -H 172.168.39.4 -B 172.168.39.5 -P 9099 -l

[result]
172.168.39.2(client) 172.168.39.4(server) INIT
172.168.39.4(server) 172.168.39.2(client) INIT_ACK
172.168.39.2(client) 172.168.39.4(server) COOKIE_ECHO
172.168.39.4(server) 172.168.39.2(client) COOKIE_ACK
172.168.39.4(server) 172.168.39.2(client) HB
172.168.39.2(client) 172.168.39.4(server) HB_ACK
172.168.39.4(server) 172.168.39.3(client) HB
172.168.39.2(client) 172.168.39.4(server) HB_ACK     (***)
172.168.39.2(client) 172.168.39.4(server) DATA
172.168.39.4(server) 172.168.39.2(client) SACK


"Test case2" (Set the primary in "172.168.39.3")

[client]
# sctp_darn -H 172.168.39.3 -B 172.168.39.2 -P 9099 -h 172.168.39.4 -p 
9099 -s

[server]
# sctp_darn -H 172.168.39.4 -B 172.168.39.5 -P 9099 -l

[result]
172.168.39.3(client) 172.168.39.4(server) INIT
172.168.39.4(server) 172.168.39.3(client) INIT_ACK
172.168.39.3(client) 172.168.39.4(server) COOKIE_ECHO
172.168.39.4(server) 172.168.39.3(client) COOKIE_ACK
172.168.39.4(server) 172.168.39.3(client) HB
172.168.39.3(client) 172.168.39.4(server) HB_ACK
172.168.39.4(server) 172.168.39.2(client) HB
172.168.39.3(client) 172.168.39.4(server) HB_ACK     (***)
172.168.39.3(client) 172.168.39.4(server) DATA 
172.168.39.4(server) 172.168.39.3(client) SACK


Based on results, SCTP kernel always choose Primary IP address so I think
this is not related to routing table configuration problems. 

(***) -> Based on SCTP RFC4960, expected behavior is secondary IP address
         should be used as path in sending the HB_ACK.

Wins


