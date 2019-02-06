From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 06 Feb 2019 21:08:27 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190206210827.GC16887@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
In-Reply-To: <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julien Gomes <julien@arista.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, vyasevich@gmail.com, lucien.xin@gmail.com

On Wed, Feb 06, 2019 at 12:48:38PM -0800, Julien Gomes wrote:
> 
> 
> On 2/6/19 12:37 PM, Marcelo Ricardo Leitner wrote:
> > On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> >> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> >> structures longer than the current definitions.
> >>
> >> This should prevent unjustified setsockopt() failures due to struct
> >> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> >> binaries that should be compatible, but were built with later kernel
> >> uapi headers.
> > 
> > Not sure if we support backwards compatibility like this?
> > 
> > My issue with this change is that by doing this, application will have
> > no clue if the new bits were ignored or not and it may think that an
> > event is enabled while it is not.
> > 
> > A workaround would be to do a getsockopt and check the size that was
> > returned. But then, it might as well use the right struct here in the
> > first place.
> > 
> > I'm seeing current implementation as an implicitly versioned argument:
> > it will always accept setsockopt calls with an old struct (v4.11 or
> > v4.12), but if the user tries to use v3 on a v1-only system, it will
> > be rejected. Pretty much like using a newer setsockopt on an old
> > system.
> 
> With the current implementation, given sources that say are supposed to
> run on a 4.9 kernel (no use of any newer field added in 4.11 or 4.12),
What given sources say that?  I understand it might be expected, but this is an
common concern with setsockopt method on many protocols, it just so happens that
sctp extends them more than other protocols.

> we can't rebuild the exact same sources on a 4.19 kernel and still run
> them on 4.9 without messing with structures re-definition.
> 
Right, put another way, we support backward compatibility with older userspace
applications, but not newer one.  I.e. if you build an application against the
4.9 SCTP API, it should work with the 4.19 UAPI, but not vice versa, which it
seems is like what you are trying to do here.

> I understand your point, but this still looks like a sort of uapi
> breakage to me.
> 
> 
> I also had another way to work-around this in mind, by copying optlen
> bytes and checking that any additional field (not included in the
> "current" kernel structure definition) is not set, returning EINVAL in
> such case to keep a similar to current behavior.
> The issue with this is that I didn't find a suitable (ie not totally
> arbitrary such as "twice the existing structure size") upper limit to
> optlen.
> 
There is no real uppper limit to the size of the structure in this case, and
IIRC this isn't the only sockopt structure that can be exentded for SCTP in this
way.

I really don't see a sane way to allow newer userspaces to be compatible with
older kernels here.  If we were to do it I would suggest moving the
responsibility for that feature into lksctp-tools, versioning that library such
that correlary symbols are versioned to translate the application view of the
socket options structs to the size and format that the running kernel
undertands.  Note that I'm not really advocating for that, as it seems like a
fast moving target, but if we were to do it I think that would be the most sane
way to handle it.

Neil

> > 
> >>
> >> Signed-off-by: Julien Gomes <julien@arista.com>
> >> ---
> >>  net/sctp/socket.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >> index 9644bdc8e85c..f9717e2789da 100644
> >> --- a/net/sctp/socket.c
> >> +++ b/net/sctp/socket.c
> >> @@ -2311,7 +2311,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
> >>  	int i;
> >>  
> >>  	if (optlen > sizeof(struct sctp_event_subscribe))
> >> -		return -EINVAL;
> >> +		optlen = sizeof(struct sctp_event_subscribe);
> >>  
> >>  	if (copy_from_user(&subscribe, optval, optlen))
> >>  		return -EFAULT;
> >> -- 
> >> 2.20.1
> >>
> 
> 
