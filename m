From: David Miller <davem@davemloft.net>
Date: Tue, 08 Jul 2014 21:39:41 +0000
Subject: Re: [PATCH net-next v2 0/3] net: sctp: Optimisations to sctp command queue code
Message-Id: <20140708.143941.1550638900435655709.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1726CA5C@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726CA5C@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 4 Jul 2014 14:35:47 +0000

> These 3 patches optimise the code that processes sctp's command queue.
> (A list of 'tasks' to be performed after the rest of the chunk processing.)
> 
> 1) Inline all the functions from command.c
> 2) Remove the memset() calls used to zero a word-sized union.
> 3) Use pointers instead of array indexes.
> 
> The combined changes reduce the code size (amd64) by a few kb.
> 
> I'm not 100% convinced that the zeroing done in patch 2 is needed at all.
> On BE systems it is likely to generate more code than on LE ones.
> In fact it might be best to change the union to only contain 'long' sized
> items.
> 
> Changes for v2:
> 	- Add some missing initialisers in patch 2/3 and delete them in 3/3.
> 	- Modify the commit message for 2/3 to point out that the union
> 	  shouldn't need to be zeroed, but the patches aren't intended to
> 	  change the behaviour even if the code is buggy.

Series applied, thanks.
