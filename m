From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 06 Jun 2008 14:31:17 +0000
Subject: Re: [PATCH] SCTP: Validate initiate tag and chunk type if	verification
Message-Id: <48494A35.9040904@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4848E5FE.7080309@cn.fujitsu.com>
In-Reply-To: <4848E5FE.7080309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Neil Horman wrote:
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I see that the the above comments relate specifically to ICMP6, but
> sctp_err_lookup is common between ipv4 and ipv6 sctp.  I assume the same

Neil,  ICMP6 is the just bullet 6 from the ICMP processing, not a reference to
ICMPv6 protocol.

-vlad

> verification requirement is common to v4 and v6 as well (despite the comment).
> I don't see how it can hurt to check in both cases, but I wanted to be certain.
> 
> Regards
> Neil
> 

