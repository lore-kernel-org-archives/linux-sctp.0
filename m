From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 May 2008 14:09:16 +0000
Subject: Re: retrans path update problem
Message-Id: <482AF28C.8030000@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482AA73D.5000507@cn.fujitsu.com>
In-Reply-To: <482AA73D.5000507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Gui Jianfeng wrote:
> hello everybody,
> When updating retrans path(asoc->peer.retran_path), should 
> we update the retran path to another transport even if only the 
> original retrans path is active?
> In the other words, i think, retrans path should always be 
> changed if there are more than one transport in an association.
> 
> Am i right?

And we do that with sctp_assoc_update_retran_path().  If we
don't find another active transport, we'll still try set the
retran_path to the next transport in the list.

Are you asking if we should only use ACTIVE transports?

-vlad
