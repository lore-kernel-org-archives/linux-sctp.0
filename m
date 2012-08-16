From: David Miller <davem@davemloft.net>
Date: Thu, 16 Aug 2012 20:37:04 +0000
Subject: Re: [patch] sctp: fix bogus if statement in sctp_auth_recv_cid()
Message-Id: <20120816.133704.75563710683878972.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20120816131618.GA23279@elgon.mountain>
	<87txw266hk.fsf@xmission.com>
In-Reply-To: <87txw266hk.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ebiederm@xmission.com
Cc: dan.carpenter@oracle.com, vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 16 Aug 2012 11:23:35 -0700

> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
>> There is an extra semi-colon here, so we always return 0 instead of
>> calling __sctp_auth_cid().
> 
> Doh.
> 
> Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied.
