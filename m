From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 19:46:21 +0000
Subject: Re: [PATCH 2/5] sctp: Delete an error message for a failed memory allocation in sctp_init()
Message-Id: <2c849843-549f-419e-2326-1fcb7bcdc2e2@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2845df67-d35d-536a-0a53-b2eb83fe1ba5@users.sourceforge.net>
 <7db0cb49-109b-88a6-532f-c591cc8ffa85@users.sourceforge.net>
 <20170522165658.GA4642@localhost.localdomain>
In-Reply-To: <20170522165658.GA4642@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

>> +++ b/net/sctp/protocol.c
>> @@ -1447,5 +1447,4 @@ static __init int sctp_init(void)
>>  	if (!sctp_ep_hashtable) {
>> -		pr_err("Failed endpoint_hash alloc\n");
> 
> Okay but then why not also delete the one a few lines below this one:
>         if (!sctp_port_hashtable) {
>                 pr_err("Failed bind hash alloc\n");
>                 status = -ENOMEM;
>                 goto err_bhash_alloc;
>         }
> Seems the same pattern to me.
> 
>>  		status = -ENOMEM;
>>  		goto err_ehash_alloc;
>>  	}

How do you think about to remove the other error message in another
update step if a consensus would be achieved in such a direction
for this software module?

Regards,
Markus
