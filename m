From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 06 Apr 2011 01:12:00 +0000
Subject: Re: API SCTP,about problem multi-homing
Message-Id: <4D9BBDE0.8090803@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1301953102.5235.8.camel@thanh.pc>
In-Reply-To: <1301953102.5235.8.camel@thanh.pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> My name Thanh Nguyen. Student of University of science Ho Chi Minh City.
> I have seen in paper of socket API SCTP.I don't know how do client
> declare using multihoming?
> Server can using blindx(), but client can't using.

blindx()? sctp_bindx()?

client can using sctp_bindx() too.

http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-27#section-9.1

> I need one example single code client and server.about multi-homing in
> SCTP. Plesase send code to me.
> And when I run code example SCTP on web of Oracle,chunk heartbeat send
> all time if media freed, but in apps sctp_darn is not.Why?How using
> event and notification. In paper have only one structure of notification
> and enable.

Using SCTP_EVENTS option to enable  notifications.

http://tools.ietf.org/html/draft-ietf-tsvwg-sctpsocket-27#page-53

> Thanks a lot.
>   
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
