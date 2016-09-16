From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Sep 2016 13:40:47 +0000
Subject: Re: [PATCH net] sctp: fix SSN comparision
Message-Id: <20160916134047.GD3200@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 16, 2016 at 01:33:47PM +0000, David Laight wrote:
> > > -static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
> > > +static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
> > >  {
> > >  	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
> > >  }
> 
> Does gcc manage to compile that to (s32)((t) - (s)) <= 0 ?

I have no idea but I have a patch in the works for updating it to this
form, to be more like time_after(). Will probably post it by next week.

  Marcelo
