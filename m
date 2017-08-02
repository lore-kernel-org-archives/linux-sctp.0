From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 02 Aug 2017 09:08:33 +0000
Subject: RE: address already in use on previously used (but currently unused) IP:PORT combinations in sctp_bi
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DD0048E5E@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
In-Reply-To: <0bbe01d30afe$80ce96f0$826bc4d0$@hydeco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Franklin Marmon
> Sent: 01 August 2017 20:44
> I'm having trouble with sctp_bindx() reporting address already in use when
> attempting to bind sockets. The IP:PORT combinations are not open, do not
> show up in /proc/net/sctp/assocs, netstat, ss, or lsof. The IP:PORTs were
> bound in a previous instance of the client application however that
> application itself has been killed and restarted. It is as if the kernel
> believes the IP:PORT pair is in use when, as far as I can tell, it isn't. If
> I change the ports used in my addresses to ports I have not used previously
> the bind succeeds without issue. Any suggestions on how I can tell what is
> holding the ports open, or how to reset the sctp port table in the kernel?

How long are you waiting?
Possibly the old connections are in some 'time wait' state.

I've always found it necessary to specify SO_REUSADDR to make anything
restartable (although that may not help here).

	David

