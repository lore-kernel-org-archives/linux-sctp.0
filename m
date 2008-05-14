From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 14 May 2008 01:09:12 +0000
Subject: Re: [Lksctp-developers] [RFC PATCH v2] Fast retransmit fixes
Message-Id: <482A3BB8.3030204@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Vlad:

This patch set cannot resolve Fast Recovery problem correctly.

Test Procedure:

Endpoint A                       Endpoint B
DATA (TSN = 1)  ------------->
DATA (TSN = 2)  -- (lost)---->
DATA (TSN = 3)  ---(lost)---->
DATA (TSN = 4)  ------------->
DATA (TSN = 5)  ------------->
                <-------------   SACK (CTSN = 1)
DATA (TSN = 6)  ------------->
                <-------------   SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 3)
                <------------    SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 4)
                <------------    SACK (CTSN = 1, GAP-START = 3, GAP-ENT = 5) 
DATA (TSN = 2)  -(fast rtx)-->
                <-------------   SACK (CTSN = 2, GAP-START = 2, GAP-ENT = 4)
DATA (TSN = 3)  -(can not do fast rtx)--

I am not sure is this a bug of your patch because I used this patchset 
manually. Can you check for this test?

Wei Yongjun


Vlad Yasevich wrote:
> This is an update to the Fast retransmit changes.
>
> This fixes a small bug introduced by a prior series where the fast_rtx
> hint in the outq structure was never cleared.
>
> All prior comments still stand.
>
>
>   

