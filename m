From: Richard Haines <richard_c_haines@btinternet.com>
Date: Wed, 21 Dec 2016 12:26:53 +0000
Subject: Re: [RFC PATCH 1/1] kernel: Add SELinux SCTP protocol support
Message-Id: <1482323213.7144.1.camel@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20161214133959.3078-1-richard_c_haines@btinternet.com>
 <063D6719AE5E284EB5DD2968C1650D6DB023F752@AcuExch.aculab.com>
 <20161216134039.GD4731@localhost.localdomain>
In-Reply-To: <20161216134039.GD4731@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, David Laight <David.Laight@ACULAB.COM>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>

On Fri, 2016-12-16 at 11:40 -0200, Marcelo Ricardo Leitner wrote:
> On Wed, Dec 14, 2016 at 02:01:35PM +0000, David Laight wrote:
> > From: Richard Haines
> > > Sent: 14 December 2016 13:40
> > > Add SELinux support for the SCTP protocol. The SELinux-sctp.txt
> > > document
> > > describes how the patch has been implemented with an example
> > > policy and
> > > tests using lkstcp-tools.
> > 
> > ...
> > > +SCTP_SOCKOPT_BINDX_ADD - Allows additional bind addresses to be
> > > +                         associated after (optionally) calling
> > > bind(2)
> > > +                         if given the "bind_add" permission.
> > 
> > Does restricting bindx make any sense at all?
> > The only addresses than can be specified are those of local
> > interfaces.
> > If bindx isn't called then the default is to include the addresses
> > of
> > all local interfaces.
> > So bindx only actually removes local addresses, it doesn't add
> > them.
> 
> You could bind the socket while on a priviledged process and then
> drop
> the priviledges, like daemons do for binding on lower ports. Then the
> application wouldn't be able to bind on another address that it's not
> expected to.
> 
>   Marcelo
> 

It appears from Marcelo's comments that keeping bindx_add/bindx_rem
would be useful. However I will rename the permissions to a single
permission of "bindx_addr" if that's okay.

Any more sctp specific comments gratefully received (SELinux/LSM as
well of course). I plan to issue an updated patch mid-late Jan '17.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
