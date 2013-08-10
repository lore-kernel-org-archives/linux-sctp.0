From: Vlad Yasevich <vyasevich@gmail.com>
Date: Sat, 10 Aug 2013 01:34:26 +0000
Subject: Re: [PATCH] net: sctp: fix panic during skb_orphan()
Message-Id: <520598A2.8040206@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20130809.133720.232424253997869104.davem@davemloft.net>   <1376085487-6466-1-git-send-email-vyasevich@gmail.com>  <1376090435.20509.13.camel@edumazet-glaptop> <52058BB2.4010606@gmail.com> <1376097622.20509.19.camel@edumazet-glaptop>
In-Reply-To: <1376097622.20509.19.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-sctp@vger.kernel.org, dborkman@redhat.com

On 08/09/2013 09:20 PM, Eric Dumazet wrote:
> On Fri, 2013-08-09 at 20:39 -0400, Vlad Yasevich wrote:
>> On 08/09/2013 07:20 PM, Eric Dumazet wrote:
>
>>> Why not using a dummy destructor ?
>>
>> It would just be useless once we do proper accounting for all chunks.
>> But, I'll send a different idea if this is just too ugly.
>
> Setting skb->sk is no accounting.

Right.  It is only really used right now when constructing a packet to 
transmit out of a set of chunks.

>
> It seems you would better use skb->cb[] so that you are 100% sure this
> skb->sk doesn't leak outside of SCTP code.

Hmm..  That might work too.  I am building a framework right now that
we can use to add proper buffer accounting.  That's probably a better
long term solution.

-vlad


