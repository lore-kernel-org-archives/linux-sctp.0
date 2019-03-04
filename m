From: David Miller <davem@davemloft.net>
Date: Mon, 04 Mar 2019 18:59:30 +0000
Subject: Re: [PATCH net] sctp: call iov_iter_revert() after sending ABORT
Message-Id: <20190304.105930.1367812295017801292.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <d335a35e857c8f72d99032077b15df50ced4b7f9.1551603026.git.lucien.xin@gmail.com>
In-Reply-To: <d335a35e857c8f72d99032077b15df50ced4b7f9.1551603026.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun,  3 Mar 2019 16:50:26 +0800

> The user msg is also copied to the abort packet when doing SCTP_ABORT in
> sctp_sendmsg_check_sflags(). When SCTP_SENDALL is set, iov_iter_revert()
> should have been called for sending abort on the next asoc with copying
> this msg. Otherwise, memcpy_from_msg() in sctp_make_abort_user() will
> fail and return error.
> 
> Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
