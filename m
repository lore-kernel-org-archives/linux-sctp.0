From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 06 Dec 2012 18:28:40 +0000
Subject: Re: [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
Message-Id: <20121206182840.GD16122@casper.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <a803093c70e857e8e01e554288ee79f66f7acda4.1354814846.git.tgraf@suug.ch>
 <50C0E300.3000703@gmail.com>
In-Reply-To: <50C0E300.3000703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/06/12 at 01:25pm, Vlad Yasevich wrote:
> May want to avoid printing addresses that are !addr->valid.
> 
> Otherwise looks good.

Good point, I'll send a follow-up patch if that is OK. Same
applies to dead transports obviously.
