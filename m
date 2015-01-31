From: David Miller <davem@davemloft.net>
Date: Sat, 31 Jan 2015 01:45:43 +0000
Subject: Re: [PATCH net] net: sctp: fix passing wrong parameter header to param_type2af in sctp_process_param
Message-Id: <20150130.174543.641220081613613919.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1422525958-5737-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1422525958-5737-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: vyasevich@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, saran.neti@telus.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 29 Jan 2015 11:05:58 +0100

> From: Saran Maruti Ramanara <saran.neti@telus.com>
> 
> When making use of RFC5061, section 4.2.4. for setting the primary IP
> address, we're passing a wrong parameter header to param_type2af(),
> resulting always in NULL being returned.
> 
> At this point, param.p points to a sctp_addip_param struct, containing
> a sctp_paramhdr (type = 0xc004, length = var), and crr_id as a correlation
> id. Followed by that, as also presented in RFC5061 section 4.2.4., comes
> the actual sctp_addr_param, which also contains a sctp_paramhdr, but
> this time with the correct type SCTP_PARAM_IPV{4,6}_ADDRESS that
> param_type2af() can make use of. Since we already hold a pointer to
> addr_param from previous line, just reuse it for param_type2af().
> 
> Fixes: d6de3097592b ("[SCTP]: Add the handling of "Set Primary IP Address" parameter to INIT")
> Signed-off-by: Saran Maruti Ramanara <saran.neti@telus.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks.
