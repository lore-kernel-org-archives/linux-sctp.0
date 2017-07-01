From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 01 Jul 2017 17:11:05 +0000
Subject: Re: ABORT after COOKIE_ECHO
Message-Id: <20170701171105.GP18138@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
In-Reply-To: <CAFXGft+WBxm+7JK1imsP=M_go60WWHSsOurJPr=3=FZzWDShqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Sun, Jul 02, 2017 at 01:02:36AM +0800, Sun Paul wrote:
> Hi
> 
> we have a setup that running normal, however, we found that some of
> the conenctions are not able to establish and we (server) send ABORT
> right after receiving COOKIE_ECHO.
> 
> any idea?

Several reasons.. if it's not triggering a duplicate cookie processing,
it's being processed on sctp_sf_do_5_1D_ce(). Have a look at it to have
a better idea. Two reasons that stands out are somehow the cookie was
interpreted as an OOTB packet or the tcp-style listening socket got its
backlog full.

It can also be due to an out of memory situation, which is not often the
case.

OOTB packets are accounted for in netstat -s or /proc/net/sctp/snmp.

  Marcelo

