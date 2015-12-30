From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 17:19:39 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1451490447.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net, davem@davemloft.net

On Wed, 2015-12-30 at 23:50 +0800, Xin Long wrote:

> besides, this patchset will use transport hashtable to replace
> association hashtable to lookup with rhashtable api. get transport
> first then get association by t->asoc. and also it will make tcp
> style work better.

SCTP already has a hash table, why not simply changing the way items are
hashed into it ?

Sure, storing thousands of sockets in a single hash bucket is not wise.

Switching SCTP to rhashtable at this moment is premature, it is still
moving fast.


