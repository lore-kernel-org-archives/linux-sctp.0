From: David Miller <davem@davemloft.net>
Date: Sun, 18 Nov 2012 03:01:48 +0000
Subject: Re: [PATCH] sctp: use bitmap_weight
Message-Id: <20121117.220148.933381645515454891.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353134389-25583-1-git-send-email-akinobu.mita@gmail.com>
	<50A83DAF.8000408@gmail.com>
In-Reply-To: <50A83DAF.8000408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: akinobu.mita@gmail.com, linux-sctp@vger.kernel.org, sri@us.ibm.com, netdev@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Sat, 17 Nov 2012 20:45:19 -0500

> On 11/17/2012 01:39 AM, Akinobu Mita wrote:
>> Use bitmap_weight to count the total number of bits set in bitmap.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Vlad Yasevich <vyasevich@gmail.com>
>> Cc: Sridhar Samudrala <sri@us.ibm.com>
>> Cc: linux-sctp@vger.kernel.org
>> Cc: netdev@vger.kernel.org
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks.
