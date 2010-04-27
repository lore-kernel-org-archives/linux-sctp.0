From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 27 Apr 2010 17:32:56 +0000
Subject: Re: [patch v2] sctp: cleanup: remove duplicate assignment
Message-Id: <4BD71FC8.9060002@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD1AE9D.6090807@hp.com>	<20100424171805.GO29093@bicker>	<4BD6F582.9030804@hp.com> <20100427.095823.98890165.davem@davemloft.net>
In-Reply-To: <20100427.095823.98890165.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: error27@gmail.com, sri@us.ibm.com, yjwei@cn.fujitsu.com, cdischino@sonusnet.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org



David Miller wrote:
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Tue, 27 Apr 2010 10:32:34 -0400
> 
>>
>> Dan Carpenter wrote:
>>> This assignment isn't needed because we did it earlier already.
>>>
>>> Also another reason to delete the assignment is because it triggers a
>>> Smatch warning about checking for NULL pointers after a dereference.
>>>
>>> Reported-by: Vlad Yasevich <vladislav.yasevich@hp.com>
>>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>> Thanks.  I'll take this one.
> 
> And when will I get this from you? :-)

By the end of the week.  I am trying to get all the testing finished. :)

-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
