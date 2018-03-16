From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Mar 2018 17:36:14 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180316173614.GB4832@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 16, 2018 at 03:54:49PM +0000, David Neil wrote:
> Marcelo,
> Thanks for the quick response.
> 
> The output of uname -a is:
> Linux li1074-63 4.15.7-x86_64-linode102 #1 SMP Wed Feb 28 16:39:31 UTC 2018 x86_64 GNU/Linux

Nice, a very updated one.

> 
> This is a Linode pre-built Debian 9 kernel with CONFIG_DYNAMIC_DEBUG not set.

If it's off than that code isn't there, meaning we can't attach a perf
probe or so. The function is also inlined, so we can't attach to its
return point.

A few lines below it will check if an asoc couldn't be found and will
increment SCTP_MIB_OUTOFBLUES. There are more places that inc it, but
it's a start.

It should show up in netstat -s or /proc/net/sctp/snmp.

> I assume it will be a non-trivial job to build my own kernel to run on Linode - I will look into this.

The pr_debug's in there are nice because they will give you the
ips and ports involved AND as it can't be hit from other places
(unlike the counter above), it would make sure the issue is related to
that.

Btw, is this test public? Can I run it too?  Or if you can create a
small reproducer, that would be great.

> 
> Are there any other options which do not rely on dynamic debug.
> Regards,
> Dave.
> 
> 
> 
> > On 16 Mar 2018, at 15:14, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > On Fri, Mar 16, 2018 at 09:33:12AM +0000, David Neil wrote:
> >> Hi,
> >> I have been having intermittent problems with SCTP connection failures; I have finally caught one on Wireshark.
> > 
> > Hi David,
> > 
> > Two things. 1. Which kernel version are you using?
> > 
> > 2. Not sure if debian has dynamic_printk enabled, I guess so.
> > Please run this command to turn on some debug printk's, which should
> > get activated in the case the asoc is not found.
> > 
> > As root:
> >  # echo 'func __sctp_rcv_lookup +p' > /sys/kernel/debug/dynamic_debug/control
> > 
> > And then reproduce the issue again. If you get a printk on dmesg, it's
> > because the association is not being located when the packet came in,
> > and thus why the Abort.
> > 
> > This message is available on kernel >= 4.11.
> > 
> >  M.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
