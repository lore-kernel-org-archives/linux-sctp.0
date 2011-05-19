From: Thanh Nguyen <ht22.pt@gmail.com>
Date: Thu, 19 May 2011 17:43:53 +0000
Subject: [Question] About Multi-homing in LKSCTP
Message-Id: <1305852113.16286.9.camel@SLinux>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In LKSCTP with multi-homing, if association using 4 IP(list Ip1 Ip2 Ip3
IP4 and bandwith,delay different) and peer have 3 IP (IP5 Ip 6 Ip7 ).
When establish association, primary path is IP1-IP5, if path IP1-IP5
die, how is SCTP choose new path? (select by best bandwith and delay or
list IP).
And in RFC have sentence "Furthermore, when its peer is multi-homed, an
endpoint SHOULD try to retransmit a chunk that timed out to an active
destination transport address that is different from the last
destination address to which the DATA chunk was sent." in section 6.4
In LKSCTP use this feature or not? If not, which do LKSCTP use?

