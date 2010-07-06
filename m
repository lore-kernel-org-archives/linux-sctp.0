From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 06 Jul 2010 13:38:20 +0000
Subject: Re: [PATCH 2/3] sctp: export SctpT1Retransmits to /proc/net/sctp/snmp
Message-Id: <4C3331CC.2040907@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C2DA094.3000601@cn.fujitsu.com>
In-Reply-To: <4C2DA094.3000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Shan Wei wrote:
> Hi vlad:
> 
> Vlad Yasevich wrote, at 07/02/2010 10:31 PM:
>> Why do you need that when we already have SctpT1InitExpireds and
>> SctpT1CookieExpireds.  Just sum them together and you get the
>> the T1_RETRANSMITS.
> 
> T1_RETRANSMITS is not equal to the summation of  SctpT1InitExpireds
> and SctpT1CookieExpireds.
> 
> If an host received stale cookie error at COOKIE-ECHOED state,
> it will sent a new INIT chunk to the endpoint and restart to set up
> the association. The resented new INIT chunk is counted to T1_RETRANSMITS.
> 
> SctpT1InitExpireds/SctpT1CookieExpireds is counted for timeout event of
> T1_INIT/T1_COOKIE.
> 

So I fail to see the usefulness of showing and even keeping that counter.
When you look at the value, what new information will it provide you?

If it is only the retransmissions due to stale cookie error, then by all
means, track that value instead.  That would actually provide new and useful
data.  That's really the gist of my objection.  There is no reason to track
and display useless pieces of information.

-vlad
