From: David Miller <davem@davemloft.net>
Date: Tue, 02 Jul 2013 07:08:39 +0000
Subject: Re: [PATCH net-next] net: sctp: get rid of SCTP_DBG_TSNS entirely
Message-Id: <20130702.000839.846997927323668267.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1372671096-27129-1-git-send-email-dborkman@redhat.com>
	<51D1A1A7.60903@gmail.com>
In-Reply-To: <51D1A1A7.60903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 01 Jul 2013 11:35:03 -0400

> On 07/01/2013 05:31 AM, Daniel Borkmann wrote:
>> After having reworked the debugging framework, Neil and Vlad agreed to
>> get rid of the leftover SCTP_DBG_TSNS code for a couple of reasons:
>>
>> We can use systemtap scripts to investigate these things, we now have
>> pr_debug() helpers that make life easier, and if we really need
>> anything
>> else besides those tools, we will be forced to come up with something
>> better than we have there. Therefore, get rid of this ifdef debugging
>> code entirely for now.
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> CC: Vlad Yasevich <vyasevich@gmail.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
