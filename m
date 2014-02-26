From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 26 Feb 2014 12:10:04 +0000
Subject: Re: Why is not const used for parameters in the socket API?
Message-Id: <20140226121004.GA19027@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <D7BA2F9242E12945A40DB1D20344484413C3DD3D@stomail01.se.aastra.com>
In-Reply-To: <D7BA2F9242E12945A40DB1D20344484413C3DD3D@stomail01.se.aastra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Feb 26, 2014 at 08:27:01AM +0100, Roger Nyberg wrote:
> 
> Why isn't const used in the socket API to make it clearer?
> Example:
>  
> int sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr
> *to,
>                  socklen_t tolen, uint32_t ppid, uint32_t flags,
>                  uint16_t stream_no, uint32_t timetolive, uint32_t
> context);
> 
> If i am not missing something, i guess the "struct sockaddr *to" could
> be const (that is: "const struct sockaddr *to").
> 
> Please use const for every paramater where it is possible. This makes
> usage simpler. There are more functions than the (sctp_sendmsg) where
> parameters can const.
> 

Send a patch?

Neil

> /Roger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
