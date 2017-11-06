From: Paul Moore <paul@paul-moore.com>
Date: Mon, 06 Nov 2017 22:35:57 +0000
Subject: Re: [RFC PATCH 1/5] security: Add support for SCTP security hooks
Message-Id: <CAHC9VhQcJZ740fP+9C-Ht-qUQDJUB4N66CRJYvJWKjGtAB+5tQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017140247.4604-1-richard_c_haines@btinternet.com>
In-Reply-To: <20171017140247.4604-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, Oct 17, 2017 at 10:02 AM, Richard Haines
<richard_c_haines@btinternet.com> wrote:
> The SCTP security hooks are explained in:
> Documentation/security/LSM-sctp.txt
>
> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> ---
>  Documentation/security/LSM-sctp.txt | 212 ++++++++++++++++++++++++++++++++++++
>  include/linux/lsm_hooks.h           |  37 +++++++
>  include/linux/security.h            |  27 +++++
>  security/security.c                 |  23 ++++
>  4 files changed, 299 insertions(+)
>  create mode 100644 Documentation/security/LSM-sctp.txt

Hi Richard,

Thanks for sticking with this, I really appreciate the effort you're
putting into this and I apologize it has taken me a few weeks to get
to reviewing this patchset ... comments below.

> diff --git a/Documentation/security/LSM-sctp.txt b/Documentation/security/LSM-sctp.txt
> new file mode 100644
> index 0000000..30fe9b5
> --- /dev/null
> +++ b/Documentation/security/LSM-sctp.txt
> @@ -0,0 +1,212 @@

There is a push to convert the docs under Documentation/ to use the
reStructuredText format; from what I can tell this shouldn't have a
major impact on what you've already written, just a few formatting
tweaks.  If you can convert the SCTP/LSM/SELinux docs over to RST that
would be very nice.

> +                               SCTP LSM Support
> +                              =========
> +
> +For security module support, three sctp specific hooks have been implemented:
> +    security_sctp_assoc_request()
> +    security_sctp_bind_connect()
> +    security_sctp_sk_clone()
> +
> +Also the following security hook has been utilised:
> +    security_inet_conn_established()
> +
> +The usage of these hooks are described below with the SELinux implementation
> +described in Documentation/security/SELinux-sctp.txt
> +
> +
> +security_sctp_assoc_request()
> +------------------------------
> +This new hook has been added to net/sctp/sm_statefuns.c where it passes the

I would probably avoid calling out specific source files in this
document as the code is almost certain to change at some point (moving
the LSM hook) and I can almost guarantee we'll forget to update this
document.  I think it's better to say something like this:

  "This new hook passes the @ep ..."

> +@ep and @chunk->skb (the association INIT or INIT ACK packet) to the security
> +module. Returns 0 on success, error on failure.
> +
> +    @ep - pointer to sctp endpoint structure.
> +    @skb - pointer to skbuff of association packet.
> +    @sctp_cid - set to sctp packet type (SCTP_CID_INIT or SCTP_CID_INIT_ACK).

Once again, I must beg patience with my poor understanding of SCTP,
I'm quickly skimming through the RFCs but I'm sure to get some things
wrong.

> +The security module performs the following operations:
> +  1) If this is the first association on @ep->base.sk, then set the peer sid
> +     to that in @skb. This will ensure there is only one peer sid assigned
> +     to @ep->base.sk that may support multiple associations.

Conceptually this is similar to selinux_inet_conn_request(), yes?
Setting the peer label of a new connection/association triggered by a
remote request.

I'm sure we'll get into this later once I get to the code itself, but
I wonder if we should be tracking the peer label in the endpoint?
Would we ever want to allow multiple different peer labels on a single
endpoint?  That seems a bit crazy to me.  Although it might just be
easier from an implementation perspective to reuse the existing
sksec->peer_sid field ...

> +  2) If not the first association, validate the @ep->base.sk peer_sid against
> +     the @skb peer sid to determine whether the association should be allowed
> +     or denied.

This is possible because SCTP allows multiple associations per
endpoint, yes?  I imagine that most (all?) LSMs would want to restrict
this such that all associations for a given endpoint have the same
label.

> +  3) If @sctp_cid = SCTP_CID_INIT, then set the sctp @ep sid to socket's sid
> +     (from ep->base.sk) with MLS portion taken from @skb peer sid. This will
> +     only be used by SCTP TCP style sockets and peeled off connections as they
> +     cause a new socket to be generated.

