From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 11 Jan 2016 09:22:45 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add the rhashtable apis for sctp global transport hashtable
Message-Id: <20160111092245.GA23331@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1451490447.git.lucien.xin@gmail.com>
 <2c413161eb3a2c74453bd8dc11815af7e237515e.1451490447.git.lucien.xin@gmail.com>
 <20151230174103.GC16270@localhost.localdomain>
 <CADvbK_evLk8YgYDdNvEoBB-SSqH8s7wWu_K5g=SzP=GOj-TWtw@mail.gmail.com>
In-Reply-To: <CADvbK_evLk8YgYDdNvEoBB-SSqH8s7wWu_K5g=SzP=GOj-TWtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <mleitner@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>, daniel@iogearbox.net, davem <davem@davemloft.net>

On Tue, Jan 05, 2016 at 06:10:15PM +0800, Xin Long wrote:
>
> without this 'reinsert'.
> 
> we can reproduce this issue like this:
> 1. download the attachment
> 2. cp sctperf.tar.gz to server and client hosts
> 3. in each hosts.
> #make
> 4. in server:
> #sh saddr.sh $ethx
> #./ss
> 5. in client:
> #sh caddr.sh $ethx
> #ulimit -n 20000
> #./cc
> 
> when the number of  connections reach about 1600, this issue will be triggered.

Just to confirm this is with the latest upstream kernel, right?
A git ID would be helpful.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
