From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Fri, 27 Dec 2019 02:47:51 +0000
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Message-Id: <647b9a55-6236-5d67-6ba8-8a62e828f89c@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
 <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
 <20191226.153835.1092744996447366504.davem@davemloft.net>
 <20191227022801.GI5058@localhost.localdomain>
In-Reply-To: <20191227022801.GI5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org



On 2019/12/27 10:28, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 26, 2019 at 03:38:35PM -0800, David Miller wrote:
>> From: Kevin Kou <qdkevin.kou@gmail.com>
>> Date: Fri, 27 Dec 2019 07:09:07 +0800
>>
>>>
>>>
>>>> From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
>>>> Date: Thu, 26 Dec 2019 12:29:17 +0000
>>>>
>>>>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
>>>>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
>>>>> and trigger sctp_probe_path_trace in sctp_outq_sack.
>>>> ...
>>>>
>>>> Applied, but why did you remove the trace enabled check, just out of
>>>> curiosity?
>>>
>>> Actually, the check in trace_sctp_probe_path_enabled also done in
>>> trace_sctp_probe_path according to the Macro definition, both check
>>> if (static_key_false(&__tracepoint_##name.key)).
>>
>> Indeed, thanks for the explanation.
> 
> It was duplicated, yes, but it was also a small optimization:
> 
> if (enabled) {
>    for (X times) {
>      if (enabled) {
>      }
>    }
> }
> 
> So it wouldn't traverse the list if not needed.  But X is usually 1 or
> 2 and this list is already traversed multiple times in this code path.
> 

Yes, It is a small optimization indeed. let me changed a little, do 
testing and resend another patch. Thanks for your comments, Marcelo.
