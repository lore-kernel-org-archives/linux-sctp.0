From: David Miller <davem@davemloft.net>
Date: Tue, 27 Apr 2010 16:58:23 +0000
Subject: Re: [patch v2] sctp: cleanup: remove duplicate assignment
Message-Id: <20100427.095823.98890165.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD1AE9D.6090807@hp.com>
	<20100424171805.GO29093@bicker>
	<4BD6F582.9030804@hp.com>
In-Reply-To: <4BD6F582.9030804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: error27@gmail.com, sri@us.ibm.com, yjwei@cn.fujitsu.com, cdischino@sonusnet.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 27 Apr 2010 10:32:34 -0400

> 
> 
> Dan Carpenter wrote:
>> This assignment isn't needed because we did it earlier already.
>> 
>> Also another reason to delete the assignment is because it triggers a
>> Smatch warning about checking for NULL pointers after a dereference.
>> 
>> Reported-by: Vlad Yasevich <vladislav.yasevich@hp.com>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Thanks.  I'll take this one.

And when will I get this from you? :-)
