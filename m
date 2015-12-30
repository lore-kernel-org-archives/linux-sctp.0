From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 Dec 2015 17:32:02 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <20151230173202.GB16270@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
 <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net, davem@davemloft.net

On Wed, Dec 30, 2015 at 12:19:39PM -0500, Eric Dumazet wrote:
> On Wed, 2015-12-30 at 23:50 +0800, Xin Long wrote:
> 
> > besides, this patchset will use transport hashtable to replace
> > association hashtable to lookup with rhashtable api. get transport
> > first then get association by t->asoc. and also it will make tcp
> > style work better.
> 
> SCTP already has a hash table, why not simply changing the way items are
> hashed into it ?

Because Vlad asked to split the patch so it gets easier to review. The
direct change was quite big.

> Sure, storing thousands of sockets in a single hash bucket is not wise.
> 
> Switching SCTP to rhashtable at this moment is premature, it is still
> moving fast.

Dave and Vlad had asked in the first review for considering using
rhashtable (ok, Dave didn't mention it by name).  We did, and it seemed
nice beside 1 issue Xin found, regarding multiple rehashing, which I'll
highlight in a reply right away. 
Said all this, I know this was your second email already against this
usage, but I have to ask, sorry: still really against it?

Initial post was with subject:
[PATCH net] sctp: support global vtag assochash and per endpoint
s(d)port assochash table

Thanks,
Marcelo

