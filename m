From: David Miller <davem@davemloft.net>
Date: Fri, 08 Mar 2019 19:43:52 +0000
Subject: Re: [PATCH net 0/3] sctp: process the error returned from sctp_sock_migrate()
Message-Id: <20190308.114352.668129413376565024.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
        <20190308170002.GD13515@localhost.localdomain>
In-Reply-To: <20190308170002.GD13515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 8 Mar 2019 14:00:03 -0300

> On Sun, Mar 03, 2019 at 05:54:52PM +0800, Xin Long wrote:
>> This patchset is to process the errs returned by sctp_auth_init_hmacs()
>> and sctp_bind_addr_dup() from sctp_sock_migrate(). And also fix a panic
>> caused by new ep->auth_hmacs was not set due to net->sctp.auth_enable
>> changed by sysctl before accepting an assoc.
>> 
>> Xin Long (3):
>>   sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
>>   sctp: move up sctp_auth_init_hmacs() in sctp_endpoint_init()
>>   sctp: call sctp_auth_init_hmacs() in sctp_sock_migrate()
> 
> Series
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Series applied.
