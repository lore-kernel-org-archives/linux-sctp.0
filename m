From: David Miller <davem@davemloft.net>
Date: Fri, 01 Feb 2019 19:04:56 +0000
Subject: Re: [PATCH net] sctp: walk the list of asoc safely
Message-Id: <20190201.110456.1003158949772454122.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190201141522.GA20785@kroah.com>
In-Reply-To: <20190201141522.GA20785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 1 Feb 2019 15:15:22 +0100

> In sctp_sendmesg(), when walking the list of endpoint associations, the
> association can be dropped from the list, making the list corrupt.
> Properly handle this by using list_for_each_entry_safe()
> 
> Fixes: 4910280503f3 ("sctp: add support for snd flag SCTP_SENDALL process in sendmsg")
> Reported-by: Secunia Research <vuln@secunia.com>
> Tested-by: Secunia Research <vuln@secunia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied and queued up for -stable.
