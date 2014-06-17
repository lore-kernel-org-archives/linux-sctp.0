From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 17 Jun 2014 12:32:16 +0000
Subject: RE: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1725DC3F@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403006273-27859-1-git-send-email-geirola@gmail.com>
In-Reply-To: <1403006273-27859-1-git-send-email-geirola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Geir Ola Vaagland' <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Geir Ola Vaagland
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

You need to make your C match the expected layout for kernel code.
In particular the whitespace rules.

	David



