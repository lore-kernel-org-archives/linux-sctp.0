From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 16 Sep 2016 13:33:47 +0000
Subject: RE: [PATCH net] sctp: fix SSN comparision
Message-Id: <063D6719AE5E284EB5DD2968C1650D6DB00FF940@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> > -static inline int ADDIP_SERIAL_gte(__u16 s, __u16 t)
> > +static inline int ADDIP_SERIAL_gte(__u32 s, __u32 t)
> >  {
> >  	return ((s) = (t)) || (((t) - (s)) & ADDIP_SERIAL_SIGN_BIT);
> >  }

Does gcc manage to compile that to (s32)((t) - (s)) <= 0 ?

	David

