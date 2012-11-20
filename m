From: David Miller <davem@davemloft.net>
Date: Tue, 20 Nov 2012 20:51:03 +0000
Subject: Re: [PATCH v2] sctp: send abort chunk when max_retrans exceeded
Message-Id: <20121120.155103.478583415099211037.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353434344-17864-1-git-send-email-nhorman@tuxdriver.com>
	<1353442470-20660-1-git-send-email-nhorman@tuxdriver.com>
	<50ABE754.7060306@gmail.com>
In-Reply-To: <50ABE754.7060306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 20 Nov 2012 15:25:56 -0500

> On 11/20/2012 03:14 PM, Neil Horman wrote:
>> In the event that an association exceeds its max_retrans attempts, we
>> should
>> send an ABORT chunk indicating that we are closing the assocation as a
>> result.
>> Because of the nature of the error, its unlikely to be received, but
>> its a nice
>> clean way to close the association if it does make it through, and it
>> will give
>> anyone watching via tcpdump a clue as to what happened.
>>
>> Change notes:
>> v2)
>> 	* Removed erroneous changes from sctp_make_violation_parmlen
>>
>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>> CC: Vlad Yasevich <vyasevich@gmail.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks.
