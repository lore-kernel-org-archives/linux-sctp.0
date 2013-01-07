From: Alex Elder <elder@inktank.com>
Date: Mon, 07 Jan 2013 17:49:25 +0000
Subject: Re: Config Loop
Message-Id: <50EB0AA5.6000803@inktank.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <50E5AA59.3010109@inktank.com>
In-Reply-To: <50E5AA59.3010109@inktank.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/07/2013 11:22 AM, Neil Horman wrote:
> On Mon, Jan 07, 2013 at 10:47:28AM -0600, Alex Elder wrote:
>> On 01/03/2013 01:06 PM, Neil Horman wrote:
>>> On Thu, Jan 03, 2013 at 10:59:02AM -0600, Alex Elder wrote:
>>>> On 01/03/2013 10:52 AM, Neil Horman wrote:
>>>>> On Thu, Jan 03, 2013 at 09:57:13AM -0600, Alex Elder wrote:
>>>>>> A commit added in the 3.8-rc1 merge window has resulted in
>>>>>> my kernel config entering an infinite loop handling the
>>>>>> "Default SCTP cookie HMAC encoding" option.
>>>>>>
>>>>>>     commit 0d0863b02002c25140a1b9e113b81211bcc780e8
>>>>>>     sctp: Change defaults on cookie hmac selection
>>>>>>
>>>>>>     http://marc.info/?l=linux-netdev&m5553459303505
>>>>>>
>>>>>> The problem lies in my config file containing this line:
>>>>>>
>>>>>>     CONFIG_SCTP_HMAC_MD5=y
>>>>>>
>>>>>> I normally configure my kernel using fixed config file
>>>>>> (occasionally updated) using (roughly) this:
>>>>>>
>>>>>>     yes "" | make oldconfig
>>>>>>
>>>>>> The result looks like this:
>>>>>>
>>>>>> . . .
>>>>>>   DCCP connection probing (NET_DCCPPROBE) [M/n/?] m
>>>>>> *
>>>>>> * The SCTP Protocol (EXPERIMENTAL)
>>>>>> *
>>>>>> The SCTP Protocol (EXPERIMENTAL) (IP_SCTP) [M/y/?] m
>>>>>>   SCTP: Association probing (NET_SCTPPROBE) [M/n/?] m
>>>>>>   SCTP: Debug messages (SCTP_DBG_MSG) [N/y/?] n
>>>>>>   SCTP: Debug object counts (SCTP_DBG_OBJCNT) [N/y/?] n
>>>>>>   Default SCTP cookie HMAC encoding
>>>>>>     1. Enable optional MD5 hmac cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
>>>>>>     2. Enable optional SHA1 hmac cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
>>>>>>     3. Use no hmac alg in SCTP cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
>>>>>>   choice[1-3?]:   Default SCTP cookie HMAC encoding
>>>>>>     1. Enable optional MD5 hmac cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_MD5) (NEW)
>>>>>>     2. Enable optional SHA1 hmac cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_SHA1) (NEW)
>>>>>>     3. Use no hmac alg in SCTP cookie generation
>>>>>> (SCTP_DEFAULT_COOKIE_HMAC_NONE) (NEW)
>>>>>>   choice[1-3?]:   Default SCTP cookie HMAC encoding
>>>>>> . . .  and so on.
>>>>>>
>>>>>> I find that I can correct this with the patch below.
>>>>>> I expect others will bump into the same problem.  In
>>>>>> particular, I notice my Ubuntu config files contain
>>>>>> that same line.
>>>>>>
>>>>>> I don't know how best to handle this, but I thought
>>>>>> I would report it in case someone has a good solution.
>>>>>>
>>>>> Thats odd.  It looks like your selection of a defaut value for the sctp cookie
>>>>> hmac algorithm isn't taking at all.  I just added the old CONFIG_SCTP_HMAC_MD5=y
>>>>> option to my config and used your:
>>>>> yes "" | make oldconfig 
>>>>> setup, and it worked fine for me.  And you say if you remove the old config
>>>>> option first, you get no loop?
>>>>
>>>> I say that when I apply the patch (below) there is no loop.
>>>>
>>>> I noticed the loop with v3.8-rc1 and it's still happening
>>>> with v3.8-rc2.  I've attached the working config I'm now
>>>> using to this message.  The only difference between the
>>>> looping one and the working one is that this:
>>>>     CONFIG_SCTP_HMAC_MD5=y
>>>> has been replaced with this:
>>>>     CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
>>>>
>>> Oh, I think I see what happened.  When I converted the Kconfig file to have a
>>> choice statement, it created a conflict with your old config that the the config
>>> mechanism didn't know how to resolve.  The Choice statement selects
>>> CONFIG_SCTP_HMAC_MD5 as a default value, but your old config explicitly has
>>> CONFIG_SCTP_HMAC_MD5 turned off.  Since your command:
>>> yes "" | make oldconfig
>>> just takes whatever the default value is, it tries to select
>>> CONFIG_SCTP_HMAC_MD5, but since its already turned off, the config utilty
>>> doesn't know what to do, so it responds by just asking you again what you want
>>> the default to be.
>>
>> OK, I was in the middle of writing a nice detailed response to
>> this.  But in the process of verifying what I was saying I believe
>> I found the bug.
>>
>> I'll be sending the fix in a separate message.
>>
>> Here are a couple of notes anyway:
>> - I found that combinations of 0, 1, 2, or 3 of the _MD5, _SHA1, and
>>   _NONE config options set to "=y" produced the same infinite loop.
>> - I found that another commit, 3c68198e7, changed the names of these
>>   config options to include "_COOKIE", so my old config file was not
>>   actually defining *any* of the new names.
>> - Nevertheless, combinations of 0-3 of those config options produced
>>   the same infinite loop.
>>
> Didn't feel like I needed to test oldconfig in great depth, as these are all new
> options. In that vein, I did test make oldconfig without any of the options set,
> and with all the defaults set, and it works fine (i.e. no loop)

