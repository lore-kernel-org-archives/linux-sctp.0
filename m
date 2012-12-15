From: David Miller <davem@davemloft.net>
Date: Sat, 15 Dec 2012 01:14:26 +0000
Subject: Re: [PATCH] sctp: Change defaults on cookie hmac selection
Message-Id: <20121214.201426.1300133389027142871.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20121215003844.GA10508@neilslaptop.think-freely.org>
	<CA+55aFw-D2J-S8gH0PxO52nDeK31KHxum2gfT8RrzRoNF93yrg@mail.gmail.com>
	<20121215011229.GD10508@neilslaptop.think-freely.org>
In-Reply-To: <20121215011229.GD10508@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 14 Dec 2012 20:12:29 -0500

> On Fri, Dec 14, 2012 at 04:44:56PM -0800, Linus Torvalds wrote:
>> On Fri, Dec 14, 2012 at 4:38 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> >
>> > No need, I think.  Since its a user configurable choice now, the user can just
>> > set the selector to "None" in proc, and none will be used.
>> 
>> Well, by the same logic, there's no point to defaulting to MD5 either,
>> since the user could just put MD5 in the there.
>> 
>> The point is, if you're asking for a default, you should include the
>> actual choices, and not limit it to some random subset of choices. No?
>> 
>>              Linus
>> 
> Ok, Thats a fair point, I can add a option to choose the "None" option as the
> deafult.  Dave, do you want a delta patch, or a new version?

New version please.
