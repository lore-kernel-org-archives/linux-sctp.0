From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 23 May 2011 02:19:20 +0000
Subject: Re: [Question] About Multi-homing in LKSCTP
Message-Id: <4DD9C428.9090405@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1305852113.16286.9.camel@SLinux>
In-Reply-To: <1305852113.16286.9.camel@SLinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> In LKSCTP with multi-homing, if association using 4 IP(list Ip1 Ip2 Ip3
> IP4 and bandwith,delay different) and peer have 3 IP (IP5 Ip 6 Ip7 ).
> When establish association, primary path is IP1-IP5, if path IP1-IP5
> die, how is SCTP choose new path? (select by best bandwith and delay or
> list IP).

select by list IPs.

the side which have4 IP will try to select transport to IP6 or IP7 to resend data
if they are active. and the peer with have 3 IP will try to select transport to IP2,
Ip3, Ip4 to resend data.

> And in RFC have sentence "Furthermore, when its peer is multi-homed, an
> endpoint SHOULD try to retransmit a chunk that timed out to an active
> destination transport address that is different from the last
> destination address to which the DATA chunk was sent." in section 6.4
> In LKSCTP use this feature or not? If not, which do LKSCTP use?

LKSCTP using this feature.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