I don't mean to pick on you.  My main concern wasn't this particular
issue (which I've already worked around).  I was really more concerned
about it being possible for a config file to put config into an
infinite loop while doing what I consider routine processing.

I can tell you that with the config file I supplied earlier,
if I comment out this line:
    CONFIG_SCTP_HMAC_MD5=y
it still loops.  (But because of the spelling change this should
be expected--none of the SCTP_COOKIE_HMAC_{MD5,SHA1} nor the
SCTP_DEFAULT_COOKIE_HMAC_{MD5,SHA1,NONE} is set whether or not
this line is present.)

> As for your testing, are you saying that you tried testing with
> SCTP_DEFAULT_COOKIE_HMAC_{NONE|MD5|SHA1] all set to y or n?  If so, thats an
> invalid config. What would you expect make oldconfig to do?

I realize selecting more than one would be invalid.  (But if so
the config should probably be a bool if I understand the config
language right.)  I'm just reporting the result of my testing.

>>     CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
> It doesn't.  The Kconfig file holds this default, so if you have no entry in the
> .config, it will add this.
> 
> 
> If you think you have a fix however, one that removes the infinite loop and
> doesn't override the existing config option, I'll gladly look at it.

While writing this, I now see you did...

Thanks.

					-Alex
> Neil
> 
>>
>> 					-Alex
>>
>>> I don't think theres actually a bug here, at least not one that we can do
>>> anything about that won't result in other people complaining about the opposite
>>> effect.  The old config you have, when applied to the latest kernel, puts you in
>>> a situation where you have both hmac options already disabled, but you need to
>>> select a default value for your hmac cookie generator (one of md5/sha1/none), so
>>> selecting the default effectively creates a situation where you're asking the
>>> config to have CONFIG_SCTP_HMAC_MD5 both on and off at the same time.
>>>
>>> Things that could be done as I see it:
>>>
>>> 1) We could teach the config utility to recognize when options are disabled in
>>> the old config and migrate the default away to the next in line that is not
>>> already disabled
>>>
>>> 2) We could make the config utility override the old config value when the input
>>> value input at the prompt conflicts with the old config
>>>
>>> 3) We could print a helpful message indicating that the conflict is taking place
>>>
>>>
>>> Truthfully though I don't really like any of these a whole lot (save for the
>>> third).  1 is unpleasant in my view as they change what would otherwise
>>> be the default coded value silently, while 2 overrides the previously selected
>>> configuration option.  Both of these may be completely unexpected by the user.
>>>
>>>
>>> Option 3 seems reasonable to me, although I'm not sure its going to be that
>>> useful.  I'm sorry this happened to you, but it seems like this is something
>>> that will only occur very rarely if/when we convert a previously existing set of
>>> options to a choice submenu.  Let me know if you have other thoughts.
>>> Neil
>>>
>>>
>>
>>

