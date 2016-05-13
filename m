From: Adam Endrodi <adam.endrodi@nokia.com>
Date: Fri, 13 May 2016 10:35:33 +0000
Subject: sctp_getpaddrs() on a SHUTDOWN association
Message-Id: <20160513103533.GH3043@timmy>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Hi there,


I've got a simple case: a multi-homed client connects to a server, then
disconnects right away.  On the server side we receive the SCTP_COMM_UP
notification and try to get the client's addresses with sctp_getpaddrs().
But since the L3 connection has been SHUTDOWN properly the function fails
with EINVAL.

Unfortunately accept(2) only returns the first address of the client.

I have a 3.13.0-37.64 generic kernel from Ubuntu, but the affected code
path seems to be the same as in kernel 4.4.

Do you happen to have an idea how to work it around and obtain the client's
addresses after the associtation has been SHUTDOWN?  I've made the client
wait a little before closing the connection, but I don't like it.

Thanks,
adam
