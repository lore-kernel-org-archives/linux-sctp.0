From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Sep 2008 03:01:29 +0000
Subject: Re: [PATCH 1/2] sctp: do not enable peer features if we can't do
Message-Id: <48D31609.2090406@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com> <20080918.162941.157950819.davem@davemloft.net>
In-Reply-To: <20080918.162941.157950819.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, netdev@vger.kernel.org

David Miller wrote:
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Thu, 18 Sep 2008 17:31:03 -0400
> 
>> Do not enable peer features like addip and auth, if they
>> are administratively disabled localy.  If the peer resports
>> that he supports something that we don't, neither end can
>> use it so enabling it is pointless.  This solves a problem
>> when talking to a peer that has auth and addip enabled while
>> we do not.  Found by Andrei Pelinescu-Onciul <andrei@iptel.org>.
>>
>> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> I applied this, but it is at best borderline for outside the
> merge window.  It doesn't fix an OOPS nor a security issue nor
> an entry in the 2.6.x regression list, therefore strictly speaking
> this fix is not appropriate at this time.
> 
> Please apply this criteria when deciding whether to submit future
> fixes for net-2.6 inclusion.
> 

It is a major interoperability issue.  With the default sysctl settings,
we can not establish connection to BSD systems.  Yes, there is a workaround
of turning on the 2 required sysctl settings, but that is totally suboptimal.

I've thought about this fix for a while, and in my opinion, the interoperability
problem is large enough to warrant the fix at this time and the backport to
table.

Of course you are free to not include this in net-2.6, but I hope you will.

Thanks
-vlad
