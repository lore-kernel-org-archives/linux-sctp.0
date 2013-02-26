From: Jon Leighton <leighton@cis.udel.edu>
Date: Tue, 26 Feb 2013 15:00:38 +0000
Subject: Re: How to unload lksctp kernel module?
Message-Id: <512CCE16.7050109@cis.udel.edu>
List-Id: <linux-sctp.vger.kernel.org>
References: <512BDEFF.4090103@redhat.com>
In-Reply-To: <512BDEFF.4090103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 2/26/13 9:13 AM, Vlad Yasevich wrote:
> On 02/25/2013 05:00 PM, Daniel Borkmann wrote:
>> (cc: linux-sctp, which is the right list to address this question)
>>
>> On 02/25/2013 03:39 PM, Jon Leighton wrote:
>>> I'm trying to unload the lksctp kernel module (sudo modprobe -r sctp),
>>> but the operation fails with "FATAL: Module sctp is in use.". lsmod
>>> shows a reference count of 2 for sctp. If I restart the machine, and
>>> load the lksctp module by running a simple SCTP based program, the
>>> module loads, but the reference count is 2 again, and the module can't
>>> be unloaded. I've also tried to force the unload with sudo rmmod -f
>>> sctp, but that fails with "ERROR: Removing 'sctp': Resource temporarily
>>> unavailable". Is there a way to unload the module? I'm running Ubuntu
>>> 10.04 LTS with linux kernel 2.6.32-45-generic-pae. Thanks for any help.
>
> rmmod -f used to work, but I haven't tried it lately.
>
> The reason for the ref=2 is that when lksctp starts up, it creates a 
> control socket which holds those 2 refs on the module. 'modprobe -r'
> will not let you unload when the module is refed.  rmmod -f works 
> around that.

sudo rmmod -f sctp returns "ERROR: Removing 'sctp': Resource temporarily 
unavailable". Is there any workaround for this? Or perhaps this means 
that I need to rebuild my kernel with CONFIG_MODULE_FORCE_UNLOAD enabled?

> -vlad
>
>>>
>>> - Jon
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

