From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 07 Jan 2013 15:32:01 +0000
Subject: Re: [PATCH v2] sctp: Change defaults on cookie hmac selection
Message-Id: <50EAEA71.1060007@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1355511060-27320-1-git-send-email-nhorman@tuxdriver.com> <1355534521-32719-1-git-send-email-nhorman@tuxdriver.com> <50EACCD3.90609@openwrt.org> <20130107144921.GA31577@hmsreliant.think-freely.org>
In-Reply-To: <20130107144921.GA31577@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Florian Fainelli <florian@openwrt.org>, netdev@vger.kernel.org, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-sctp@vger.kernel.org

On 01/07/2013 09:49 AM, Neil Horman wrote:
> On Mon, Jan 07, 2013 at 02:25:39PM +0100, Florian Fainelli wrote:
>> Hello Neil,
>>
>> Le 12/15/12 02:22, Neil Horman a =E9crit :
>>> Recently I posted commit 3c68198e75 which made selection of the cookie =
hmac
>>> algorithm selectable.  This is all well and good, but Linus noted that =
it
>>> changes the default config:
>>> http://marc.info/?l=3Dlinux-netdev&m=135536629004808&w=3D2
>>>
>>> I've modified the sctp Kconfig file to reflect the recommended way of m=
aking
>>> this choice, using the thermal driver example specified, and brought the
>>> defaults back into line with the way they were prior to my origional pa=
tch
>>>
>>> Also, on Linus' suggestion, re-adding ability to select default 'none' =
hmac
>>> algorithm, so we don't needlessly bloat the kernel by forcing a non-none
>>> default.  This also led me to note that we won't honor the default none
>>> condition properly because of how sctp_net_init is encoded.  Fix that u=
p as
>>> well.
>>>
>>> Tested by myself (allbeit fairly quickly).  All configuration combinati=
ons seems
>>> to work soundly.
>>>
>>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>>> CC: David Miller <davem@davemloft.net>
>>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>>> CC: Vlad Yasevich <vyasevich@gmail.com>
>>> CC: linux-sctp@vger.kernel.org
>>> ---
>>>   net/sctp/Kconfig    | 27 +++++++++++++++++++++++++--
>>>   net/sctp/protocol.c |  4 ++--
>>>   2 files changed, 27 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
>>> index a9edd2e..c262106 100644
>>> --- a/net/sctp/Kconfig
>>> +++ b/net/sctp/Kconfig
>>> @@ -66,12 +66,36 @@ config SCTP_DBG_OBJCNT
>>>   	  'cat /proc/net/sctp/sctp_dbg_objcnt'
>>>
>>>   	  If unsure, say N
>>> +choice
>>> +	prompt "Default SCTP cookie HMAC encoding"
>>> +	default SCTP_COOKIE_HMAC_MD5
>>
>> Should not this be SCTP_DEFAULT_COOKIE_HMAC_MD5? I just tried to
>> update to 3.8-rc2, and I usually build my kernel-headers with:
>>
>> yes '' | ARCH=3Dfoo make oldconfig
>>
>> and this just kept asking me for this config symbol because none
>> could be provided.
>> --
>> Florian
>>
>
> No, the config mechanism is setup to offer the user the ability to choose=
 a
> default cookie hmac, alg, then optionally select any other hmac algs you =
would
> like to be made available (in the event you want to change the default at=
 run
> time).  When you select the default, it eables (via the select directive)=
, the
> corresponding SCTP_COOKIE_HMAC_* config option, which is used in the buil=
d, and
> then prompts for the remaining values.
>

Neil

Actually, I think it should be as Florian suggests.  The default value=20
of the choice should be one of the values defined as part of the choice=20
(the SCTP_DEFAULT_COOKIE_*).  Turning on appropriate default would turn=20
on appropriate cookie config (SCTP_COOKIE_HMAC_*).

Would that save all the config trouble?

-vlad

> Neil
>

