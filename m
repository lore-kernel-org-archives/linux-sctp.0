From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 21 Nov 2008 14:28:37 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <4926C595.8050200@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Michal

This really smells like the corruption of the sctp_packet structure.
The number chunks printout out is 0, but the list appears to have multiple
entries on it.

Can you turn on CONFIG_DEBUG_LIST and may be even turn on memory
debugging as well.

Thanks
-vlad

Michal Hocko wrote:
> On Tue 18-11-08 09:04:58, Vlad Yasevich wrote:
>> Michal Hocko wrote:
>>> On Thu 06-11-08 08:48:45, Vlad Yasevich wrote:
> [...]
>>>> In the earlier kernels there were a few bugs in the accept code paths that
>>>> had to do with locking the newly created socket correctly as well as locking
>>>> the port hash table during the migration of the ports.  Both of those
>>>> contributed to crashes at odd points in time and sometimes even to stack and
>>>> memory corruptions.
>>>>
>>>> I'll take a look at what's causing skb overflow in 2.6.28.
>>> Is there any update (patch to test). This is starting to be critical
>>> from our POV. 
>>> Do you have any ETA?
>>> Is there some way how to help here?
>>>
>> which version in particular is most critical?
>>
>> Just remember then 2.6.16 is very old and there have been a lot of fixes that
>> address critical issues.
>>
>> For 2.6.28, can you apply the attached patch and post dmesg output.  Also, if
>> it's possible to capture a kdump, that would make things much easier.
> 
> I have tried the attached patch and led the machine crash with the
> 2.6.28-rc5 kernel (4e14e833ac3b97a4aa8803eea49f899adc5bb5f4). Trace as
> well as config are attached. Kdump vmcore and oldmem along with vmlinux
> and System.map can be found at:
> 
> ftp.novell.com/outgoing/vmcore.2.6.28-rc5-sctp.gz
> ftp.novell.com/outgoing/oldmem.2.6.28-rc5-sctp.gz
> ftp.novell.com/outgoing/vmlinux-2.6.28-rc5-sctp.gz
> ftp.novell.com/outgoing/System.map-2.6.28-rc5-sctp.gz
> 
> md5sums:
> d43a09b384c6b45ffd0615fd2f3e63e7  vmcore.2.6.28-rc5-sctp
> f0e327c1b58c84f0ed7006fc5b881bd8  oldmem.2.6.28-rc5-sctp
> 70f86806415a266dccb13dae835b8d0e  vmlinux-2.6.28-rc5-sctp
> 41bb6d07ec960557f8243eb98b244c9b  System.map-2.6.28-rc5-sctp
> 
> Unfortunately, I don't have timing information in the captured trace
> (logs don't contain anything), so it is not clear how much time elapsed
> between debug output added by the patch and the crash itself.
> 
> "sky2 lan: rx error, status 0x1160002 length 278" was logged at Nov 18
> 16:59:25 (around hour after test has started) while the crash has
> occured around Nov 19 1:30 
> /var/log/messages:
> [...]
> Nov 19 00:31:05 dhcp35 -- MARK --
> Nov 19 00:51:05 dhcp35 -- MARK --
> Nov 19 01:11:05 dhcp35 -- MARK --
> Nov 19 01:31:05 dhcp35 -- MARK --
> Nov 19 09:37:15 dhcp35 syslogd 1.5.0#5: restart.
> 
> 

