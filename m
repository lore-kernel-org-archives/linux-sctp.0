From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 26 Jun 2013 18:35:13 +0000
Subject: Re: [PATCH net-next 1/2] lib: vsprintf: add IPv4/v6 generic %pig/%pIg format specifier
Message-Id: <51CB3461.9020703@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372266073-11998-1-git-send-email-dborkman@redhat.com> <1372266073-11998-2-git-send-email-dborkman@redhat.com> <51CB2477.6070903@gmail.com>
In-Reply-To: <51CB2477.6070903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06/26/2013 07:27 PM, Vlad Yasevich wrote:
> On 06/26/2013 01:01 PM, Daniel Borkmann wrote:
>> In order to avoid making code that deals with printing both, IPv4 and
>> IPv6 addresses, unnecessary complicated as for example ...
>>
>>    if (sa.sa_family = AF_INET6)
>>      printk("... %pI6 ...", sin6_addr);
>>    else
>>      printk("... %pI4 ...", sin_addr.s_addr);
>>
>> ... it would be better to introduce a format specifier that can deal
>> with those kind of situations internally; just as we have a "struct
>> sockaddr" for generic mapping into "struct sockaddr_in" or "struct
>> sockaddr_in6" as e.g. done in "union sctp_addr". Then, we could
>> reduce the above statement into something like:
>>
>>    printk("... %pIg ..", &sockaddr);
>>
>> While we're at it, support for both %pig/%pIg, where 'g' stands for
>> generic, comes for free. In case our pointer is NULL, pointer() then
>> deals with that already at an earlier point in time internally.
>>
>> Likely, there are many other areas than just SCTP in the kernel to make
>> use of this extension as well.
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> ---
>>   lib/vsprintf.c | 18 ++++++++++++++++--
>>   1 file changed, 16 insertions(+), 2 deletions(-)
>
> I think you should also update Documentation/printk-formats.txt

If you prefer, I could do a follow-up patch, otherwise I'd send a v2 of
the set by tomorrow if there's nothing else, let me know.

Thanks,
Daniel
