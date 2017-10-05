From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 05 Oct 2017 03:40:54 +0000
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Message-Id: <20171005034054.GB31996@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
 <CALCETrWdXjTTTywbb3duCEsLYNxkeGx7bf3SM4PYKeErCyiUNQ@mail.gmail.com>
 <20171003052643.GB22750@gondor.apana.org.au>
 <20171003224505.GE19750@localhost.localdomain>
In-Reply-To: <20171003224505.GE19750@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jia-Ju Bai <baijiaju1990@163.com>, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, vyasevich@gmail.com, Kalle Valo <kvalo@codeaurora.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Linux Wireless List <linux-wireless@vger.kernel.org>

On Tue, Oct 03, 2017 at 07:45:06PM -0300, Marcelo Ricardo Leitner wrote:
>
> > Usually if you're invoking setkey from a non-sleeping code-path
> > you're probably doing something wrong.
> 
> Usually but not always. There are 3 calls to that function on SCTP
> code:
> - pack a cookie, which is sent on an INIT_ACK packet to the client
> - unpack the cookie above, after it is sent back by the client on a
>   COOKIE_ECHO packet
> - send a chunk authenticated by a hash

I'm not talking about the code-path in question.  I'm talking
about the function which generates the secret key in the first
place.  AFAICS that's only called in GFP_KERNEL context.  What
am I missing?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
