From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 25 Oct 2019 08:05:38 +0000
Subject: Re: [PATCHv3 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-Id: <CADvbK_eSJ2NhTiCqOfEG0OGgBAEyhbmT_skTgw85Uhcmb=5gdw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com> <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
 <20191025032412.GD4326@localhost.localdomain>
In-Reply-To: <20191025032412.GD4326@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem <davem@davemloft.net>, David Laight <david.laight@aculab.com>

On Fri, Oct 25, 2019 at 11:24 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Oct 14, 2019 at 02:14:46PM +0800, Xin Long wrote:
> > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > the Potentially Failed Path State", by which users can change
> > pf_expose per sock and asoc.
> >
> > v1->v2:
> >   - no change.
> > v2->v3:
> >   - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
> >   - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.
>
> Hm, why again? Please add it to the changelog, as it's an exception on
> the list below.
will do. thanks.

>
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  2 ++
> >  net/sctp/socket.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index d99b428..a190e4a 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -137,6 +137,8 @@ typedef __s32 sctp_assoc_t;
> >  #define SCTP_ASCONF_SUPPORTED        128
> >  #define SCTP_AUTH_SUPPORTED  129
> >  #define SCTP_ECN_SUPPORTED   130
> > +#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE 131
> > +#define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
> >
> >  /* PR-SCTP policies */
> >  #define SCTP_PR_SCTP_NONE    0x0000
