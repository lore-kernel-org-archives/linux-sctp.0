From: Sun Paul <paulrbk@gmail.com>
Date: Tue, 15 Dec 2015 01:19:34 +0000
Subject: Re: Question on SCTP parameters tunning
Message-Id: <CAFXGftJgFwav1hK0+52AKszAAnNRUxm_b9igfmncdGGPKeTgWA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGftJ3kdbHc54QwH6m-KEemsDXLkKSRk5E+D+F2jKtBVr4wg@mail.gmail.com>
In-Reply-To: <CAFXGftJ3kdbHc54QwH6m-KEemsDXLkKSRk5E+D+F2jKtBVr4wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All

the current memory settings on sctp is as below.

net.sctp.sctp_mem = 1531104 2041472 3062208
net.sctp.sctp_rmem = 4096 349500 4194304
net.sctp.sctp_wmem = 4096 16384 4194304

However, we observed that consumption of one particular SCTP
connection is as below.

ffff8803d0609000 ffff8804358a6500 2   1   4  21855 968785  3882668
13184   28674 1132095678 3868  18710  171.109.115.116 171.109.115.122
<-> *164.114.213.15 164.114.213.136   10000    10  2048    6    0    0
     175

The Transmit Q reaches around 3.6MB, we would like to check what is
the value we should enlarge. is there any limitation on setting the
read/write memory for LKSCTP?

Thanks

- RBK

On Tue, Dec 15, 2015 at 9:14 AM, Sun Paul <paulrbk@gmail.com> wrote:
> Hi All
>
> the current memory settings on sctp is as below.
