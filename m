From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 20 Jul 2020 13:11:40 +0000
Subject: Re: [PATCH for v5.9] sctp: Replace HTTP links with HTTPS ones
Message-Id: <20200720131140.GC2491@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719202644.61663-1-grandmaster@al2klimov.de>
In-Reply-To: <20200719202644.61663-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org, corbet@lwn.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Jul 19, 2020 at 10:26:44PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
> 
>  If there are any URLs to be removed completely
>  or at least not (just) HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
> 
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
> 
>  If you apply the patch, please let me know.
> 
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)

The subject prefix is right for sctp, but the patch tag should have
been "PATCH net-next" instead. :-)

Thankfully, they can fix it for us.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
