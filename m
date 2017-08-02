From: "Franklin Marmon" <marmon@hydeco.com>
Date: Wed, 02 Aug 2017 14:08:12 +0000
Subject: RE: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bi
Message-Id: <044b01d30b98$ca457340$5ed059c0$@hydeco.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
In-Reply-To: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In this case I waited over 20 hours. If the connections were in a "time
wait" state I would have expected to see them listed somewere, similar to a
TCP socket in time wait, or is that not the case with sctp? Additionally,
the sctp kernel driver showed 6 uses. There were 5 total "real" uses, killed
all applications on the system using sctp, the module still showed 1 use.
Force removed the kernel module and reloaded it and the binds were
successful. My suspicion is that the 6th use was a state entry in the sctp
module that was somehow holding the ports as being in use but I'm not sure
how to tell.

frm

Franklin Marmon
The Hyde Company
331 East Broadway
Missoula, MT 59801

Office: 406.541.4777
Cell: 406.493.2460
http://www.hydeco.com
marmon@hydeco.com

-----Original Message-----
From: David Laight [mailto:David.Laight@ACULAB.COM] 
Sent: Wednesday, August 2, 2017 3:09 AM
To: 'marmon@hydeco.com' <marmon@hydeco.com>; linux-sctp@vger.kernel.org
Cc: smcclain@hydeco.com; jerry@hydeco.com
Subject: RE: address already in use on previously used (but currently
unused) IP:PORT combinations in sctp_bindx()

From: Franklin Marmon
> Sent: 01 August 2017 20:44
> I'm having trouble with sctp_bindx() reporting address already in use 
> when attempting to bind sockets. The IP:PORT combinations are not 
> open, do not show up in /proc/net/sctp/assocs, netstat, ss, or lsof. 
> The IP:PORTs were bound in a previous instance of the client 
> application however that application itself has been killed and 
> restarted. It is as if the kernel believes the IP:PORT pair is in use 
> when, as far as I can tell, it isn't. If I change the ports used in my 
> addresses to ports I have not used previously the bind succeeds 
> without issue. Any suggestions on how I can tell what is holding the ports
open, or how to reset the sctp port table in the kernel?

How long are you waiting?
Possibly the old connections are in some 'time wait' state.

I've always found it necessary to specify SO_REUSADDR to make anything
restartable (although that may not help here).

	David



