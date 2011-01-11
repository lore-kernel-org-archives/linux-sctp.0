From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 11 Jan 2011 09:12:35 +0000
Subject: Re: Question regarding struct sctp_association
Message-Id: <4D2C1F03.3070101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D2AF2C3.8010306@freyther.de>
In-Reply-To: <4D2AF2C3.8010306@freyther.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> Hi,
>
> I have a small consistency question. In sctp_packet_transmit of
> net/sctp/output.c some parts of the method check if the asoc is valid, other
> assume that there is one.
>
> I have some questions regarding that.
>
> The sctp_packet has a pointer to sctp_transport. Does every sctp_transport
> hold a valid pointer to sctp_association? Does it hold a valid pointer if


assoc not always valid, when we response to an OOTB packet, the
assoc will be NULL.


> authentication (sctp_auth) is used? Does it hold a valid pointer if chunks
> were seen?
>
> regards
> 	holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
