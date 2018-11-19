From: David Miller <davem@davemloft.net>
Date: Mon, 19 Nov 2018 22:47:09 +0000
Subject: Re: [PATCH net] sctp: not increase stream's incnt before sending addstrm_in request
Message-Id: <20181119.144709.2229023752451770304.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <74669ed0fa48471de2b6b1ebb3580858e4fa7895.1542549589.git.lucien.xin@gmail.com>
In-Reply-To: <74669ed0fa48471de2b6b1ebb3580858e4fa7895.1542549589.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 21:59:49 +0800

> Different from processing the addstrm_out request, The receiver handles
> an addstrm_in request by sending back an addstrm_out request to the
> sender who will increase its stream's in and incnt later.
> 
> Now stream->incnt has been increased since it sent out the addstrm_in
> request in sctp_send_add_streams(), with the wrong stream->incnt will
> even cause crash when copying stream info from the old stream's in to
> the new one's in sctp_process_strreset_addstrm_out().
> 
> This patch is to fix it by simply removing the stream->incnt change
> from sctp_send_add_streams().
> 
> Fixes: 242bd2d519d7 ("sctp: implement sender-side procedures for Add Incoming/Outgoing Streams Request Parameter")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
