From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 20 Oct 2009 23:40:12 +0000
Subject: Re: question on SCTP_DELAYED_ACK and sctp_sack_info
Message-Id: <4ADE4A5C.3010006@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4ADE31EF.5040409@nortel.com>
In-Reply-To: <4ADE31EF.5040409@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Chris Friesen wrote:
> Hi all,
> 
> I've got a question about the handling of SCTP_DELAYED_ACK.
> 
> In sctp_setsockopt_delayed_ack() the code looks to see if the size of
> the struct being passed down matches the size of struct sctp_sack_info.
>  If it doesn't, it accepts being passed struct sctp_assoc_value but it
> complains about it.
> 
> However, the lksctp-tools package doesn't seem to define or use struct
> sctp_sack_info anywhere, only struct sctp_assoc_value.
> 
> Are apps expected to copy the struct definition themselves?  Is there
> any plan to update lksctp-tools?

Yes.  I have to get my a** in gear and do a release.

If you pull the sources from
git://git.kernel.org/pub/scm/linux/kernel/git/vxy/lksctp-tools.git

you'll get an updated one.

I am going to spend some time tomorrow to get that code out.

Thanks for a kick in the pants
-vlad

> 
> Thanks,
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
