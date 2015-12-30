From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 19:03:43 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <1451502223.8255.45.camel@edumazet-glaptop2.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
	 <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20151230.125204.1385006803109278855.davem@davemloft.net>
In-Reply-To: <20151230.125204.1385006803109278855.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

On Wed, 2015-12-30 at 12:52 -0500, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 30 Dec 2015 12:19:39 -0500
> 
> > Switching SCTP to rhashtable at this moment is premature, it is
> > still moving fast.
> 
> I completely, and totally, disagree.
> 
> rhashtable actually _needs_ a strong active user like one of the
> protocol socket hashes.
> 
> It's a step backwards to keep rhashtable in the shadows by only
> allowing certain subsystems to convert to it.  That's really
> incredibly stupid if you ask me.

You sure can disagree with me, but calling my opinion 'incredily stupid'
is not wise.

Let me check how stable is rhashtable :

# git log --oneline v4.2.. lib/rhashtable.c
179ccc0a7364 rhashtable: Kill harmless RCU warning in rhashtable_walk_init
c6ff5268293e rhashtable: Fix walker list corruption
3a324606bbab rhashtable: Enforce minimum size on initial hash table
a90099d9fabd Revert "rhashtable: Use __vmalloc with GFP_ATOMIC for table allocation"
d3716f18a7d8 rhashtable: Use __vmalloc with GFP_ATOMIC for table allocation
3cf92222a39c rhashtable: Prevent spurious EBUSY errors on insertion
7def0f952ecc lib: fix data race in rhashtable_rehash_one


Seriously, I think we can wait one release before 'en masse'
conversions.

I understand we would love to do that, but what is the hurry for SCTP,
that needed rhashtable so desperately that it could not be done before
2016 ?



