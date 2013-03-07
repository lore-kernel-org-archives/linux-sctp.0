From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Mar 2013 02:01:31 +0000
Subject: Re: sctp client not binding to all available addresses
Message-Id: <5137F4FB.9050305@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5137797D.3000706@cis.udel.edu>
In-Reply-To: <5137797D.3000706@cis.udel.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/06/2013 02:38 PM, Jonathan T. Leighton wrote:
> On 03/06/13 12:42, Vlad Yasevich wrote:
>> On 03/06/2013 12:14 PM, Jon Leighton wrote:
>>> I'm almost certain that calling connect() on an unbound socket used to
>>> result in an INIT being sent with all available IP addresses advertised,
>>> but that's not happening with the code I'm running right now. Has there
>>> been a change in the default behaviour, or do I misremember it? Thanks.
>>>
>>
>> It will list all available addresses that are of a scope that is larger
>> or the same as the destination.  You can control selection with the
>> scope_policy sysctl.  Check to see what it is set to on your system.
>
> Thanks. Does addr_scope_policy=1 implement the policy described in
> draft-stewart-tsvwg-sctp-ipv4-00, or is there a more recent reference?
> And does addr_scope_policy=0 imply all available addresses are
> advertised (previous behavior)?

The sysctl description is the documentation.  You can find it here:
ttps://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/ip-sysctl.txt

Around line 1590.

-vlad

>
> - Jon
>
>> Otherwise, no changes have been made recently to this code.  For
>> any more help, we'll need more information.
>>
>> -vlad.
>>> - Jon
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

