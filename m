From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 08 Jul 2014 09:34:33 +0000
Subject: Re: [PATCH net-next 2/5] net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
Message-Id: <53BBBB29.4040305@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
In-Reply-To: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/07/2014 10:46 AM, David Laight wrote:
...
>> @@ -1858,8 +1870,8 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>>   	pr_debug("%s: we have a valid association\n", __func__);
>>
>>   	if (!sinfo) {
>> -		/* If the user didn't specify SNDRCVINFO, make up one with
>> -		 * some defaults.
>> +		/* If the user didn't specify SNDINFO/SNDRCVINFO, make up
>> +		 * one with some defaults.
>>   		 */
>>   		memset(&default_sinfo, 0, sizeof(default_sinfo));
>
> Is this memset() needed?

This patch is not changing it, so feel free to propose one. If you zero
out the remaining fields only used for rx, you should be able to drop it,
but I guess all these micro-optimizations won't be that visible when we
have much more fundamental things to solve in SCTP stack's performance.

>>   		default_sinfo.sinfo_stream = asoc->default_stream;
>> @@ -1868,7 +1880,13 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
>>   		default_sinfo.sinfo_context = asoc->default_context;
>>   		default_sinfo.sinfo_timetolive = asoc->default_timetolive;
>>   		default_sinfo.sinfo_assoc_id = sctp_assoc2id(asoc);
>
> Maybe keep the parameters in a 'sinfo' structure within the 'asoc' ?

I think asocs and other SCTP structs are already 'fat' and use up too
many cachelines, they rather need a diet and some careful analysis on
access patterns.
