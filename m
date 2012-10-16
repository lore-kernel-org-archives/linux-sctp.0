From: David Miller <davem@davemloft.net>
Date: Tue, 16 Oct 2012 18:56:11 +0000
Subject: Re: [PATCH] sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()
Message-Id: <20121016.145611.1344400917557072925.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1350309399-23422-1-git-send-email-nicolas.dichtel@6wind.com>
	<507C2E76.3030801@gmail.com>
In-Reply-To: <507C2E76.3030801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nicolas.dichtel@6wind.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, zijie.pan@6wind.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 15 Oct 2012 11:40:38 -0400

> On 10/15/2012 09:56 AM, nicolas.dichtel@6wind.com wrote:
>> From: Zijie Pan <zijie.pan@6wind.com>
>>
>> Bug introduced by commit edfee0339e681a784ebacec7e8c2dc97dc6d2839
>> (sctp: check src addr when processing SACK to update transport state)
>>
>> Signed-off-by: Zijie Pan <zijie.pan@6wind.com>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Shutdown case..  ACK.
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied.
