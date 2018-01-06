From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 06 Jan 2018 17:09:45 +0000
Subject: Re: KASAN: use-after-free Read in sctp_packet_transmit
Message-Id: <CACT4Y+Y_kWEqfqSEiq_yOk7_nm5MuejNbORcfQgspzKHC3aTng@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fcf4cf899b405620eaa66@google.com> <20180106170254.GH725@localhost.localdomain>
In-Reply-To: <20180106170254.GH725@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: syzbot <syzbot+5adcca18fca253b4cb15@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, syzkaller-bugs@googlegroups.com, Vladislav Yasevich <vyasevich@gmail.com>

On Sat, Jan 6, 2018 at 6:02 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Fri, Jan 05, 2018 at 02:07:01PM -0800, syzbot wrote:
>> Hello,
>>
>> syzkaller hit the following crash on
>> 8a4816cad00bf14642f0ed6043b32d29a05006ce
>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached
>> Raw console output is attached.
>> Unfortunately, I don't have any reproducer for this bug yet.
>
> How can we tell if there wasn't any list corruption messages before
> the panic?

Hi Marcelo,

syzbot always gives reports on non-tainted kernels. So, no, there was
nothing bad before this.
