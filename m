From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 01 Nov 2017 21:34:09 +0000
Subject: Re: [RFC PATCH 5/5] selinux: Add SCTP support
Message-Id: <1509572049.2954.6.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171017135953.4419-1-richard_c_haines@btinternet.com>
	<20171031171614.GE3675@localhost.localdomain>
In-Reply-To: <20171031171614.GE3675@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Tue, 2017-10-31 at 15:16 -0200, Marcelo Ricardo Leitner wrote:
> On Tue, Oct 17, 2017 at 02:59:53PM +0100, Richard Haines wrote:
> > The SELinux SCTP implementation is explained in:
> > Documentation/security/SELinux-sctp.txt
> > 
> > Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> > ---
> 
> ...
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 33fd061..c3e9600 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> 
> ...
> > @@ -4521,7 +4565,14 @@ static int selinux_socket_connect(struct
> > socket *sock, struct sockaddr *address,
> >  		unsigned short snum;
> >  		u32 sid, perm;
> >  
> > -		if (sk->sk_family = PF_INET) {
> > +		/* sctp_connectx(3) calls via
> > +		 *selinux_sctp_bind_connect() that validates
> > multiple
> > +		 * connect addresses. Because of this need to
> > check
> > +		 * address->sa_family as it is possible to have
> > +		 * sk->sk_family = PF_INET6 with addr->sa_family > > AF_INET.
> > +		 */
> > +		if (sk->sk_family = PF_INET ||
> > +					address->sa_family =
> > AF_INET) {
> 
> Not sure which code style applies on this file but the if () above
> looks odd. At least, checkpatch.pl complained about it.
Changed to read:
		if (sk->sk_family = PF_INET ||
		    address->sa_family = AF_INET) {

> 
>   Marcelo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
