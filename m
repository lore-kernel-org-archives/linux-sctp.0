From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Sep 2018 07:55:34 +0000
Subject: Re: [PATCH net] sctp: update dst pmtu with the correct daddr
Message-Id: <CADvbK_djerrPki_weXxxwpf3ncT=k2PxK2=gB0BUKToznBRyCA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <dbed84b3964b13a0c15b3a5c8e825940819a2918.1537435648.git.lucien.xin@gmail.com>
 <20180920.113113.1168948449098131783.davem@davemloft.net>
In-Reply-To: <20180920.113113.1168948449098131783.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem <davem@davemloft.net>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Sep 21, 2018 at 2:31 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Thu, 20 Sep 2018 17:27:28 +0800
>
> > When processing pmtu update from an icmp packet, it calls .update_pmtu
> > with sk instead of skb in sctp_transport_update_pmtu.
> >
> > However for sctp, the daddr in the transport might be different from
> > inet_sock->inet_daddr or sk->sk_v6_daddr, which is used to update or
> > create the route cache. The incorrect daddr will cause a different
> > route cache created for the path.
> >
> > So before calling .update_pmtu, inet_sock->inet_daddr/sk->sk_v6_daddr
> > should be updated with the daddr in the transport, and update it back
> > after it's done.
> >
> > The issue has existed since route exceptions introduction.
> >
> > Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
> > Reported-by: ian.periam@dialogic.com
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Applied and queued up for -stable.
>
> Although are you sure it's OK to temporarily change the sockets address
> like this?  What if an asynchronous context looks at the socket state
> and sees the temporarily set address?
It's under the protection of the sock lock, I think any other places that
want to access the address also need to acquire this sock lock first.
