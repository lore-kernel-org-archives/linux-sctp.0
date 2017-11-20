From: Paul Moore <paul@paul-moore.com>
Date: Mon, 20 Nov 2017 21:55:33 +0000
Subject: Re: [RFC PATCH 5/5] selinux: Add SCTP support
Message-Id: <CAHC9VhT2g4FXkjzz+DnMhahFx_gHDUg6jTzK9qzVQdKmc7LHqg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017135953.4419-1-richard_c_haines@btinternet.com>
	<CAHC9VhShAjQiw-P5vvuULbEZJ7KYHch5ZsnRk=d9vP5kyDvYzQ@mail.gmail.com>
	<1510610721.3652.8.camel@btinternet.com>
	<CAHC9VhRg9xS=ustdcORVPsb9H18nMEq6A99Y3KyOm2sm6Mo5xg@mail.gmail.com>
	<1510696377.2564.24.camel@btinternet.com>
In-Reply-To: <1510696377.2564.24.camel@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, Nov 14, 2017 at 4:52 PM, Richard Haines
<richard_c_haines@btinternet.com> wrote:
> On Mon, 2017-11-13 at 17:40 -0500, Paul Moore wrote:
>> On Mon, Nov 13, 2017 at 5:05 PM, Richard Haines
>> <richard_c_haines@btinternet.com> wrote:
>> > On Mon, 2017-11-06 at 19:09 -0500, Paul Moore wrote:
>> > > On Tue, Oct 17, 2017 at 9:59 AM, Richard Haines
>> > > <richard_c_haines@btinternet.com> wrote:
>> > > > The SELinux SCTP implementation is explained in:
>> > > > Documentation/security/SELinux-sctp.txt
>> > > >
>> > > > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
>> > > > ---
>> > > >  Documentation/security/SELinux-sctp.txt | 108 +++++++++++++
>> > > >  security/selinux/hooks.c                | 268
>> > > > ++++++++++++++++++++++++++++++--
>> > > >  security/selinux/include/classmap.h     |   3 +-
>> > > >  security/selinux/include/netlabel.h     |   9 +-
>> > > >  security/selinux/include/objsec.h       |   5 +
>> > > >  security/selinux/netlabel.c             |  52 ++++++-
>> > > >  6 files changed, 427 insertions(+), 18 deletions(-)
>> > > >  create mode 100644 Documentation/security/SELinux-sctp.txt
>>
>> ...
>>
>> > > > +Policy Statements
>> > > > +=========
>> > > > +The following class and permissions to support SCTP are
>> > > > available
>> > > > within the
>> > > > +kernel:
>> > > > +    class sctp_socket inherits socket { node_bind }
>> > > > +
>> > > > +whenever the following policy capability is enabled:
>> > > > +    policycap extended_socket_class;
>> > > > +
>> > > > +The SELinux SCTP support adds the additional permissions that
>> > > > are
>> > > > explained
>> > > > +in the sections below:
>> > > > +    association bindx connectx
>> > >
>> > > Is the distinction between bind and bindx significant?  The same
>> > > question applies to connect/connectx.  I think we can probably
>> > > just
>> > > reuse bind and connect in these cases.
>> >
>> > This has been discussed before with Marcelo and keeping
>> > bindx/connectx
>> > is a useful distinction.
>>
>> My apologies, I must have forgotten/missed that discussion.  Do you
>> have an archive pointer?
>
> No this was off list, however I've copied the relevant bits:
>
>> SCTP Socket Option Permissions
>> ===============>> Permissions that are validated on setsockopt(2) calls (note that the
>> sctp_socket SETOPT permission must be allowed):
>>
>> This option requires the BINDX_ADDR permission:
>> SCTP_SOCKOPT_BINDX_REM - Remove additional bind address.
>
> Can't see an usage for this one.
>
>>
>> These options require the SET_PARAMS permission:
>> SCTP_PEER_ADDR_PARAMS  - Set heartbeats and address max
>> retransmissions.
>> SCTP_PEER_ADDR_THLDS  - Set thresholds.
>> SCTP_ASSOCINFO        - Set association / endpoint parameters.
>
> Also for these, considering we are not willing to go as deep as to only
> allow these if within a given threshold. But still even then, sounds
> like too much.
>
>>
>>
>> SCTP Bind, Connect and ASCONF Chunk Parameter Permission Checks
>> ===============================
>> The hook security_sctp_addr_list() is called by SCTP when processing
>> various options (@optname) to check permissions required for the list
>> of ipv4/ipv6 addresses (@address) as follows:
>> --------------------------------------------------------------------
>> |                sctp_socket BIND type permission checks          |
>> |            (The socket must also have the BIND permission)      |
>> |      @optname            | Permission  |  @address              |
>> |--------------------------|-------------|-------------------------|
>> |SCTP_SOCKOPT_BINDX_ADD    |BINDX_ADDRS  |One or more ipv4/ipv6 adr|
>
> This one can be useful, for that privilege-dropping case.
>
> Paul note: I later changed BINDX_ADDRS to just BINDX
>
>> |SCTP_PRIMARY_ADDR        |SET_PRI_ADDR |Single ipv4 or ipv6 adr  |
>> |SCTP_SET_PEER_PRIMARY_ADDR|SET_PEER_ADDR|Single ipv4 or ipv6 adr  |
>
> But these, can't use an use-case.
>
>> --------------------------------------------------------------------
>> --------------------------------------------------------------------
>> |                sctp_socket CONNECT type permission checks        |
>> |            (The socket must also have the CONNECT permission)    |
>> |      @optname            | Permission  |  @address              |
>> |--------------------------|-------------|-------------------------|
>> |SCTP_SOCKOPT_CONNECTX    |CONNECTX    |One or more ipv4/ipv6 adr|
>> |SCTP_PARAM_ADD_IP        |BINDX_ADDRS  |One or more ipv4/ipv6 adr|
>
> The 2 above, can be useful.
>
>> |SCTP_PARAM_DEL_IP        |BINDX_ADDRS  |One or more ipv4/ipv6 adr|
>> |SCTP_PARAM_SET_PRIMARY    |SET_PRI_ADDR |Single ipv4 or ipv6 adr  |
>
> But not these two..
>
>> --------------------------------------------------------------------
>>
>> SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
>> associated after (optionally) calling
>> bind(3).
>> sctp_bindx(3) adds a set of bind
>> addresses on a socket.
>>
>> SCTP_SOCKOPT_CONNECTX - Allows the allocation of multiple
>> addresses for reaching a peer
>> (multi-homed).
>> sctp_connectx(3) initiates a connection
>> on an SCTP socket using multiple
>> destination addresses.
>>
>> SCTP_PRIMARY_ADDR    - Set local primary address.
>>
>> SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
>> association primary.
>
> No and no for the 2 above.

