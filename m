From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 21 Nov 2008 14:48:10 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081121144810.GB5339@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri 21-11-08 09:28:37, Vlad Yasevich wrote:
> Michal
> 
> This really smells like the corruption of the sctp_packet structure.
> The number chunks printout out is 0, but the list appears to have multiple
> entries on it.
> 
> Can you turn on CONFIG_DEBUG_LIST and may be even turn on memory
> debugging as well.

OK, I have turned on CONFIG_DEBUG_LIST, CONFIG_DEBUG_VM and
CONFIG_PRINTK_TIME


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
