From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 14 May 2008 14:45:17 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH v2] Fast retransmit fixes
Message-Id: <482AFAFD.1020208@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <482A3BB8.3030204@cn.fujitsu.com>
In-Reply-To: <482A3BB8.3030204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Hi Vlad:
> 
> This patch set cannot resolve Fast Recovery problem correctly.
> 
> Test Procedure:
> 
> Endpoint A                       Endpoint B
> DATA (TSN = 1)  ------------->
> DATA (TSN = 2)  -- (lost)---->
> DATA (TSN = 3)  ---(lost)---->
> DATA (TSN = 4)  ------------->
> DATA (TSN = 5)  ------------->
>                <-------------   SACK (CTSN = 1)
> DATA (TSN = 6)  ------------->
>                <-------------   SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 3)
>                <------------    SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 4)
>                <------------    SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 
> 5) DATA (TSN = 2)  -(fast rtx)-->
>                <-------------   SACK (CTSN = 2, GAP-START = 2, GAP-ENT = 4)
> DATA (TSN = 3)  -(can not do fast rtx)--
> 
> I am not sure is this a bug of your patch because I used this patchset 
> manually. Can you check for this test?
> 

Hi Wei

Yes,  I forgot to remove the call to sctp_list_dequeue() in sctp_outq_flush_rtx().
That's what was causing this error.

There was only one other small bug in the patch that I found with this scenario.  These
all stem from me attempting to break on 1 big patch into 3 smaller ones.

Anyway, I'll repost.

Thanks
-vlad