I still don't undetstand how, from a security perspective,
sctp_socket:bindx is different from sctp_socket:bind.  I understand
the distinction is important from a SCTP perspective, but from a
SELinux perspective isn't sctp_socket:bindx simply sctp_socket:bind?
How is bindx different from bind?

The same applies for connect/connectx.

>> > > > +SCTP Peer Labeling
>> > > > +=========>> > > > +An SCTP socket will only have one peer label assigned to it.
>> > > > This
>> > > > will be
>> > > > +assigned during the establishment of the first association.
>> > > > Once
>> > > > the peer
>> > > > +label has been assigned, any new associations will have the
>> > > > "association"
>> > > > +permission validated by checking the socket peer sid against
>> > > > the
>> > > > received
>> > > > +packets peer sid to determine whether the association should
>> > > > be
>> > > > allowed or
>> > > > +denied.
>> > > > +
>> > > > +NOTES:
>> > > > +   1) If peer labeling is not enabled, then the peer context
>> > > > will
>> > > > always be
>> > > > +      SECINITSID_UNLABELED (unlabeled_t in Reference Policy).
>> > > > +
>> > > > +   2) As SCTP supports multiple endpoints with multi-homing on
>> > > > a
>> > > > single socket
>> > > > +      it is recommended that peer labels are consistent.
>> > >
>> > > My apologies if I'm confused, but I thought it was multiple
>> > > associations per-endpoint, with the associations providing the
>> > > multi-homing functionality, no?
>> >
>> > I've reworded to:
>> > As SCTP can support more than one transport address per endpoint
>> > (multi-homing) on a single socket, it is possible to configure
>> > policy
>> > and NetLabel to provide different peer labels for each of these. As
>> > the
>> > socket peer label is determined by the first associations transport
>> > address, it is recommended that all peer labels are consistent.
>>
>> I'm still not sure this makes complete sense to me, but since I'm
>> still not 100% confident in my understanding of SCTP I'm willing to
>> punt on this for the moment.
>
> I would like you to be happy with this so I've added what I think is
> some clarification.
>
> The code that handles this is the selinux_sctp_assoc_request() in
> hooks.c. If not the first association, then the other association peer
> SIDs are validated to enforce consistency among the peer SIDs. However
> what I recommend is that all peer labels should be the same. For
> example:
>
> Don't configure this (although valid):
> netlabelctl unlbl add interface:lo address:127.0.0.0/8 \
>     label:system_u:object_r:netlabel_peer_lo_t:s0
> netlabelctl unlbl add interface:wlp12s0 address:192.168.1.0/24 \
>     label:system_u:object_r:netlabel_peer_wlan_t:s0
> netlabelctl unlbl add interface:enp9s0 address:193.168.1.0/24 \
>     label:system_u:object_r:netlabel_peer_eth_t:s0
>
> As this is recommended:
> netlabelctl unlbl add interface:lo address:127.0.0.0/8 \
>     label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl unlbl add interface:wlp12s0 address:192.168.1.0/24 \
>     label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl unlbl add interface:enp9s0 address:193.168.1.0/24 \
>     label:system_u:object_r:netlabel_peer_t:s0
>
> Would you prefer me to delete this section ?

Okay, I think I'm getting a better idea of this ... let me walk
through some of this, slowly.

On the send/egress side of things we don't really need to worry about
the remote peer label as we only do access control checks using the
sender's label (the local process/socket).  There is a slight
exception with respect to forwarded traffic, but I think we handle
that correctly for SCTP by substituting the traffic's label for the
local process/socket label (current behavior).

On the receive/ingress side we could receive traffic from any of the
associations, with the peer:recv permission checking the remote peer
label (aka the sending association's label) against the local
receiving socket.  This seems right to me.  As far as userspace is
concerned, *_getpeersec_dgram() should work correctly, but
*_getpeersec_stream() will only return the peer label we stored during
the initial association setup, yes?  This seems ... not the best.
Although I'm not sure how to solve this.

Is this why the requirement exists for each association to have an
equivalent label?

-- 
paul moore
www.paul-moore.com
