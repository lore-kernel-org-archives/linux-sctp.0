From: Wei Zhao <wallyzhao@gmail.com>
Date: Mon, 04 Nov 2019 14:14:00 +0000
Subject: Re: [sctp] 327fecdaf3: BUG:kernel_NULL_pointer_dereference,address
Message-Id: <CAFRmqq6vNg5sBYp7voT4SoVR+i+L8fDqUUZOF68cRdcKkQcZmw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
 <20191104084635.GM29418@shao2-debian> <20191104132508.GA53856@localhost.localdomain>
In-Reply-To: <20191104132508.GA53856@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: kernel test robot <rong.a.chen@intel.com>, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com, lkp@lists.01.org

On 11/4/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, Nov 04, 2019 at 04:46:35PM +0800, kernel test robot wrote:
>> [   35.312661] BUG: kernel NULL pointer dereference, address:
>> 00000000000005d8
>> [   35.316225] #PF: supervisor read access in kernel mode
>> [   35.319178] #PF: error_code(0x0000) - not-present page
>> [   35.322078] PGD 800000021b569067 P4D 800000021b569067 PUD 21b688067 PMD
>> 0
>> [   35.325629] Oops: 0000 [#1] SMP PTI
>> [   35.327965] CPU: 0 PID: 3148 Comm: trinity-c5 Not tainted
>> 5.4.0-rc3-01107-g327fecdaf39ab #12
>> [   35.332863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.10.2-1 04/01/2014
>> [   35.337932] RIP: 0010:sctp_packet_transmit+0x767/0x822
>
> Right, as asoc can be NULL by then. (per the check on it a few lines
> before the change here).

Yes, apologize for missing the NULL check (Actually I realized some
further check is need to correctly identify the first in flight
packet, as outstanding_bytes has already been increased by this first
in flight packet itself before getting into sctp_packet_transmit).

Anyway, I think I do not need further action, as the patch is anyway
not going to be merged, the 0day robot picks up the patch from the
mail list directly instead of git repo, right?

Thanks a lot,
Wally

>
>   Marcelo
>
