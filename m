From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 26 Oct 2016 05:54:03 +0000
Subject: Re: [PATCH net] sctp: validate chunk len before actually using it
Message-Id: <CADvbK_d4ZJB0HXgmtio3HNGMGkNbOG+Af_74r+kuc=ovjxFffw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <06d1d4f21f959784823d7c7e31c3ea7e7360cb99.1477410525.git.marcelo.leitner@gmail.com>
In-Reply-To: <06d1d4f21f959784823d7c7e31c3ea7e7360cb99.1477410525.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, syzkaller <syzkaller@googlegroups.com>, kcc@google.com, glider@google.com, Eric Dumazet <edumazet@google.com>, Dmitry Vyukov <dvyukov@google.com>, andreyknvl@google.com

On Wed, Oct 26, 2016 at 12:27 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> Andrey Konovalov reported that KASAN detected that SCTP was using a slab
> beyond the boundaries. It was caused because when handling out of the
> blue packets in function sctp_sf_ootb() it was checking the chunk len
> only after already processing the first chunk, validating only for the
> 2nd and subsequent ones.
>
> The fix is to just move the check upwards so it's also validated for the
> 1st chunk.
>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Tested-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Reviewed-by: Xin Long <lucien.xin@gmail.com>
