From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 26 Feb 2018 22:57:44 +0000
Subject: Re: [PATCH V8 2/4] sctp: Add ip option support
Message-Id: <20180226225744.GK4375@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180224161851.29712-1-richard_c_haines@btinternet.com>
	<CAHC9VhQrNjdtujiazYyM9n535ov1QHZ_b7=u4f-kiYCJE-=YVw@mail.gmail.com>
In-Reply-To: <CAHC9VhQrNjdtujiazYyM9n535ov1QHZ_b7=u4f-kiYCJE-=YVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Mon, Feb 26, 2018 at 05:48:48PM -0500, Paul Moore wrote:
> On Sat, Feb 24, 2018 at 11:18 AM, Richard Haines
> <richard_c_haines@btinternet.com> wrote:
> > Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
> > and CALIPSO/IPv6 services.
> >
> > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > ---
> > All SCTP lksctp-tools/src/func_tests run correctly in enforcing mode.
> > All "./sctp-tests run" obtained from: https://github.com/sctp/sctp-tests
> > pass.
> >
> > V7 Changes:
> > 1) Log when copy ip options fail for IPv4 and IPv6
> > 2) Correct sctp_setsockopt_maxseg() function. Note that the lksctp-tools
> > func_tests do not test with struct sctp_assoc_value. Just used simple test
> > and okay.
> > 3) Move calculation of overheads to sctp_packet_config().
> > NOTE: Initially in sctp_packet_reset() I set packet->size and
> > packet->overhead to zero (as it is a reset). This was okay for all the
> > lksctp-tools function tests, however when running "sctp-tests" ndatshched
> > tests it causes these to fail with an st_s.log entry of:
> >         sid: 3, expected: 3
> >         sid: 3, expected: 3
> >         unexpected sid packet !!!
> >         sid: 1, expected: 3
> >
> > I then found sctp_packet_transmit() relies on setting
> > "packet->size = packet->overhead;" to reset size to the current overhead
> > after sending packets, hence the comment in sctp_packet_reset()
> >
> > V8 Change:
> > Fix sparse warning:
> > net/sctp/protocol.c:269:28: sparse: dereference of noderef expression
> > highlighted in [1] for sctp_v4_ip_options_len() function.
> >
> > [1] https://lists.01.org/pipermail/kbuild-all/2018-February/043695.html
> >
> >  include/net/sctp/sctp.h    |  4 +++-
> >  include/net/sctp/structs.h |  2 ++
> >  net/sctp/chunk.c           | 10 +++++++---
> >  net/sctp/ipv6.c            | 45 ++++++++++++++++++++++++++++++++++++++-------
> >  net/sctp/output.c          | 34 +++++++++++++++++++++-------------
> >  net/sctp/protocol.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
> >  net/sctp/socket.c          | 11 ++++++++---
> >  7 files changed, 122 insertions(+), 27 deletions(-)
> 
> Thanks Richard.
> 
> Neil and Marcelo, I transfered your acked-by to this patch, if you've
> got any objections to that please let me know.

That's fine by me. Thanks

  Marcelo
