From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 02:14:15 +0000
Subject: Re: [PATCH 2/3] sctp: export SctpT1Retransmits to /proc/net/sctp/snmp
Message-Id: <4C313FF7.9050804@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C2DA094.3000601@cn.fujitsu.com>
In-Reply-To: <4C2DA094.3000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi vlad:

Vlad Yasevich wrote, at 07/02/2010 10:31 PM:
> Why do you need that when we already have SctpT1InitExpireds and
> SctpT1CookieExpireds.  Just sum them together and you get the
> the T1_RETRANSMITS.

T1_RETRANSMITS is not equal to the summation of  SctpT1InitExpireds
and SctpT1CookieExpireds.

If an host received stale cookie error at COOKIE-ECHOED state,
it will sent a new INIT chunk to the endpoint and restart to set up
the association. The resented new INIT chunk is counted to T1_RETRANSMITS.

SctpT1InitExpireds/SctpT1CookieExpireds is counted for timeout event of
T1_INIT/T1_COOKIE.

-- 
Best Regards
-----
Shan Wei
