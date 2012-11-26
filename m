From: David Miller <davem@davemloft.net>
Date: Mon, 26 Nov 2012 22:34:56 +0000
Subject: Re: [PATCH] sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall
Message-Id: <20121126.173456.681656925010309957.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1353590596-12216-1-git-send-email-tt.rantala@gmail.com>
	<50B38339.40105@gmail.com>
In-Reply-To: <50B38339.40105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: tt.rantala@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, sri@us.ibm.com, davej@redhat.com

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Mon, 26 Nov 2012 09:56:57 -0500

> On 11/22/2012 08:23 AM, Tommi Rantala wrote:
>> Consider the following program, that sets the second argument to the
>> sendto() syscall incorrectly:
 ...
>> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
> 
> Looks good
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

I'll apply this after the other SCTP fix is respun, because there
is a dependency.
