From: David Miller <davem@davemloft.net>
Date: Wed, 01 Nov 2017 12:26:54 +0000
Subject: Re: [PATCH net-next] sctp: fix error return code in sctp_send_add_streams()
Message-Id: <20171101.212654.2226126937177129059.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1509456496-93944-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1509456496-93944-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: weiyongjun1@huawei.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Tue, 31 Oct 2017 13:28:16 +0000

> Fix to returnerror code -ENOMEM from the sctp_make_strreset_addstrm()
> error handling case instead of 0. 'retval' can be overwritten to 0 after
> call sctp_stream_alloc_out().
> 
> Fixes: e090abd0d81c ("sctp: factor out stream->out allocation")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
