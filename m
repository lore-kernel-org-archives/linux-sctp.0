From: David Miller <davem@davemloft.net>
Date: Tue, 08 May 2018 03:39:56 +0000
Subject: Re: [PATCHv2 net] sctp: delay the authentication for the duplicated cookie-echo chunk
Message-Id: <20180507.233956.1877940627262296985.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a815adb308826967c84cd8dc371c3c9b054c8da.1525503587.git.lucien.xin@gmail.com>
In-Reply-To: <2a815adb308826967c84cd8dc371c3c9b054c8da.1525503587.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  5 May 2018 14:59:47 +0800

> Now sctp only delays the authentication for the normal cookie-echo
> chunk by setting chunk->auth_chunk in sctp_endpoint_bh_rcv(). But
> for the duplicated one with auth, in sctp_assoc_bh_rcv(), it does
> authentication first based on the old asoc, which will definitely
> fail due to the different auth info in the old asoc.
> 
> The duplicated cookie-echo chunk will create a new asoc with the
> auth info from this chunk, and the authentication should also be
> done with the new asoc's auth info for all of the collision 'A',
> 'B' and 'D'. Otherwise, the duplicated cookie-echo chunk with auth
> will never pass the authentication and create the new connection.
> 
> This issue exists since very beginning, and this fix is to make
> sctp_assoc_bh_rcv() follow the way sctp_endpoint_bh_rcv() does
> for the normal cookie-echo chunk to delay the authentication.
> 
> While at it, remove the unused params from sctp_sf_authenticate()
> and define sctp_auth_chunk_verify() used for all the places that
> do the delayed authentication.
> 
> v1->v2:
>   fix the typo in changelog as Marcelo noticed.
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
