From: malc <mlashley@gmail.com>
Date: Fri, 15 Jan 2016 09:44:43 +0000
Subject: Re: how can I remove Adaptation Layer Indication parameter in INIT_ACK?
Message-Id: <CAPkQJpQbTTJTY6M1nSrFor0RnCd6wvsQgW_U9gPYwNJtg8baZw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <BN3PR1201MB09327E89F594EB408BE798AE8BCD0@BN3PR1201MB0932.namprd12.prod.outlook.com>
In-Reply-To: <BN3PR1201MB09327E89F594EB408BE798AE8BCD0@BN3PR1201MB0932.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

It's in the net/sctp subdirectory of the kernel source... the details
are right there in the link I gave you (on the diff ... line)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c



On Fri, Jan 15, 2016 at 9:34 AM, Wenzhuo Zhan <wenzhuo.zhan@mitel.com> wrote:
> Hi malc,
>
> Yes, it is our old lab environment. And could you tell me where is file of sm_make_chunk.c?
>
>
> # uname -a
> Linux MTAP35 2.6.18-1.2798.fc6 #1 SMP Mon Oct 16 14:54:20 EDT 2006 i686 i686 i386 GNU/Linux
> [root@MTAP35 src]# cd /usr/src/kernels/2.6.18-1.2798.fc6-i586/include/net/sctp
> [root@MTAP35 sctp]# ll
> total 204
> -rw-r--r-- 1 root root  8377 Sep 20  2006 command.h
> -rw-r--r-- 1 root root 13946 Sep 20  2006 constants.h
> -rw-r--r-- 1 root root 18455 Sep 20  2006 sctp.h
> -rw-r--r-- 1 root root 15433 Sep 20  2006 sm.h
> -rw-r--r-- 1 root root 59974 Sep 20  2006 structs.h
> -rw-r--r-- 1 root root  6589 Sep 20  2006 tsnmap.h
> -rw-r--r-- 1 root root  4834 Sep 20  2006 ulpevent.h
> -rw-r--r-- 1 root root  3061 Sep 20  2006 ulpqueue.h
> -rw-r--r-- 1 root root 19221 Sep 20  2006 user.h
>
>
>
> Thank you for your support!
>
> BR!
>
> -----Original Message-----
> From: malc [mailto:mlashley@gmail.com]
> Sent: 2016年1月15日 17:23
> To: Wenzhuo Zhan
> Cc: lksctp-developers-owner@lists.sourceforge.net; linux-sctp@vger.kernel.org
> Subject: Re: how can I remove Adaptation Layer Indication parameter in INIT_ACK?
>
> Are you using a particularly old kernel? This was patched years ago to only include ALI in INIT{_ACK} if the user has specified a valid (i.e.
> non-zero) application code-point.
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?idoc791ee631728b2beddda87560f1af59e32230e
>
> Cheers,
> malc.
>
> On Fri, Jan 15, 2016 at 7:42 AM, Wenzhuo Zhan <wenzhuo.zhan@mitel.com> wrote:
>> Hi,
>>
>> This address of linux-sctp@vger.kernel.org can not  be sent
>> successfully anyway.
>>
>> BR!
>>
>> -----Original Message-----
>> From: lksctp-developers-owner@lists.sourceforge.net
>> [mailto:lksctp-developers-owner@lists.sourceforge.net]
>> Sent: 2016年1月13日 19:49
>> To: Wenzhuo Zhan
>> Subject: how can I remove Adaptation Layer Indication parameter in INIT_ACK?
>>
>> Please use linux-sctp@vger.kernel.org for posting SCTP questions.
>>
>> ________________________________
>> NOTE: This e-mail (including any attachments) is for the sole use of the intended recipient(s) and may contain information that is confidential and/or protected by legal privilege. Any unauthorized review, use, copy, disclosure or distribution of this e-mail is strictly prohibited. If you are not the intended recipient, please notify Mitel immediately and destroy all copies of this e-mail. Mitel does not accept any liability for breach of security, error or virus that may result from the transmission of this message.
