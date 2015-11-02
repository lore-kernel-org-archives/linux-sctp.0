From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 02 Nov 2015 13:07:42 +0000
Subject: Re: Max.Init.Retransmits and ABORT response to INIT
Message-Id: <5637601E.4030606@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAB3A_j95dYXpM9bd1vuSo-1mOjtpwauoxQCcBZLmpFywBmmPMA@mail.gmail.com>
In-Reply-To: <CAB3A_j95dYXpM9bd1vuSo-1mOjtpwauoxQCcBZLmpFywBmmPMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/30/2015 08:03 PM, Ian Coolidge wrote:
> Hello,
> 
> With the Linux SCTP implementation, Max.Init.Retransmits is respected
> when INIT messages do not receive a response (ie, if SCTP host is
> unavailable). However, if a Linux SCTP host is accessible, but has no
> SCTP servers listening for incoming connections, it will quickly reply
> ABORT. This doesn't trigger the Max.Init.Retransmits logic, so,
> retries occur indefinitely.
> 
> I looked through RFC 2960 for some guidance here. Both 3.3.7 and 4
> were unclear for how this should be handled. I suspect that these
> ABORT responses to INIT should count towards Max.Init.Retransmits.
> 
> Is there any clarification that I haven't found?
> 
> What do the SCTP experts think should happen here?
> 

An ABORT should terminate the association thus stopping any further
INIT transmissions.  Is that not happening?

-vlad

> Thanks
> Ian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