Once again, the same logic as in
selinux_inet_conn_request()/selinux_conn_sid(), yes?

Presumably we don't need to do anything special for the
SCTP_CID_INIT_ACK case as this is the client side of the connection,
yes?

> +     If IP security options are configured (CIPSO/CALIPSO), then the ip options
> +     are set on the socket.
> +
> +     To support this hook include/net/sctp/structs.h "struct sctp_endpoint"
> +     has been updated with the following:
> +
> +       /* Security identifiers from incoming (INIT). These are set by
> +        * security_sctp_assoc_request(). These will only be used by
> +        * SCTP TCP type sockets and peeled off connections as they
> +        * cause a new socket to be generated. security_sctp_sk_clone()
> +        * will then plug these into the new socket.
> +        */
> +       u32 secid;
> +       u32 peer_secid;

I would drop the filename and code details for the reasons mentioned above.

> +security_sctp_bind_connect()
> +-----------------------------
> +This new hook has been added to net/sctp/socket.c and net/sctp/sm_make_chunk.c.

See previous comments on filenames/code.

> +It passes one or more ipv4/ipv6 addresses to the security module for
> +validation based on the @optname that will result in either a bind or connect
> +service as shown in the permission check tables below.
> +Returns 0 on success, error on failure.
> +
> +    @sk      - Pointer to sock structure.
> +    @optname - Name of the option to validate.
> +    @address - One or more ipv4 / ipv6 addresses.
> +    @addrlen - The total length of address(s). This is calculated on each
> +               ipv4 or ipv6 address using sizeof(struct sockaddr_in) or
> +               sizeof(struct sockaddr_in6).
> +
> +  ------------------------------------------------------------------
> +  |                     BIND Type Checks                           |
> +  |       @optname             |         @address contains         |
> +  |----------------------------|-----------------------------------|
> +  | SCTP_SOCKOPT_BINDX_ADD     | One or more ipv4 / ipv6 addresses |
> +  | SCTP_PRIMARY_ADDR          | Single ipv4 or ipv6 address       |
> +  | SCTP_SET_PEER_PRIMARY_ADDR | Single ipv4 or ipv6 address       |
> +  ------------------------------------------------------------------
> +
> +  ------------------------------------------------------------------
> +  |                   CONNECT Type Checks                          |
> +  |       @optname             |         @address contains         |
> +  |----------------------------|-----------------------------------|
> +  | SCTP_SOCKOPT_CONNECTX      | One or more ipv4 / ipv6 addresses |
> +  | SCTP_PARAM_ADD_IP          | One or more ipv4 / ipv6 addresses |
> +  | SCTP_SENDMSG_CONNECT       | Single ipv4 or ipv6 address       |
> +  | SCTP_PARAM_SET_PRIMARY     | Single ipv4 or ipv6 address       |
> +  ------------------------------------------------------------------

I'm guessing/hoping the reasons for multiplexing all of these
operations onto a single LSM hook will make sense when I get to the
code.

> +A summary of the @optname entries is as follows:
> +
> +    SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> +                             associated after (optionally) calling
> +                             bind(3).
> +                             sctp_bindx(3) adds a set of bind
> +                            addresses on a socket.
> +
> +    SCTP_SOCKOPT_CONNECTX - Allows the allocation of multiple
> +                            addresses for reaching a peer
> +                            (multi-homed).
> +                            sctp_connectx(3) initiates a connection
> +                            on an SCTP socket using multiple
> +                            destination addresses.
> +
> +    SCTP_SENDMSG_CONNECT  - Initiate a connection that is generated by a
> +                            sendmsg(2) or sctp_sendmsg(3) on a new asociation.
> +
> +    SCTP_PRIMARY_ADDR     - Set local primary address.
> +
> +    SCTP_SET_PEER_PRIMARY_ADDR - Request peer sets address as
> +                                 association primary.
> +
> +    SCTP_PARAM_ADD_IP          - These are used when Dynamic Address
> +    SCTP_PARAM_SET_PRIMARY     - Reconfiguration is enabled as explained below.
> +
> +
> +To support Dynamic Address Reconfiguration the following parameters must be
> +enabled on both endpoints (or use the appropriate setsockopts):
> +    /proc/sys/net/sctp/addip_enable
> +    /proc/sys/net/sctp/addip_noauth_enable
> +
> +then the following *_PARAM_*'s are sent to the peer in an
> +ASCONF chunk when the corresponding @optname's are present:
> +
> +          @optname                ASCONF Parameter
> +    SCTP_SOCKOPT_BINDX_ADD     -> SCTP_PARAM_ADD_IP
> +    SCTP_SET_PEER_PRIMARY_ADDR -> SCTP_PARAM_SET_PRIMARY
> +
> +
> +security_sctp_sk_clone()
> +-------------------------
> +This new hook has been added to net/sctp/socket.c sctp_sock_migrate() that is

