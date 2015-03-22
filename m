From: Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 22 Mar 2015 14:22:57 +0000
Subject: Re: modprobe sctp error
Message-Id: <20150322142257.GA13535@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5cLYfj24-+fGiZtGWa3Ae=c2=xpz2=3Ok3s=iMGxu5Abcw@mail.gmail.com>
In-Reply-To: <CAAyB5cLYfj24-+fGiZtGWa3Ae=c2=xpz2=3Ok3s=iMGxu5Abcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 20, 2015 at 05:38:26PM -0700, Jerry Jerry wrote:
> Hi Neil,
> 
> I checked mobprobe and it looks like its last step was to flush cpu
> workqueue while trying to stop_machine, which I don't quite understand
> why.
> 
> 
> Hereunder 83356 is checksctp process, and 83360 is mobprobe process
> 
> root      83356  83270  0  2244   452   0 Mar20 pts/0    00:00:00 checksctp
> root      83359     16  0     0     0   1 Mar20 ?        00:00:00 [khelper]
> root      83360  83359  0  2307   712   0 Mar20 ?        00:00:00
> /sbin/modprobe -q -- net_pf_2_proto_132
> 
> cat /proc/83360/stack
> [<ffffffff8105fb1c>] flush_cpu_workqueue+0x4c/0x80
> [<ffffffff8105fd5c>] flush_workqueue+0x3c/0x60
> [<ffffffff810933e9>] __stop_machine+0xf9/0x120
> [<ffffffff8109365f>] stop_machine+0x3f/0x70
> [<ffffffff8107fddc>] unwind_remove_table+0x3c/0x70
> [<ffffffff8107d047>] sys_init_module+0x157/0x270
> [<ffffffff81002f7b>] system_call_fastpath+0x16/0x1b
> [<00007fc7c1bccf4a>] 0x7fc7c1bccf4a
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
It flushes all the workqueues because stop_machine effectively stops all kernel
execution so that we can safely insert the new module code.  As to why its hung
on workqueue flushing, you'll have to to do a sysrq-t to dump all the workqueue
tasks.   Thats your next step.

I'll give you some warning right now too that more likely whatever your seeing
here is fixed in a newer kernel.

Neil

> Regards,
> Jerry
> 
> 
> On Fri, Mar 20, 2015 at 11:11 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Fri, Mar 20, 2015 at 10:44:56AM -0700, Jerry Jerry wrote:
> >> Thanks, Neil, not sure if this is cause but I'll double check.
> >>
> >> Meanwhile, we hit another issue that checksctp hangs:
> >>
> >>
> >> 83356 pts/0    D+     0:00 checksctp
> >>
> >> And  /proc/83356/stack shows:
> >>
> >> [<ffffffff8105f357>] call_usermodehelper_exec+0xc7/0xd0
> >> [<ffffffff8105f5a2>] __request_module+0x142/0x190
> >> [<ffffffff8134d3bb>] inet_create+0x10b/0x300
> >> [<ffffffff812e1aad>] __sock_create+0x12d/0x2c0
> >> [<ffffffff812e1f1d>] sys_socket+0x3d/0x70
> >> [<ffffffff81002f7b>] system_call_fastpath+0x16/0x1b
> >> [<00007f29c4c2fa07>] 0x7f29c4c2fa07
> >> [<ffffffffffffffff>] 0xffffffffffffffff
> >>
> > This indicates that the kernel is attempting to demand load the sctp module.  If
> > its hung in purpituity, that means that the callout process (forked by
> > call_usermodehelper_exec) is blocked.  Look for the running modprobe process,
> > and see whats blocking that.  That will lead you a step closer to your root
> > cause.
> >
> >> We have libsctp.so.1.0.16 under /usr/local/lib/ but rpm -V
> >> lksctp-tools shows it's not installed. Could this matter, or there
> >> might be other reasons?
> >>
> > No RHEL shipped rpm installs things to /usr/local/lib, ever.  Sounds like
> > perhaps you've built your own libsctp and installed it.  As to which one is in
> > use (the one in /usr/local/lib or the one in /usr/lib, where lksctp-tools rpm
> > install libraries), is a matter of how your LD_LIBRARY_PATH is set.
> >
> > Neil
> >
> >> Regards,
> >> Jerry
> >>
> >> On Fri, Mar 20, 2015 at 4:49 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > On Thu, Mar 19, 2015 at 07:15:28PM -0700, Jerry Jerry wrote:
> >> >> Hello everyone,
> >> >>
> >> >> We had another problem today, where modprobe shows an error in
> >> >> /var/log/message when we ran an sctp application:
> >> >>
> >> >> modprobe: FATAL: Error inserting sctp
> >> >> (/lib/modules/2.6.32.12-0.7-default/kernel/net/sctp/sctp.ko): Invalid
> >> >> argument
> >> >>
> >> >> I'm wondering what might be possible causes of this and how should we
> >> >> bypass this.... Appreciate any comments and suggestions.
> >> >>
> >> >> Regards,
> >> >> Jerry
> >> > EINVAL is returned by mod_sysfs_setup.  Ostensibly its because you either
> >> > specified a module option that doesn't exist, or because the module is already
> >> > loaded.  There could be other reasons, but those are the ones that pop
> >> > immediately to mind.
> >> >
> >> > Neil
> >> >
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >>
> >>
> 
