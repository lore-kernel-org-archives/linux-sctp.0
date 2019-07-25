From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 25 Jul 2019 01:21:15 +0000
Subject: Re: SCTP recvmsg MSG_TRUNC or something similar
Message-Id: <20190725012115.GA4064@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <D588EC18-6A7B-4D2B-AB0A-2961A247DC3B@cnix.ro>
In-Reply-To: <D588EC18-6A7B-4D2B-AB0A-2961A247DC3B@cnix.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Wed, Jul 24, 2019 at 02:46:09PM +0100, Luci Stanescu wrote:
> Hi,

Hi,

> 
> I’m not sure this is the right place to ask this kind of question,
> but, having not found a better forum, I’m trying my luck. Apologies

Considering you're programming for Linux, it is. :-)

> in advance if this is outside the scope of the mailing list.
> 
> That being said, my question is: given a successful return of
> recvmsg() for a SOCK_SEQPACKET SCTP socket, is there no stateless
> way to determine if the read data, for which the MSG_EOR flag is
> set, is the trailing “fragment” of a larger record (either due to
> partial delivery or an insufficient buffer passed to a prior call to
> recvmsg() which returned with the MSG_EOR flag cleared), rather than
> a “full” message?

Stateless, I'm not aware of a way.
We do have SCTP_PARTIAL_DELIVERY_EVENT, though, and RCVINFO. But these
would require some state to be preserved.
MSG_PEEK also, but also requires some state.

> 
> From what I can tell, MSG_TRUNC, which would’ve solved my issue,
> isn’t implemented for SCTP. Regarding this topic, I’ve only found

Agreed, but MSG_TRUNC would cause information loss.

What about using a larger buf?

> old discussions, including some suggestions to add SOCK_RDM, which
> never materialised.
> 
> Many thanks for your time!
> 
> Luci

Regards,
Marcelo
