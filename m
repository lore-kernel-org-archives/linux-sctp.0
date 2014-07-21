From: kishan simha <ksimha123@gmail.com>
Date: Mon, 21 Jul 2014 08:50:21 +0000
Subject: Re: Information about SCTP patch
Message-Id: <CAJ5TDg_qOkpGe7Ouzn_wfbsODL4FoVLmq7EmQes6hEW-dnMLWg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJ5TDg_0GjTWVin1Xr4sZwNhzMiT+bJPZwzfKB0xBdPMuK7T+g@mail.gmail.com>
	<20140627200644.GA9086@marquez.int.rhx>
In-Reply-To: <20140627200644.GA9086@marquez.int.rhx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michele Baldessari <michele@acksyn.org>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, prasad.padiyar@nsn.com, sumit.11.kumar@nsn.com

Hello Michele,

Thank you for the response.

I have a few more queries regarding the patch.

We are trying to integrate this patch to a little older kernel 2.6.34.13.
Additionally we are planning to give a proc file interface to display the stats.

I came across a review comment for your patch, where the proc solution
was rejected.

Can you provide some information on why the solution was rejected ?

Thanks and Regards
Kishan



On Sat, Jun 28, 2014 at 1:36 AM, Michele Baldessari <michele@acksyn.org> wrote:
> Hi Kishan,
>
> On Thu, Jun 26, 2014 at 12:58:54PM +0530, kishan simha wrote:
>> I wanted some information on the SCTP patch   "sctp: Add support to
>> per-association statistics via a new SCTP_GET_ASSOC_STA "
>>
>> The commit information is
>> commit 196d67593439b03088913227093e374235596e33
>> Author: Michele Baldessari <michele@acksyn.org>
>> Date:   Sat Dec 1 04:49:42 2012 +0000
>>
>> Is it possible to know into which kernel version did this patch go into?
>> I tried to find it online and I was not able to. Hence mailing to this list.
>
> as Eric mentioned, it's in 3.8 (or also in RHEL-6.5). Feel free to reach out
> if you have any questions.
>
> cheers,
> Michele
> --
> Michele Baldessari            <michele@acksyn.org>
> C2A5 9DA3 9961 4FFB E01B  D0BC DDD4 DCCB 7515 5C6D
