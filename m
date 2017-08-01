From: "Franklin Marmon" <marmon@hydeco.com>
Date: Tue, 01 Aug 2017 19:43:47 +0000
Subject: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bindx(
Message-Id: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

I'm having trouble with sctp_bindx() reporting address already in use when
attempting to bind sockets. The IP:PORT combinations are not open, do not
show up in /proc/net/sctp/assocs, netstat, ss, or lsof. The IP:PORTs were
bound in a previous instance of the client application however that
application itself has been killed and restarted. It is as if the kernel
believes the IP:PORT pair is in use when, as far as I can tell, it isn't. If
I change the ports used in my addresses to ports I have not used previously
the bind succeeds without issue. Any suggestions on how I can tell what is
holding the ports open, or how to reset the sctp port table in the kernel?

Lksctp-tools verison: 1.0.16
Kernel version: 4.4.6
IP-Family: IPv4
Number of addresses passed to sctp_bindx(): normally 2, have tested with
each address individually

frm


Franklin Marmon
The Hyde Company
331 East Broadway
Missoula, MT 59801

Office: 406.541.4777
Cell: 406.493.2460
http://www.hydeco.com
marmon@hydeco.com


