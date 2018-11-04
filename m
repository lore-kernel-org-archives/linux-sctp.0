From: David Miller <davem@davemloft.net>
Date: Sun, 04 Nov 2018 02:39:52 +0000
Subject: Re: [PATCH net] sctp: fix strchange_flags name for Stream Change Event
Message-Id: <20181103.193952.374336389543810282.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <34b8e0475a841d258c2165b5a46a72c373e52976.1541224785.git.lucien.xin@gmail.com>
In-Reply-To: <34b8e0475a841d258c2165b5a46a72c373e52976.1541224785.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sat,  3 Nov 2018 13:59:45 +0800

> As defined in rfc6525#section-6.1.3, SCTP_STREAM_CHANGE_DENIED
> and SCTP_STREAM_CHANGE_FAILED should be used instead of
> SCTP_ASSOC_CHANGE_DENIED and SCTP_ASSOC_CHANGE_FAILED.
> 
> To keep the compatibility, fix it by adding two macros.
> 
> Fixes: b444153fb5a6 ("sctp: add support for generating add stream change event notification")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
