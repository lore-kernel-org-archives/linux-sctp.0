From: Jerry Jerry <jerry.jerry2008@gmail.com>
Date: Sat, 07 Mar 2015 02:44:54 +0000
Subject: Re: Does IPv6 have to be enabled to run lksctp-tools?
Message-Id: <CAAyB5c+LqG5GdeAXL-JQYGpq1p=mgHsUM_MAjNsLFWW9NbHpwg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
In-Reply-To: <CAAyB5cKp6+dwfcbJT763nTvF0U1JXixv6uRYy=6XPD2h0_RGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Neil,

Now we ran into another issue with sendmsg(). The call to sendmsg()
returns without error, but we found system messages in
/var/log/messages, which seem memory allocation issues. Is this a bug,
or this is the way it has to be? If the latter, what do you suggest to
catch or avoid this kind kernel error? Since the system call to
sendmsg() doesn't return such error, our application cannot catch it
and this causes problem (the data actually are not sent out by
kernel).

 7474 Mar  6 00:20:59 linux83 kernel: [ 8853.073003] The following is
only an harmless informational message.
7475 Mar  6 00:20:59 linux83 kernel: [ 8853.073009] Unless you get a
_continuous_flood_ of these messages it means
7476 Mar  6 00:20:59 linux83 kernel: [ 8853.073011] everything is
working fine. Allocations from irqs cannot be
7477 Mar  6 00:20:59 linux83 kernel: [ 8853.073012] perfectly reliable
and the kernel is designed to handle that.
7478 Mar  6 00:20:59 linux83 kernel: [ 8853.073018] testapp: page
allocation failure: order:7, mode:0x20
7479 Mar  6 00:20:59 linux83 kernel: [ 8853.073025] Pid: 30025, comm:
testapp Not tainted 3.0.13-0.27-default #1
7480 Mar  6 00:20:59 linux83 kernel: [ 8853.073030] Call Trace:
7481 Mar  6 00:20:59 linux83 kernel: [ 8853.073085]
[<ffffffff810048b5>] dump_trace+0x75/0x300
7482 Mar  6 00:20:59 linux83 kernel: [ 8853.073101]
[<ffffffff8143ea0f>] dump_stack+0x69/0x6f
7483 Mar  6 00:20:59 linux83 kernel: [ 8853.073115]
[<ffffffff810f71b2>] warn_alloc_failed+0x102/0x1a0
7484 Mar  6 00:20:59 linux83 kernel: [ 8853.073125]
[<ffffffff810f8ca9>] __alloc_pages_slowpath+0x559/0x7f0
7485 Mar  6 00:20:59 linux83 kernel: [ 8853.073131]
[<ffffffff810f90f1>] __alloc_pages_nodemask+0x1b1/0x1c0
7486 Mar  6 00:20:59 linux83 kernel: [ 8853.073144]
[<ffffffff811312b5>] alloc_pages_current+0xa5/0x120
7487 Mar  6 00:20:59 linux83 kernel: [ 8853.073152]
[<ffffffff810f67c9>] __get_free_pages+0x9/0x50
7488 Mar  6 00:20:59 linux83 kernel: [ 8853.073188]
[<ffffffffa038332f>] sctp_ssnmap_new+0x5f/0xd0 [sctp]
7489 Mar  6 00:20:59 linux83 kernel: [ 8853.073260]
[<ffffffffa03720b5>] sctp_process_init+0x395/0x3e0 [sctp]
7490 Mar  6 00:20:59 linux83 kernel: [ 8853.073277]
[<ffffffffa036b981>] sctp_cmd_interpreter+0x2a1/0xf90 [sctp]
7491 Mar  6 00:20:59 linux83 kernel: [ 8853.073290]
[<ffffffffa036c6a4>] sctp_side_effects+0x34/0xe0 [sctp]
7492 Mar  6 00:20:59 linux83 kernel: [ 8853.073302]
[<ffffffffa036c7f5>] sctp_do_sm+0xa5/0xe0 [sctp]
7493 Mar  6 00:20:59 linux83 kernel: [ 8853.073315]
[<ffffffffa037001c>] sctp_assoc_bh_rcv+0xbc/0x130 [sctp]
7494 Mar  6 00:20:59 linux83 kernel: [ 8853.073332]
[<ffffffffa0382980>] sctp_backlog_rcv+0x60/0x140 [sctp]
7495 Mar  6 00:20:59 linux83 kernel: [ 8853.073361]
[<ffffffff8137723c>] release_sock+0x5c/0x120
7496 Mar  6 00:20:59 linux83 kernel: [ 8853.073372]
[<ffffffffa037db48>] sctp_sendmsg+0x5e8/0x960 [sctp]
7497 Mar  6 00:20:59 linux83 kernel: [ 8853.073401]
[<ffffffff81372bdb>] sock_sendmsg+0xdb/0x120
7498 Mar  6 00:20:59 linux83 kernel: [ 8853.073407]
[<ffffffff81373c8b>] __sys_sendmsg+0x37b/0x390
7499 Mar  6 00:20:59 linux83 kernel: [ 8853.073412]
[<ffffffff81373e72>] sys_sendmsg+0x42/0x80
7500 Mar  6 00:20:59 linux83 kernel: [ 8853.073422]
[<ffffffff81449692>] system_call_fastpath+0x16/0x1b
7501 Mar  6 00:20:59 linux83 kernel: [ 8853.074762] DWARF2 unwinder
stuck at system_call_fastpath+0x16/0x1b
7502 Mar  6 00:20:59 linux83 kernel: [ 8853.074768]
7503 Mar  6 00:20:59 linux83 kernel: [ 8853.074770] Leftover inexact backtrace:
7504 Mar  6 00:20:59 linux83 kernel: [ 8853.074771]

