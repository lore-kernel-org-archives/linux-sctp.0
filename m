From: David Miller <davem@davemloft.net>
Date: Fri, 25 Jan 2019 02:25:06 +0000
Subject: Re: [PATCH net] sctp: improve the events for sctp stream reset
Message-Id: <20190124.182506.271204705053172488.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc740e7814086bd4d759c39310c98b214a76ae21.1548095974.git.lucien.xin@gmail.com>
In-Reply-To: <dc740e7814086bd4d759c39310c98b214a76ae21.1548095974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Jan 2019 02:39:34 +0800

> This patch is to improve sctp stream reset events in 4 places:
> 
>   1. In sctp_process_strreset_outreq(), the flag should always be set with
>      SCTP_STREAM_RESET_INCOMING_SSN instead of OUTGOING, as receiver's in
>      stream is reset here.
>   2. In sctp_process_strreset_outreq(), move up SCTP_STRRESET_ERR_WRONG_SSN
>      check, as the reset has to succeed after reconf_timer stops for the
>      in stream reset request retransmission.
>   3. In sctp_process_strreset_inreq(), no event should be sent, as no in
>      or out stream is reset here.
>   4. In sctp_process_strreset_resp(), SCTP_STREAM_RESET_INCOMING_SSN or
>      OUTGOING event should always be sent for stream reset requests, no
>      matter it fails or succeeds to process the request.
> 
> Fixes: 810544764536 ("sctp: implement receiver-side procedures for the Outgoing SSN Reset Request Parameter")
> Fixes: 16e1a91965b0 ("sctp: implement receiver-side procedures for the Incoming SSN Reset Request Parameter")
> Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Reconf Response Parameter")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
