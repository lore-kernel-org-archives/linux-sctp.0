From: Edward Cree <ecree@solarflare.com>
Date: Wed, 28 Sep 2016 15:58:22 +0000
Subject: Local variable ordering (was Re: [PATCH v5 0/7] Reduce cache miss for snmp_fold_field)
Message-Id: <5734f230-eafa-45a1-9635-98721f872b38@solarflare.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1475043748-18161-1-git-send-email-hejianet@gmail.com>
 <20160928.050817.110671274247345232.davem@davemloft.net>
 <c44daa11-dc57-84fa-35cc-40ee0fe293f3@gmail.com>
In-Reply-To: <c44daa11-dc57-84fa-35cc-40ee0fe293f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hejianet <hejianet@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, vyasevich@gmail.com, nhorman@tuxdriver.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, marcelo.leitner@gmail.com

On 28/09/16 14:45, hejianet wrote:
>
>
> On 9/28/16 5:08 PM, David Miller wrote:
>> From: Jia He <hejianet@gmail.com>
>> Date: Wed, 28 Sep 2016 14:22:21 +0800
>>
>>> v5:
>>> - order local variables from longest to shortest line
>> I still see many cases where this problem still exists.  Please
>> do not resubmit this patch series until you fix all of them.
>>
>> Patch #2:
>>
>> -static int snmp_seq_show(struct seq_file *seq, void *v)
>> +static int snmp_seq_show_ipstats(struct seq_file *seq, void *v)
>>   {
>>       int i;
>> +    u64 buff64[IPSTATS_MIB_MAX];
>>       struct net *net = seq->private;
>>
>> The order should be "net" then "buff64" then "i".
> Sorry for my bad eyesight and quick hand :(
> B.R.
> Jia
A few months back I wrote a script to help find these:
https://github.com/ecree-solarflare/xmastree
It can check a source file or a patch.
Posting in the hope that people will find it useful.

-Ed
The information contained in this message is confidential and is intended for the addressee(s) only. If you have received this message in error, please notify the sender immediately and delete the message. Unless you are an addressee (or authorized to receive for an addressee), you may not use, copy or disclose to anyone this message or any information contained in this message. The unauthorized use, disclosure, copying or alteration of this message is strictly prohibited.
