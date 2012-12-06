From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 06 Dec 2012 19:16:36 +0000
Subject: Re: [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
Message-Id: <20121206191636.GD17192@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <a803093c70e857e8e01e554288ee79f66f7acda4.1354814846.git.tgraf@suug.ch>
 <50C0E300.3000703@gmail.com>
 <20121206182840.GD16122@casper.infradead.org>
In-Reply-To: <20121206182840.GD16122@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Graf <tgraf@suug.ch>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Thu, Dec 06, 2012 at 06:28:40PM +0000, Thomas Graf wrote:
> On 12/06/12 at 01:25pm, Vlad Yasevich wrote:
> > May want to avoid printing addresses that are !addr->valid.
> > 
> > Otherwise looks good.
> 
> Good point, I'll send a follow-up patch if that is OK. Same
> applies to dead transports obviously.
Assuming a followup patch to avoid dead addresses..
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
