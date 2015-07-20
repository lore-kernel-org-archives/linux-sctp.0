From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 20 Jul 2015 18:53:26 +0000
Subject: Re: [PATCH v2 1/2] sctp: add new getsockopt option SCTP_SOCKOPT_PEELOFF_KERNEL
Message-Id: <20150720185326.GA2456@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1436891629.git.marcelo.leitner@gmail.com>
 <6091a8542d13f43fbe1abfa25062d28d15b15e66.1436891629.git.marcelo.leitner@gmail.com>
 <55A7B698.8080409@gmail.com>
 <20150716140314.GC1855@localhost.localdomain>
In-Reply-To: <20150716140314.GC1855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org

On Thu, Jul 16, 2015 at 11:03:14AM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Jul 16, 2015 at 09:50:16AM -0400, Vlad Yasevich wrote:
...
> > I am not familiar enough with DLM and its history, but my question is this:
> > If dlm always peels off a socket for a new associations, why is it using
> > 1-to-many api in the first place?  Doing a quick scan of DLM lowcoms code
> > for sctp specific things, I see nothing that has specific dependencies
> > on 1-to-many api.  It might be simpler to switch to using 1-to-1 api, similar
> > to dlm tcp and eliminate this dependency.
> > 
> > Is that a naive point of view?
> 
> Not at all, that's a very good question. I also don't know much of DLM
> code itself, I'll check that.

Sounds like DLM is using 1-to-many just in an attempt to use
multi-homing, but we can do that with 1-to-1 too. I'll draft a patch and
see how it goes, and perhaps with that we can avoid/postpone this
question regarding indirect call to sctp_do_peeloff by kernel.

  Marcelo

