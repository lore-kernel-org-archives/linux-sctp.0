From: David Miller <davem@davemloft.net>
Date: Thu, 18 Oct 2018 05:33:01 +0000
Subject: Re: [PATCH net] sctp: fix the data size calculation in sctp_data_size
Message-Id: <20181017.223301.1736365428024550667.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <c407b682a424f0441d9b9a29ef6296c8e9824b64.1539781887.git.lucien.xin@gmail.com>
In-Reply-To: <c407b682a424f0441d9b9a29ef6296c8e9824b64.1539781887.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 17 Oct 2018 21:11:27 +0800

> sctp data size should be calculated by subtracting data chunk header's
> length from chunk_hdr->length, not just data header.
> 
> Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
