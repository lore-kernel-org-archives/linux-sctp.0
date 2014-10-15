From: David Miller <davem@davemloft.net>
Date: Wed, 15 Oct 2014 04:21:43 +0000
Subject: Re: [PATCH net 0/3] SCTP fixes
Message-Id: <20141015.002143.780696221161706737.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com>
	<20141014.124657.128658692728989163.davem@davemloft.net>
	<20141015030631.GA6778@localhost.localdomain>
In-Reply-To: <20141015030631.GA6778@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: dborkman@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 14 Oct 2014 23:06:32 -0400

> On Tue, Oct 14, 2014 at 12:46:57PM -0400, David Miller wrote:
>> From: Daniel Borkmann <dborkman@redhat.com>
>> Date: Thu,  9 Oct 2014 22:55:30 +0200
>> 
>> > Here are some SCTP fixes.
>> > 
>> > [ Note, immediate workaround would be to disable ASCONF (it
>> >   is sysctl disabled by default). It is actually only used
>> >   together with chunk authentication. ]
>> 
>> Series applied, thanks guys.
> Why did you apply this Dave? There was ongoing discussion around it.

Sorry Neil, that wasn't my impression.

Worry not I can revert or apply relative fixes on top.
:-)

Thanks.
