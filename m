From: Simon Horman <horms@verge.net.au>
Date: Mon, 28 Oct 2013 08:50:25 +0000
Subject: Re: [PATCH ipvs 2/2] net: ipvs: sctp: do not recalc sctp checksum when not needed
Message-Id: <20131028085024.GA26154@verge.net.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
In-Reply-To: <8390127344501c35ed3c23f3690b8a671d353870.1382689350.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Oct 28, 2013 at 09:11:41AM +0100, Daniel Borkmann wrote:
> On 10/28/2013 02:39 AM, Simon Horman wrote:
> 
> >I am happy to take the 1st patch of the series as-is.
> >Let me know if that works for you.
> 
> Yes, sure. Then, I'll only resend the 2nd one today.

Thanks, I have pushed it to ipvs-next.

I will hold off on sending a pull-request to Pablo until you send
the 2nd patch.
