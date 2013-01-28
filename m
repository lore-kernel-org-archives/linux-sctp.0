From: David Miller <davem@davemloft.net>
Date: Mon, 28 Jan 2013 00:32:55 +0000
Subject: Re: [PATCH v2] sctp: set association state to established in dupcook_a handler
Message-Id: <20130127.193255.422316407262674573.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1358995474-28369-1-git-send-email-xufengzhang.main@gmail.com>
	<51014DC1.4070209@gmail.com>
In-Reply-To: <51014DC1.4070209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: xufengzhang.main@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 24 Jan 2013 10:05:37 -0500

> On 01/23/2013 09:44 PM, xufengzhang.main@gmail.com wrote:
>> From: Xufeng Zhang <xufeng.zhang@windriver.com>
>>
>> While sctp handling a duplicate COOKIE-ECHO and the action is
>> 'Association restart', sctp_sf_do_dupcook_a() will processing
>> the unexpected COOKIE-ECHO for peer restart, but it does not set
>> the association state to SCTP_STATE_ESTABLISHED, so the association
>> could stuck in SCTP_STATE_SHUTDOWN_PENDING state forever.
>> This violates the sctp specification:
>>    RFC 4960 5.2.4. Handle a COOKIE ECHO when a TCB Exists
>>    Action
>>    A) In this case, the peer may have restarted. .....
>>       After this, the endpoint shall enter the ESTABLISHED state.
>>
>> To resolve this problem, adding a SCTP_CMD_NEW_STATE cmd to the
>> command list before SCTP_CMD_REPLY cmd, this will set the restart
>> association to SCTP_STATE_ESTABLISHED state properly and also avoid
>> I-bit being set in the DATA chunk header when COOKIE_ACK is bundled
>> with DATA chunks.
>>
>> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> 
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
