From: David Miller <davem@davemloft.net>
Date: Wed, 16 Oct 2019 19:04:19 +0000
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Message-Id: <20191016.120419.1631440501656175018.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
        <20191016.142534.1360443052637911866.davem@davemloft.net>
        <20191016183209.GA4250@localhost.localdomain>
In-Reply-To: <20191016183209.GA4250@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, david.laight@aculab.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 16 Oct 2019 15:32:09 -0300

> On Wed, Oct 16, 2019 at 02:25:34PM -0400, David Miller wrote:
>> From: Xin Long <lucien.xin@gmail.com>
>> Date: Mon, 14 Oct 2019 14:14:43 +0800
>> 
>> > SCTP-PF was implemented based on a Internet-Draft in 2012:
>> > 
>> >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
>> > 
>> > It's been updated quite a few by rfc7829 in 2016.
>> > 
>> > This patchset adds the following features:
>> 
>> Sorry but I'm tossing these until an knowledgable SCTP person can
>> look at them.
> 
> Hi Dave,
> 
> Maybe the email didn't get through but Neil actually already acked it,
> 2 days ago.
>   Message-ID: <20191014124249.GB11844@hmswarspite.think-freely.org>
> 
> I won't be able to review it :-(

All I saw was David Laight replying saying he thought the APIs weren't
implemented correctly.

I have to admit that I'm really going to proceed carefully with SCTP
API changes because there has been a lot of discussions in the past
involving backwards-incompatible things happening.

I'm not saying that is happening here, but my confidence in SCTP API
changes is very low.

I want this to sit for a while and Xin can respin and resubmit in a
day or two.
