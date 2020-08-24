From: Pau Espin Pedrol <pespin@sysmocom.de>
Date: Mon, 24 Aug 2020 10:33:39 +0000
Subject: Re: SCTP multi-homed association (::1)->(::1+127.0.0.1) attempting HEARTBEAT on 127.0.0.1->127.0.0.1
Message-Id: <3596ba07-a130-3aac-0be0-02cab6a1817e@sysmocom.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
In-Reply-To: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On 8/24/20 12:28 PM, Andreas Fink wrote:
> the server might tell it that it can also connect on 127.0.0.1 because
> of the advertized IPs maybe?
> 

Yes sure, that's happening, the server is advertising the 127.0.0.1 over
the conn established in ::1<->::1 because it is bound to that address
too, but that's fine imho.

The problem is the client attempting to connect to server's 127.0.0.1
despite being not bound to any IPv4 address, and specifically to 127.0.0.1.

-- 
- Pau Espin Pedrol <pespin@sysmocom.de>         http://www.sysmocom.de/
===================================* sysmocom - systems for mobile communications GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
