From: David Miller <davem@davemloft.net>
Date: Mon, 01 Aug 2016 20:43:38 +0000
Subject: Re: [PATCH net] sctp: change to use TCP_CLOSE_WAIT as SCTP_SS_CLOSING
Message-Id: <20160801.134338.1321082120977901489.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0517133e5f1dee8136f3a1c3bfaac522fe98e599.1469880045.git.lucien.xin@gmail.com>
In-Reply-To: <0517133e5f1dee8136f3a1c3bfaac522fe98e599.1469880045.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, vyasevich@gmail.com, daniel@iogearbox.net

From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Jul 2016 20:00:45 +0800

> Prior to this patch, sctp defined TCP_CLOSING as SCTP_SS_CLOSING.
> TCP_CLOSING is such a special sk state in TCP that inet common codes
> even exclude it.
> 
> For instance, inet_accept thinks the accept sk's state never be
> TCP_CLOSING, or it will give a WARN_ON. TCP works well with that
> while SCTP may trigger the call trace, as CLOSING state in SCTP
> has different meaning from TCP.
> 
> This fix is to change to use TCP_CLOSE_WAIT as SCTP_SS_CLOSING,
> instead of TCP_CLOSING. Some side-effects could be expected,
> regardless of not being used before. inet_accept will accept it
> now.
> 
> I did all the func_tests in lksctp-tools and ran sctp codnomicon
> fuzzer tests against this patch, no regression or failure found.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
