From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 03 Aug 2020 17:42:32 +0000
Subject: Re: Regarding kernel SCTP module compliance to 4960
Message-Id: <20200803174232.GE3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAMyZL9pE+343HvMHuci=+2aKS4HrtuL2GJ2oVwxw7PfL7=doKQ@mail.gmail.com>
In-Reply-To: <CAMyZL9pE+343HvMHuci=+2aKS4HrtuL2GJ2oVwxw7PfL7=doKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Aug 03, 2020 at 03:53:35PM +0530, sonia bhattacharya wrote:
> Hi Team,
> 
> 
> 
> Is there a plan to upgrade the linux SCTP kernel module to be
> compliant to RFC 4960?
> 
> Right now, it is compliant to RFC 2960.
> 
> 
> description:    Support for the SCTP protocol (RFC2960)

Hi Sonia,

There are several references to old RFCs throughout the code, just
because they weren't updated to the newer versions. But in regards to
your question, Linux SCTP kernel code is compliant to RFC4960 already.
If you notice anything particular missing, it's a bug. :-)

Thanks,
Marcelo
