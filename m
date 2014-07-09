From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 09 Jul 2014 07:59:52 +0000
Subject: Re: [PATCH net-next 0/5] SCTP updates
Message-Id: <53BCF678.7060107@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1404507908-6949-1-git-send-email-dborkman@redhat.com> <20140708.144022.1506800165140398530.davem@davemloft.net>
In-Reply-To: <20140708.144022.1506800165140398530.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: geirola@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 07/08/2014 11:40 PM, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Fri,  4 Jul 2014 23:05:03 +0200
>
>> This set improves the SCTP socket API to be more in line with
>> RFC6458, Geir and myself have finalized it eventually. While
>> at it, the first patch also fixes two possible information
>> leaks that should go to net tree as well. For more details, I
>> refer you to the patches themselves.
>>
>> Thanks a lot.
>
> Where are we with this series?  Will there be another respin?

I'll add a 6th patch into the series to address Neil's feedback
and will respin with the rest unchanged. I'll try to get to that
by today. Thanks.
