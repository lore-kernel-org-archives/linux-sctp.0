From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 12 Jan 2016 08:41:18 +0000
Subject: Re: [PATCH] sctp: fix use-after-free in pr_debug statement
Message-Id: <CACT4Y+Z+f4DQRQo0zuH8+7q799dJuGFtjmak7tOMx_TWdrX3Kw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <566AF20F.9060504@gmail.com> <51dffdfdb37c240ff7e9b0b2a93433f217fa4d2c.1452257700.git.marcelo.leitner@gmail.com>
 <20160111.171345.1807630667848434364.davem@davemloft.net>
In-Reply-To: <20160111.171345.1807630667848434364.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Vladislav Yasevich <vyasevich@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>

On Mon, Jan 11, 2016 at 11:13 PM, David Miller <davem@davemloft.net> wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Fri,  8 Jan 2016 11:00:54 -0200
>
>> Dmitry Vyukov reported a use-after-free in the code expanded by the
>> macro debug_post_sfx, which is caused by the use of the asoc pointer
>> after it was freed within sctp_side_effect() scope.
>>
>> This patch fixes it by allowing sctp_side_effect to clear that asoc
>> pointer when the TCB is freed.
>>
>> As Vlad explained, we also have to cover the SCTP_DISPOSITION_ABORT case
>> because it will trigger DELETE_TCB too on that same loop.
>>
>> Also, there were places issuing SCTP_CMD_INIT_FAILED and ASSOC_FAILED
>> but returning SCTP_DISPOSITION_CONSUME, which would fool the scheme
>> above. Fix it by returning SCTP_DISPOSITION_ABORT instead.
>>
>> The macro is already prepared to handle such NULL pointer.
>>
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>
> Applied, thank you.


Tested with this patch for half a day. I did not see any reports
related to pr_debug. Let's consider this as fixed.
Thanks!
