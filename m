From: David Miller <davem@davemloft.net>
Date: Wed, 12 Jun 2019 20:41:14 +0000
Subject: Re: [PATCH v4 net] sctp: Free cookie before we memdup a new one
Message-Id: <20190612.134114.1226850504034942939.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190612003814.7219-1-nhorman@tuxdriver.com>
        <20190612180715.GC3500@localhost.localdomain>
        <20190612203230.GB23166@hmswarspite.think-freely.org>
In-Reply-To: <20190612203230.GB23166@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com, lucien.xin@gmail.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Jun 2019 16:32:30 -0400

> On Wed, Jun 12, 2019 at 03:07:15PM -0300, Marcelo Ricardo Leitner wrote:
>> On Tue, Jun 11, 2019 at 08:38:14PM -0400, Neil Horman wrote:
>> > Based on comments from Xin, even after fixes for our recent syzbot
>> > report of cookie memory leaks, its possible to get a resend of an INIT
>> > chunk which would lead to us leaking cookie memory.
>> > 
>> > To ensure that we don't leak cookie memory, free any previously
>> > allocated cookie first.
>> > 
>> > ---
>> 
>> This marker can't be here, as it causes git to loose everything below.
>> 
> thats intentional so that, when Dave commits it, the change notes arent carried
> into the changelog (I.e. the change notes are useful for email review, but not
> especially useful in the permanent commit history).

1) I like the changelog notes to be included

2) Your signoff etc. was in that area too so would have been lost as well
