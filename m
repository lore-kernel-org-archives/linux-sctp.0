From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 16 Dec 2013 15:44:13 +0000
Subject: Re: [PATCH] SCTP: Reduce log spamming for sctp setsockopt
Message-Id: <20131216154413.GD19809@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B749A@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B749A@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org

On Mon, Dec 16, 2013 at 03:24:48PM -0000, David Laight wrote:
> > From: Neil Horman
> > During a recent discussion regarding some sctp socket options, it was noted that
> > we have several points at which we issue log warnings that can be flooded at an
> > unbounded rate by any user.  Fix this by converting all the pr_warns in the
> > sctp_setsockopt path to be pr_warn_ratelimited.
> > 
> > Note there are several debug level messages as well.  I'm leaving those alone,
> > as, if you turn on pr_debug, you likely want lots of verbosity.
> ...
> > -		pr_warn("Use of struct sctp_assoc_value in delayed_ack socket option deprecated\n");
> > -		pr_warn("Use struct sctp_sack_info instead\n");
> > +		pr_warn_ratelimited("Use of struct sctp_assoc_value in delayed_ack socket option
> > deprecated\n");
> > +		pr_warn_ratelimited("Use struct sctp_sack_info instead\n");
> 
> Do you need to send these as a single ratelimited message?
> 
> 	David
> 
Oh, good point, I'll clean that up.  Thanks!
Neil

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
