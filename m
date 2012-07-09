From: David Miller <davem@davemloft.net>
Date: Mon, 09 Jul 2012 06:54:38 +0000
Subject: Re: [PATCH] sctp: refactor sctp_packet_append_chunk and clenup some memory leaks
Message-Id: <20120708.235438.1404481344298927770.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1341259164-7396-1-git-send-email-nhorman@tuxdriver.com>
	<4FF30428.6070403@gmail.com>
In-Reply-To: <4FF30428.6070403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 03 Jul 2012 10:39:36 -0400

> On 07/02/2012 03:59 PM, Neil Horman wrote:
>> While doing some recent work on sctp sack bundling I noted that
>> sctp_packet_append_chunk was pretty inefficient.  Specifially, it was
>> called
>> recursively while trying to bundle auth and sack chunks.  Because of
>> that we
>> call sctp_packet_bundle_sack and sctp_packet_bundle_auth a total of 4
>> times for
>> every call to sctp_packet_append_chunk, knowing that at least 3 of
>> those calls
>> will do nothing.
>>
>> So lets refactor sctp_packet_bundle_auth to have an outer part that
>> does the
>> attempted bundling, and an inner part that just does the chunk
>> appends.  This
>> saves us several calls per iteration that we just don't need.
>>
>> Also, noticed that the auth and sack bundling fail to free the chunks
>> they
>> allocate if the append fails, so make sure we add that in
>>
>> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>
>> CC: Vlad Yasevich<vyasevich@gmail.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied to net-next, thanks.
