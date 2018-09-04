From: David Miller <davem@davemloft.net>
Date: Tue, 04 Sep 2018 04:58:27 +0000
Subject: Re: [PATCH net 0/2] sctp: two fixes for spp_ipv6_flowlabel and spp_dscp sockopts
Message-Id: <20180903.215827.2193268936693568324.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535960717.git.lucien.xin@gmail.com>
        <20180903220606.GA19741@localhost.localdomain>
In-Reply-To: <20180903220606.GA19741@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 3 Sep 2018 19:06:06 -0300

> On Mon, Sep 03, 2018 at 03:47:09PM +0800, Xin Long wrote:
>> This patchset fixes two problems in sctp_apply_peer_addr_params()
>> when setting spp_ipv6_flowlabel or spp_dscp.
>> 
>> Xin Long (2):
>>   sctp: fix invalid reference to the index variable of the iterator
>>   sctp: not traverse asoc trans list if non-ipv6 trans exists for
>>     ipv6_flowlabel
>> 
>>  net/sctp/socket.c | 34 +++++++++++++++++++---------------
>>  1 file changed, 19 insertions(+), 15 deletions(-)
> 
> Series
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Series applied.
