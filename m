From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 09 Sep 2016 07:24:17 +0000
Subject: Re: [PATCH net] sctp: hold the transport before using it in sctp_hash_cmp
Message-Id: <CADvbK_f2Lz7UjxAg6pfabMUd42c4mHnOODqB6SwuOKJEWqRyGw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
 <20160908192751.GE16608@hmsreliant.think-freely.org>
In-Reply-To: <20160908192751.GE16608@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

>>
> What path does this occur in?  __sctp_lookup_association takes a hold on the
> asoc, and that function is protected by the rcu_read_lock, so I'm not sure how
> you get into a situation in which the asoc can be deleted while the lookup is
> occuring.
>
yes  that function is protected by the rcu_read_lock, it can only
ensure sctp_transport_destroy_rcu will NOT be called. But,
sctp_transport_destroy can be called by sctp_assocation_free.
in which, sctp free and unhash  all the transport. when transport's
defcnt become 0, sctp will call sctp_transport_destroy, in which,
asoc can be destroyed because of:
if (transport->asoc)
        sctp_association_put(transport->asoc);
