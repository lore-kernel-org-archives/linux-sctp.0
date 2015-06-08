From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Mon, 08 Jun 2015 20:09:50 +0000
Subject: Re: [PATCH v3 2/2] sctp: fix ASCONF list handling
Message-Id: <1433794190.4616.8.camel@stressinduktion.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20150604142710.GD24585@hmsreliant.think-freely.org>
	 <b319ab74178e7f186081db90cc24c229127e42ad.1433524062.git.marcelo.leitner@gmail.com>
In-Reply-To: <b319ab74178e7f186081db90cc24c229127e42ad.1433524062.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mleitner@redhat.com
Cc: Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, Vlad Yasevich <vyasevich@gmail.com>, Michio Honda <micchie@sfc.wide.ad.jp>

On Fr, 2015-06-05 at 14:08 -0300, mleitner@redhat.com wrote:
>       if (sp->do_auto_asconf) {
> +             spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
>               sp->do_auto_asconf = 0;
> -             list_del(&sp->auto_asconf_list);
> +             list_del_rcu(&sp->auto_asconf_list);
> +             spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
>       }

This also looks a bit unsafe to me:

My proposal would be to sock_hold/sock_put the sockets when pushing them
onto the auto_asconf_list and defer the modifications on the list until
we don't need to hold socket lock anymore (in syscalls we do have a reference
anyway).

addr_wq_lock then is only used either without lock_sock at all or only
in order addr_wq_lock -> lock_sock, which does not cause any locking
ordering issues.

Bye,
Hannes

