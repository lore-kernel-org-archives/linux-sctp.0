From: David Miller <davem@davemloft.net>
Date: Tue, 17 Sep 2013 01:40:54 +0000
Subject: Re: [PATCH net] net: sctp: rfc4443: do not report ICMP redirects to user space
Message-Id: <20130916.214054.1994711412361848197.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1379327762-4638-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1379327762-4638-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, hannes@stressinduktion.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 16 Sep 2013 12:36:02 +0200

> Adapt the same behaviour for SCTP as present in TCP for ICMP redirect
> messages. For IPv6, RFC4443, section 2.4. says:
> 
>   ...
>   (e) An ICMPv6 error message MUST NOT be originated as a result of
>       receiving the following:
>   ...
>        (e.2) An ICMPv6 redirect message [IPv6-DISC].
>   ...
> 
> Therefore, do not report an error to user space, just invoke dst's redirect
> callback and leave, same for IPv4 as done in TCP as well. The implication
> w/o having this patch could be that the reception of such packets would
> generate a poll notification and in worst case it could even tear down the
> whole connection. Therefore, stop updating sk_err on redirects.
> 
> Reported-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable, thanks Daniel.
