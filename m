From: David Miller <davem@davemloft.net>
Date: Tue, 18 Jun 2013 00:08:26 +0000
Subject: Re: [PATCH net-next 0/2] Two SCTP cleanup patches
Message-Id: <20130617.170826.676615336737500846.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371462005-19310-1-git-send-email-dborkman@redhat.com>
	<51BF1576.4080203@gmail.com>
In-Reply-To: <51BF1576.4080203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 17 Jun 2013 09:56:06 -0400

> On 06/17/2013 05:40 AM, Daniel Borkmann wrote:
>> Two cleanup-only patches to make the code more readable and consistent
>> with the rest of the kernel code.
>>
>> Daniel Borkmann (2):
>>    net: sctp: get rid of t_new macro for kzalloc
>>    net: sctp: remove SCTP_STATIC macro
>>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Series applied, thanks everyone.