Regards,
Jerry


On Fri, Mar 6, 2015 at 9:41 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Mar 06, 2015 at 08:51:40AM -0800, Jerry Jerry wrote:
>> Hi Neil,
>>
>> My apology that I didn't make it clear. There are actually two related
>> issues, (1) ipv6 requirement, and (2) checksctp hangs. For 2nd issue,
>> we are trying to recreate the problem and will get back to you once we
>> have the trace. For the 1st issue, here is how we verified:
>>
>> using "vi /etc/modprobe.d/50-ipv6.conf" to comment out #install ipv6
>> /bin/true, and later using modprobe ipv6 to enable it. The following
>> are our steps:
>>
>> linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
>> # ./checksctp
>>  checksctp: Protocol not supported
>>
>> linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
>> # vi /etc/modprobe.d/50-ipv6.conf  (undo comment out ipv6)
>>
>> linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
>> # modprobe ipv6
>>
>> linux165:~/sctp_test/lksctp-tools-1.0.16/src/withsctp
>> # ./checksctp
>> SCTP supported
>>
> Sorry, didn't realize what you were asking.  What I should say is that sctp has
> no build time requriements on ipv6.  That is to say you could disable ipv6 in
> your kernel build and sctp should still work on ipv4 just fine.  But if you do
> what you suggest above, which is to say, build sctp with ipv6 support, and then
> prevent the ipv6 module from loading, sctp won't just fall back to pretending it
> can't talk over ipv6.  It has load time symbol requirements that will prevent
> the module from loading, which is why you get the EOPNOTSUPP error above.
>
> Neil
>
>>
>> Regards,
>> Jerry
>>
>> On Thu, Mar 5, 2015 at 6:04 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > On Wed, Mar 04, 2015 at 12:59:21PM -0800, Jerry Jerry wrote:
>> >> Hello,
>> >>
>> >> We had a strange problem using lksctp-tool where checksctp would hang
>> >> there on some of our machines and process cannot be killed anyway
>> >> (with status d/d+). After some investigation, we found out that
>> >> whether ipv6 is enabled could impact the behavior of the library. So,
>> >> my question is that, is this a requirement by design or it just
>> >> happens to occur that ipv6 is required? Any suggestion to bypass this
>> >> (not to rely on ipv6) would be appreciated very much.
>> >>
>> >> Regards,
>> >> Jerry
>> > IIRC there should be no ipv6 requierment.
>> >
>> > Where does the checksctp tool hang?  Is it in user space or the kernel?  Can you
>> > provide a backtrace, either ia gdb if its in userspace or sysrq in the kernel?
>> >
>> > Best
>> > Neil
>> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>>
