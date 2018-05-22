From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 22 May 2018 12:54:33 +0000
Subject: Re: missing includes?
Message-Id: <20180522125433.GD5489@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <09F4AF7E-1095-4F96-B499-4E347218DECD@list.fink.org>
In-Reply-To: <09F4AF7E-1095-4F96-B499-4E347218DECD@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, May 22, 2018 at 09:42:08AM +0200, Andreas Fink wrote:
> 
> 
> > On 22 May 2018, at 09:22, Xin Long <lucien.xin@gmail.com> wrote:
> > 
> > On Tue, May 22, 2018 at 2:23 PM, Andreas Fink <afink@list.fink.org> wrote:
> >> On Debian9 Stretch
> >> 
> >> the
> >>                 struct sctp_sndinfo  send_info;
> >> 
> >> seems not to be defined in
> >> 
> >>        netinet/sctp.h
> >> 
> >> it seems however be defined in
> >> 
> >>        linux/sctp.h
> >> 
> >> but including both headers results in tons of redefinitions.
> >> 
> >> Also the definition of sctp_sendv is not found anywhere.
> >> 
> >> 
> >> Whats the proper approach to use sctp_sndinfo for sctp_sendv()  in this case?
> > Normally, you should use netinet/sctp.h, which is from lksctp-tools and
> > copying from linux/sctp.h to make the header file for the released kernel
> > consistent with the uapi in lksctp-tools.
> > 
> > But if you update the kernel manually, the lksctp-tools should also be
> > updated. if Debian doesn't provide the newer version lksctp-tools, you
> > can go to upstream and build one:
> > https://github.com/sctp/lksctp-tools.git
> > 
> > BTW, sctp_sendv/recvv are supported since kernel 4.16, before
> > using it, make sure your kernel version is above 4.16.
> 
> Ok debian comes with Kernel 4.9. That explains things.
> So I have to do use the old calls under Linux.

Amending, "... use the old calls under old Linux." :-)

  Marcelo
