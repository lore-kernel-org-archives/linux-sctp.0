From: David Miller <davem@davemloft.net>
Date: Thu, 26 Dec 2019 23:38:35 +0000
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Message-Id: <20191226.153835.1092744996447366504.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
        <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
In-Reply-To: <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: qdkevin.kou@gmail.com
Cc: netdev@vger.kernel.org, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Fri, 27 Dec 2019 07:09:07 +0800

> 
> 
>>From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
>>Date: Thu, 26 Dec 2019 12:29:17 +0000
>>
>>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
>>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
>>> and trigger sctp_probe_path_trace in sctp_outq_sack.
>> ...
>>
>>Applied, but why did you remove the trace enabled check, just out of
>>curiosity?
> 
> Actually, the check in trace_sctp_probe_path_enabled also done in
> trace_sctp_probe_path according to the Macro definition, both check
> if (static_key_false(&__tracepoint_##name.key)).

Indeed, thanks for the explanation.
