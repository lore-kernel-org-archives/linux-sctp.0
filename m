From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 17 Jun 2014 13:40:55 +0000
Subject: Re: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <53A04567.7030905@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403006273-27859-1-git-send-email-geirola@gmail.com>
In-Reply-To: <1403006273-27859-1-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Geir Ola Vaagland <geirola@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org

On 06/17/2014 07:57 AM, Geir Ola Vaagland wrote:

Hi Geir

Please provide a bit more description for the those who are not familiar
with the series.

Thanks
-vlad


> Geir Ola Vaagland (6):
>   Support for SCTP_RECVRCVINFO socket option
>   Support for SCTP_RCVINFO ancillary data
>   Support for SCTP_SNDINFO ancillary data
>   Support for SCTP_NXTINFO socket option
>   Support for receiving SCTP_NXTINFO ancillary data
>   Support for SCTP_DEFAULT_SNDINFO socket option
> 
>  include/net/sctp/structs.h  |  11 +-
>  include/net/sctp/ulpevent.h |   4 +
>  include/uapi/linux/sctp.h   |  46 ++++++++
>  net/sctp/socket.c           | 260 ++++++++++++++++++++++++++++++++++++++++++--
>  net/sctp/ulpevent.c         | 158 +++++++++++++++++++++++++++
>  5 files changed, 470 insertions(+), 9 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

