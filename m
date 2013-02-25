From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 25 Feb 2013 22:00:31 +0000
Subject: Re: How to unload lksctp kernel module?
Message-Id: <512BDEFF.4090103@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

(cc: linux-sctp, which is the right list to address this question)

On 02/25/2013 03:39 PM, Jon Leighton wrote:
> I'm trying to unload the lksctp kernel module (sudo modprobe -r sctp),
> but the operation fails with "FATAL: Module sctp is in use.". lsmod
> shows a reference count of 2 for sctp. If I restart the machine, and
> load the lksctp module by running a simple SCTP based program, the
> module loads, but the reference count is 2 again, and the module can't
> be unloaded. I've also tried to force the unload with sudo rmmod -f
> sctp, but that fails with "ERROR: Removing 'sctp': Resource temporarily
> unavailable". Is there a way to unload the module? I'm running Ubuntu
> 10.04 LTS with linux kernel 2.6.32-45-generic-pae. Thanks for any help.
>
> - Jon
