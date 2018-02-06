From: David Miller <davem@davemloft.net>
Date: Tue, 06 Feb 2018 02:22:54 +0000
Subject: Re: [PATCH] sctp: fix dst refcnt leak in sctp_v6_get_dst()
Message-Id: <20180205.212254.1398375397369589049.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1517832635-18376-1-git-send-email-alexey.kodanev@oracle.com>
In-Reply-To: <1517832635-18376-1-git-send-email-alexey.kodanev@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alexey.kodanev@oracle.com
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, tommi.t.rantala@nokia.com, nhorman@tuxdriver.com, vyasevich@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org

From: Alexey Kodanev <alexey.kodanev@oracle.com>
Date: Mon,  5 Feb 2018 15:10:35 +0300

> When going through the bind address list in sctp_v6_get_dst() and
> the previously found address is better ('matchlen > bmatchlen'),
> the code continues to the next iteration without releasing currently
> held destination.
> 
> Fix it by releasing 'bdst' before continue to the next iteration, and
> instead of introducing one more '!IS_ERR(bdst)' check for dst_release(),
> move the already existed one right after ip6_dst_lookup_flow(), i.e. we
> shouldn't proceed further if we get an error for the route lookup.
> 
> Fixes: dbc2b5e9a09e ("sctp: fix src address selection if using secondary addresses for ipv6")
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>

Applied and queued up for -stable, thank you.
