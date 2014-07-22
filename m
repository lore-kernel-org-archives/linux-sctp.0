From: Michele Baldessari <michele@acksyn.org>
Date: Tue, 22 Jul 2014 08:03:04 +0000
Subject: Re: Information about SCTP patch
Message-Id: <20140722080304.GB7011@fante.int.rhx>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ5TDg_0GjTWVin1Xr4sZwNhzMiT+bJPZwzfKB0xBdPMuK7T+g@mail.gmail.com>
 <20140627200644.GA9086@marquez.int.rhx>
 <CAJ5TDg_qOkpGe7Ouzn_wfbsODL4FoVLmq7EmQes6hEW-dnMLWg@mail.gmail.com>
In-Reply-To: <CAJ5TDg_qOkpGe7Ouzn_wfbsODL4FoVLmq7EmQes6hEW-dnMLWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kishan simha <ksimha123@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, prasad.padiyar@nsn.com, sumit.11.kumar@nsn.com

Hi Kishan,

On Mon, Jul 21, 2014 at 02:08:21PM +0530, kishan simha wrote:
> We are trying to integrate this patch to a little older kernel 2.6.34.13.

This is trivial as we've done so for RHEL 6.5 already.

> Additionally we are planning to give a proc file interface to display the stats.
> 
> I came across a review comment for your patch, where the proc solution
> was rejected.
> 
> Can you provide some information on why the solution was rejected ?

It was preferred to do it via an API extension, similar to how
Solaris does it. And, I believe, the /proc interface for these kind of
things is discouraged.

regards,
Michele
-- 
Michele Baldessari            <michele@acksyn.org>
C2A5 9DA3 9961 4FFB E01B  D0BC DDD4 DCCB 7515 5C6D
