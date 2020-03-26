From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Mar 2020 19:29:09 +0000
Subject: Re: One question regarding the SCTP write buffer free mechanism
Message-Id: <20200326192909.GD3828@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f7ef2f9a93b420c915a9e130356cdfa@nokia-sbell.com>
In-Reply-To: <9f7ef2f9a93b420c915a9e130356cdfa@nokia-sbell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Mar 26, 2020 at 05:22:46AM +0000, Mao, Jinhui (NSB - CN/Hangzhou) wrote:
...
>                        Error happened on Endpoint A when calling SCTP sendmsg to send more to Endpoint B, the error is "Resource temporarily unavailable". Association is not destroyed at this time. 
> 1 second later RTO Timeout 2nd Re-trans DATA [TSN=7] ---------------> (Acked)
> 
> 
> So could you please help to comments on the following question?
> -	Does this means that if an gap is found in the SACK, those packages sent after this lost packet will stay in the write buffer until the gap is filled? Even if they are successfully SACKed?

Yes and yes. Because the receiver is allowed to drop any data acked in
a gap block if it needs more memory to fill in the gap, and in this
case, the sender would have to retransmit it.

Seems you're using non-block sockets, otherwise that last sendmsg()
would have blocked waiting for the sndbuf space to be available, btw.

Cheers,
  Marcelo
