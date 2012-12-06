From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 06 Dec 2012 19:14:22 +0000
Subject: Re: [PATCH] sctp: Add RCU protection to assoc->transport_addr_list
Message-Id: <50C0EE8E.3080505@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <16453bea94a6fc43d657139dff2ce0b5924e2a1f.1354817574.git.tgraf@suug.ch> <50C0E585.1080701@gmail.com> <20121206184433.GE16122@casper.infradead.org> <50C0EAB5.3050303@gmail.com> <20121206190835.GF16122@casper.infradead.org>
In-Reply-To: <20121206190835.GF16122@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/06/2012 02:08 PM, Thomas Graf wrote:
> On 12/06/12 at 01:57pm, Vlad Yasevich wrote:
>> On 12/06/2012 01:44 PM, Thomas Graf wrote:
>>> On 12/06/12 at 01:35pm, Vlad Yasevich wrote:
>>>> We may want to mark transports as dead sooner.  Probably right about
>>>> the time we pull them off the list.
>>>
>>> We mark it dead in sctp_transport_free() which is called at the
>>> end of sctp_assoc_rm_peer(). Do you want to mark it dead at the
>>> beginning of sctp_assoc_rm_peer() as well? (We still need to
>>> mark in sctp_transport_free() anyway).
>>
>> Crud..  sctp_transport_free() is called directly in places...   Hmm...
>> the one in sctp_association_free() may need to be list_del_rcu()...
>
> It's not really needed but it wouldn't be wrong from a
> documentation perspective. The assoc is always unhashed
> while holding head->lock before sctp_association_free()
> and all current RCU readers of transport_addr_list access
> the the assoc while holding a read-lock on head->lock.
>
> Let me respin this patch and do a list_del_rcu() there
> to document the RCU'iness of it.
>

Right, but there may be chunks that have cached association with a ref
before sctp_association_free() is called.  Now, after free they may
be looking at the transport list for whatever reason...  Most places
check assoc->dead, but I don't want to get caught.  So, there is
a remote chance that someone may look at transports and would crash
without rcu.

-vlad
