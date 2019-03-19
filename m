From: David Miller <davem@davemloft.net>
Date: Tue, 19 Mar 2019 01:24:15 +0000
Subject: Re: [PATCHv2 net] sctp: get sctphdr by offset in sctp_compute_cksum
Message-Id: <20190318.182415.2239605199956582343.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <8a056742d5bb1f4f799890714de38dec193aadea.1552909620.git.lucien.xin@gmail.com>
In-Reply-To: <8a056742d5bb1f4f799890714de38dec193aadea.1552909620.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, fw@strlen.de, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Mar 2019 19:47:00 +0800

> sctp_hdr(skb) only works when skb->transport_header is set properly.
> 
> But in Netfilter, skb->transport_header for ipv6 is not guaranteed
> to be right value for sctphdr. It would cause to fail to check the
> checksum for sctp packets.
> 
> So fix it by using offset, which is always right in all places.
> 
> v1->v2:
>   - Fix the changelog.
> 
> Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
