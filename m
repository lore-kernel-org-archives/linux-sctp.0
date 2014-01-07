From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 07 Jan 2014 14:12:31 +0000
Subject: Re: SCTP SIOCOUTQ ioctl
Message-Id: <20140107141231.GB12366@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbX9kWb0zDAG69tbENGzcY3vjqtigie2QXmTAuMUrN0d+Q@mail.gmail.com>
In-Reply-To: <CAGugRbX9kWb0zDAG69tbENGzcY3vjqtigie2QXmTAuMUrN0d+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Jan 06, 2014 at 11:33:57AM -0500, Karl Heiss wrote:
> Is there any reason why there is a SIOCINQ ioctl for SCTP sockets, but
> SIOCOUTQ is not supported?  It seems on the surface like it should be
> trivial to implement, but is there a more complex reason why it is not
> present?
> 
Probably because their linux-only and not especially well defined.  You can get
almost the exact same data from the netstat command that interprets the socket
proc files.

Neil

> Regards,
> Karl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
