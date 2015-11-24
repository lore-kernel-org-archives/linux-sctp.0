From: David Miller <davem@davemloft.net>
Date: Tue, 24 Nov 2015 21:12:21 +0000
Subject: Re: use-after-free in sctp_do_sm
Message-Id: <20151124.161221.2298803524396370874.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CACT4Y+aAYy4-Ow+gt+1C46CK1+MbspBMM7qz9pVYsXvGXRJ1SQ@mail.gmail.com>
	<CACT4Y+YjAhRSYDFUZYydtWfRzi1yDEKtPrPsJqYN93Km91J=Cw@mail.gmail.com>
	<20151124204553.GB3364@hmsreliant.think-freely.org>
In-Reply-To: <20151124204553.GB3364@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: dvyukov@google.com, vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzkaller@googlegroups.com, kcc@google.com, glider@google.com, sasha.levin@oracle.com, edumazet@google.com, maze@google.com

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 24 Nov 2015 15:45:54 -0500

>> The right commit is:
>> 
>> commit 7d267278a9ece963d77eefec61630223fce08c6c
>> Author: Rainer Weikusat
>> Date:   Fri Nov 20 22:07:23 2015 +0000
>>     unix: avoid use-after-free in ep_remove_wait_queue
> This commit doesn't seem to exist

It's in the 'net' tree.  Which hasn't been pulled into 'net-next' for
a few days.
