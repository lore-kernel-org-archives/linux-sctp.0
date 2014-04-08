From: Vlad Yasevich <vyasevic@redhat.com>
Date: Tue, 08 Apr 2014 19:37:41 +0000
Subject: Re: [PATCH net v2] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <53445005.9000707@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20140408.131819.1373401078750444800.davem@davemloft.net> <53442FD0.5020609@redhat.com> <20140408.141918.1353780924646899277.davem@redhat.com> <20140408.144601.1499418906739470715.davem@davemloft.net> <53444841.2010702@redhat.com>
In-Reply-To: <53444841.2010702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com

On 04/08/2014 03:04 PM, Daniel Borkmann wrote:
> On 04/08/2014 08:46 PM, David Miller wrote:
>>
>> Daniel and Vlad, I'm about to send Linus a pull request.
>>
>> I know that you still need to fixup this SCTP change and it'll be
>> in there, but I really need to get the changes in my tree staged
>> so that I can do a set of -stable submissions.
>>
>> So please don't freak out, I know that this change still needs work
>> and shouldn't go to -stable just yet :-)
> 
> Noted, thanks. I think the issue is that in sctp_association_free()
> we do a list_del(&asoc->asocs) and then flush sctp_outq_free() which
> will then access on sctp_wfree() a poisoned entry. I think this
> should be list_del_init() instead.

Switching to list_del_init() will solve the crash, but will not address
the issue.  You've just removed an association and need to notify others
of available space.  You can't do that since you've been unlinked.

We either need a rcu_style unlink, or detect the delete case and loop
from the beginning.

You can do #2 easily enough by looking at asoc->base.dead to decide
where to start looping.

-vlad
