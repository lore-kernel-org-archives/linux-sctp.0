From: "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Date: Fri, 16 Sep 2016 14:53:09 +0000
Subject: Re: [PATCH net] sctp: fix SSN comparision
Message-Id: <20160916145309.GG3200@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 16, 2016 at 11:46:24AM -0300, 'Marcelo Ricardo Leitner' wrote:
> On Fri, Sep 16, 2016 at 02:17:15PM +0000, David Laight wrote:
> > From: Marcelo Ricardo Leitner
> > > Sent: 16 September 2016 14:45
> > > To: David Laight
> > > Cc: 'Neil Horman'; linux-sctp@vger.kernel.org
> > > Subject: Re: [PATCH net] sctp: fix SSN comparision
> > > 
> > > On Fri, Sep 16, 2016 at 10:40:47AM -0300, Marcelo Ricardo Leitner wrote:
> > > > On Fri, Sep 16, 2016 at 01:33:47PM +0000, David Laight wrote:
> > > > > > > -static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
> > > > > > > +static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
> > > > > > >  {
> > > > > > >  	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
> > > > > > >  }
> > > > >
> > > > > Does gcc manage to compile that to (s32)((t) - (s)) <= 0 ?
> > > >
> > > > I have no idea but I have a patch in the works for updating it to this
> > > > form, to be more like time_after(). Will probably post it by next week.
> > > 
> > > Just for reference, this should be it. Not realy tested yet.
> > > 
> > > commit b52575533dfefa1908c7bbe35bde0fa8359dd1a3
> > > Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Date:   Tue Aug 9 14:45:35 2016 -0300
> > > 
> > >     sctp: improve how SSN, TSN and ASCONF serial are compared
> > > 
> > >     Make it similar to time_before() macros instead.
> > > 
> > >     This patch also removes SSN_lte as it is not used.
> > ...
> > > +#define TSN_lte(a,b)	\
> > > +	(typecheck(__u32, a) && \
> > > +	 typecheck(__u32, b) && \
> > > +	 ((__s32)((a) - (b)) <= 0))
> > ...
> > > +	for (i = 0; i < blocks; ++i) {
> > > +		if (TSN_lte((__u32)ntohs(frags[i].gab.start), (__u32)gap) &&
> > > +		    TSN_lte((__u32)gap, (__u32)ntohs(frags[i].gab.end)))
> > 
> > Those casts look decidedly dubious, messy at best.
> > I'm pretty sure you're not managing modulo 2^16 arithmetic either.
> 
> Agreed.
> Just to highlight, this is an issue today already, as they are promoted
> to u32 on the function call.
> 
> > I think you want:
> > #define TSN_lte(a, b) ((__s16)((a) - (b)) <= 0)
> > If a and b are 16bit the subtract is always well defined.
> 
> No because it's also used in other places and with actual 32bit vars.
> This was the only place that required such casts.

That's why the typecheck() is good in this case, I think.

  Marcelo
