From: David Miller <davem@davemloft.net>
Date: Tue, 12 Feb 2013 21:05:39 +0000
Subject: Re: [PATCH net-next v2] net: sctp: remove unused multiple cookie keys
Message-Id: <20130212.160539.954346046111294909.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1360682133-17658-1-git-send-email-dborkman@redhat.com>
	<511A631A.60803@gmail.com>
In-Reply-To: <511A631A.60803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevic@redhat.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Tue, 12 Feb 2013 10:43:22 -0500

> On 02/12/2013 10:15 AM, Daniel Borkmann wrote:
>> Vlad says: The whole multiple cookie keys code is completely unused
>> and has been all this time. Noone uses anything other then the
>> secret_key[0] since there is no changeover support anywhere.
>>
>> Thus, for now clean up its left-over fragments.
>>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Vlad Yasevich <vyasevic@redhat.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
