From: David Miller <davem@davemloft.net>
Date: Fri, 02 Aug 2019 23:19:32 +0000
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-Id: <20190802.161932.1776993765494484851.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
        <20190731121646.GD9823@hmswarspite.think-freely.org>
        <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
In-Reply-To: <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: nhorman@tuxdriver.com, vyasevich@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 02 Aug 2019 10:47:34 -0700

> On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
>> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
>> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
>> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
>> > > > fallthrough may become a pseudo reserved keyword so this only use of
>> > > > fallthrough is better renamed to allow it.
> 
> Can you or any other maintainer apply this patch
> or ack it so David Miller can apply it?

I, like others, don't like the lack of __ in the keyword.  It's kind of
rediculous the problems it creates to pollute the global namespace like
that and yes also inconsistent with other shorthands for builtins.
