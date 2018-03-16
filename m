From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Mar 2018 15:14:32 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180316151432.GA4832@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Mar 16, 2018 at 09:33:12AM +0000, David Neil wrote:
> Hi,
> I have been having intermittent problems with SCTP connection failures; I have finally caught one on Wireshark.

Hi David,

Two things. 1. Which kernel version are you using?

2. Not sure if debian has dynamic_printk enabled, I guess so.
Please run this command to turn on some debug printk's, which should
get activated in the case the asoc is not found.

As root:
  # echo 'func __sctp_rcv_lookup +p' > /sys/kernel/debug/dynamic_debug/control

And then reproduce the issue again. If you get a printk on dmesg, it's
because the association is not being located when the packet came in,
and thus why the Abort.

This message is available on kernel >= 4.11.

  M.
