From: Sun Paul <paulrbk@gmail.com>
Date: Tue, 15 Dec 2015 01:13:37 +0000
Subject: Question on SACK handling in LKSCTP
Message-Id: <CAFXGftJ57SHB5Cw433JQ-xqdRVjK2euKzBe+t8i8OyN_ax5Y8A@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All

I would like to check how LKSCTP handle late arrival of SACK.

Our application is a DIAMETER based application running over SCTP, and
we found a strange behavior that if we send out DIAMETER request in a
batch, says 10 requests, the remote end point do not response at once,
and maybe after 5 secs, they response back with 10 SACKS.

If in this case, will the LKSCTP libraries wait for the SACK before
sending the new request? Or, it is actually controlled by user
application level?

Thanks

- RBK
