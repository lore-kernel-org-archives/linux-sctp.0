From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 05 Mar 2015 14:04:15 +0000
Subject: Re: Does IPv6 have to be enabled to run lksctp-tools?
Message-Id: <20150305140415.GA27783@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
In-Reply-To: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Mar 04, 2015 at 12:59:21PM -0800, Jerry Jerry wrote:
> Hello,
> 
> We had a strange problem using lksctp-tool where checksctp would hang
> there on some of our machines and process cannot be killed anyway
> (with status d/d+). After some investigation, we found out that
> whether ipv6 is enabled could impact the behavior of the library. So,
> my question is that, is this a requirement by design or it just
> happens to occur that ipv6 is required? Any suggestion to bypass this
> (not to rely on ipv6) would be appreciated very much.
> 
> Regards,
> Jerry
IIRC there should be no ipv6 requierment.

Where does the checksctp tool hang?  Is it in user space or the kernel?  Can you
provide a backtrace, either ia gdb if its in userspace or sysrq in the kernel?

Best
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
