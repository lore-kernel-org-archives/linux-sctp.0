From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 16 Aug 2016 22:59:17 +0000
Subject: Re: [PATCH net] sctp: linearize early if it's not GSO
Message-Id: <57B39AC5.7000002@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a4bc263e62ced9f5790932f11e7d829c36566808.1471386679.git.marcelo.leitner@gmail.com>
In-Reply-To: <a4bc263e62ced9f5790932f11e7d829c36566808.1471386679.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

On 08/17/2016 12:35 AM, Marcelo Ricardo Leitner wrote:
> Because otherwise when crc computation is still needed it's way more
> expensive than on a linear buffer to the point that it affects
> performance.
>
> It's so expensive that netperf test gives a perf output as below:
>
> Overhead  Shared Object        Symbol
>    69,44%  [kernel]             [k] gf2_matrix_square
>     2,84%  [kernel]             [k] crc32_generic_combine.part.0
>     2,78%  [kernel]             [k] _raw_spin_lock_bh

What kernel is this, seems not net kernel?

$ git grep -n gf2_matrix_square
$ git grep -n crc32_generic_combine
$

Maybe RHEL? Did you consider backporting 6d514b4e7737 et al?

> And performance goes from 2Gbit/s to 0.5Gbit/s on this test. Doing the
> linearization before checksumming is enough to restore it.
>
> Fixes: 3acb50c18d8d ("sctp: delay as much as possible skb_linearize")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
