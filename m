From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 04 Nov 2013 12:09:14 +0000
Subject: Re: Multi-homing question
Message-Id: <20131104120914.GA31372@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
In-Reply-To: <CAJ0j_BaKwMix1-N-+5RnT2BLZNi5Usz3XA8V5Ygr6mMExrDesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Nov 04, 2013 at 09:59:44AM +0800, tsoi andrew wrote:
> Dear Sir,
> 
> I got a problem when set multi-homing to active/active.
> That mean, It is expected that our lksctp server have 2 IP to connect
> 2 IP of destination client with total 4 connections.
> The flow is that client send "INIT" message with 2 (primary and
> secondary) IP to our server and lksctp server return INIT_ACK. But
> when second client send 'heartbeat' to us, lksctp server cannot return
> ACK.
> Moreover, we already proved our connectivity correct because when our
> lksctp server send heartbeat to both destination client and they can
> return ACK.
> Would you mind sharing if lksctp lib already configure those
> multi-homing purpose.
> 
Can you provide a network diagram and a tcpdump of your connection?
Neil

> 
> 
> Best Regards,
> Andrew Tsoi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