See my previous comments on filenames/code.

> +called whenever a new socket is created by accept(2) (i.e. a TCP style socket)
> +or when a socket is 'peeled off' e.g userspace calls sctp_peeloff(3).

You can only "peeloff" a socket from a one-to-many socket, not a
one-to-one socket, yes?

(If I'm understanding SCTP correctly, it wouldn't make sense to have a
many-to-one socket, yes?)

> +security_sctp_sk_clone() will set the new sockets sid and peer sid to that
> +contained in the @ep sid and @ep peer sid respectively.
> +
> +    @ep - pointer to old sctp endpoint structure.
> +    @sk - pointer to old sock structure.
> +    @sk - pointer to new sock structure.
> +
> +security_inet_conn_established()
> +---------------------------------
> +This hook has been added to net/sctp/sm_statefuns.c COOKIE ECHO processing

See my previous comments on filenames/code.

> +where it sets the connection's peer sid to that in @skb.
> +
> +    @sk  - pointer to sock structure.
> +    @skb - pointer to skbuff of the COOKIE ECHO packet.
> +
> +
> +Security Hooks used for Association Establishment
> +=========================
> +The following diagram shows the use of security_sctp_connect_bind(),
> +security_sctp_assoc_request(), security_inet_conn_established() in
> +net/sctp/sm_statefuns.c and security_sctp_sk_clone() in net/sctp/socket.c,
> +when establishing an association.
> +
> +      SCTP endpoint "A"                                SCTP endpoint "Z"
> +      =========                                ========> +    sctp_sf_do_prm_asoc()
> + Association setup can be initiated
> + by a connect(2), sctp_connectx(3),
> + sendmsg(2) or sctp_sendmsg(3).
> + These will result in a call to
> + security_sctp_bind_connect() to
> + initiate an association to
> + SCTP peer endpoint "Z".
> +         INIT --------------------------------------------->
> +                                                   sctp_sf_do_5_1B_init()
> +                                                 Respond to an INIT chunk.
> +                                             SCTP peer endpoint "A" is
> +                                             asking for an association. Call
> +                                             security_sctp_assoc_request()
> +                                             to set the peer label if first
> +                                             association.
> +                                             If not first association, check
> +                                             whether allowed, IF so send:
> +          <----------------------------------------------- INIT ACK
> +          |                                  ELSE audit event and silently
> +          |                                       discard the packet.

I'm guessing there is no IETF/RFC guidance on using SCTP in a labeled
network environment?  I was just wondering if we should send a ICMP
error back to the other end of the association; I'm guessing we should
defer to the underlying protocol.  While CIPSO predates SCTP, it seems
in keeping with the CIPSO protocol that we would send an ICMP error,
however I imagine that with CALIPSO we would want to silently drop the
packet.

> +    sctp_sf_do_5_1C_ack
> + Respond to an INIT ACK chunk.
> + SCTP peer endpoint"A" initiated
> + this association to SCTP peer
> + endpoint "Z". Call
> + security_sctp_assoc_request()
> + to set the peer label if first
> + association. If not first
> + association, check whether
> + allowed, IF so send:
> +    COOKIE ECHO ------------------------------------------>
> + ELSE audit event and silently                            |
> +      discard the packet.                                 |

Same as above with respect to handling LSM denials.

> +                                                          |
> +          <------------------------------------------- COOKIE ACK
> +          |                                               |
> +    sctp_sf_do_5_1E_ca                                    |
> + Call security_inet_conn_established()                    |
> + to set the correct peer sid.                             |

We would only get here if this association was the first for a given
endpoint, yes?

> +          |                                               |
> +          |                               net/sctp/socket.c sctp_copy_sock()
> +          |                               If SCTP_SOCKET_TCP or peeled off
> +          |                               socket security_sctp_sk_clone() is
> +          |                               called to clone the new socket.

In this case we are establishing a new association for a given endpoint, yes?

> +          |                                               |
> +      ESTABLISHED                                    ESTABLISHED
> +          |                                               |
> +    ------------------------------------------------------------------
> +    |                     Association Established                    |
> +    ------------------------------------------------------------------
> +
> +

-- 
paul moore
www.paul-moore.com
