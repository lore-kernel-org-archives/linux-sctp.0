From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 23 Jul 2014 11:19:38 +0000
Subject: Re: SCTP Quick failover status
Message-Id: <20140723111938.GA7967@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <53CE902B.5030208@gmail.com>
In-Reply-To: <53CE902B.5030208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 22, 2014 at 12:24:11PM -0400, Vlad Yasevich wrote:
> On 07/22/2014 10:55 AM, Karen E. Egede Nielsen wrote:
> > Hi Vlad,
> > 
> > Would it possibly be feasible for you to  provide feedback on as  to
> > whether:
> > 
> > * Linux SCTP supports the most recent version of the SCTP PF draft,
> > http://datatracker.ietf.org/doc/draft-ietf-tsvwg-sctp-failover/, ?
> 
> It appears that Linux partially supports the latest draft.  Some of
> the newer language in section 4.1 is not supported.  The API doesn't
> appear to be supported either.
> 
> We'll work on adding this functionality.
> 
Looks like items 6 and 7 are missing from the list, as well as the socket api
bits.  I'll try get to this in the next week or so.
Neil

