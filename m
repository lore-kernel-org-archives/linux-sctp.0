From: Pau Espin Pedrol <pespin@sysmocom.de>
Date: Mon, 24 Aug 2020 10:00:27 +0000
Subject: Re: SCTP multi-homed association (::1)->(::1+127.0.0.1) attempting HEARTBEAT on 127.0.0.1->127.0.0.1
Message-Id: <44227020-4061-9fc9-0175-e64de5c22e15@sysmocom.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
In-Reply-To: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Marcelo,

Between my initial message and your response I updated my kernel to
Archlinux latest package version (5.8.3-arch1-1,
https://git.archlinux.org/linux.git/), which still shows the same bug I
mentioned in my previous message.

The commit you described is already contained in the kernel (it was
included upstream during v5.8-rc3).

Moreover, the description of the commit you shared doesn't seem to match
the issue I described. The issue I explained is about the kernel trying
to create further connections on an already ongoing association using a
local IPv4 address it was never bound to; the issue has nothing to do
with advertising of addresses (advertising is working correctly here IMHO).

Quick similar scenario setup would be something like:

SERVER:
server_fd = socket(AF_INET6, SCTP, STREAM);
sctp_bindx(server_fd, "127.0.0.1", "::1");
listen(server_fd); accept(server_fd);

CLIENT:
client_fd = socket(AF_INET6, SCTP, STREAM);
sctp_bindx(client_fd, "::1");
sctp_connectx(client_fd, "::1");

And then after client connects ::1<->::1 and gains info about server's
127.0.0.1 address, it tries to INIT 127.0.0.1->127.0.0.1 despite it was
never bound to 127.0.0.1.

Regards,
Pau

-- 
- Pau Espin Pedrol <pespin@sysmocom.de>         http://www.sysmocom.de/
===================================* sysmocom - systems for mobile communications GmbH
* Alt-Moabit 93
* 10559 Berlin, Germany
* Sitz / Registered office: Berlin, HRB 134158 B
* Geschaeftsfuehrer / Managing Director: Harald Welte
