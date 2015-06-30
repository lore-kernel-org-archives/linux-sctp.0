From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Jun 2015 17:41:01 +0000
Subject: Re: Clean up messages for a particular stream
Message-Id: <20150630174101.GB1943@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>
In-Reply-To: <CAAyB5c+_yBxrer7tA5a69E+-0nsZRCqLV4+MVHEAP_Ppg49whg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jun 30, 2015 at 01:18:09PM -0400, Vlad Yasevich wrote:
> On 06/30/2015 12:56 PM, Jerry Jerry wrote:
> >  Hello everyone,
> > 
> > We currently encounter an issue where we re-use the streams in a SCTP
> > connection. However, data from different message contexts may co-exist
> > in the send/recv buffers for that reused stream. I'm wondering if
> > there is any special API that allow us to flush the data for just one
> > particular stream in a SCTP connection just before we reuse it, or we
> > have to do this from application?
> > 
> > I've been searching but were unable to find a good answer yet. Your
> > advices would be greatly appreciated!
> > 
> 
> You are looking for an implementation of rfc6525.  Sadly we don't
> have a configuration for this extension, but patches are always welcome.

Wasn't aware of this RFC, thx.

  Marcelo
