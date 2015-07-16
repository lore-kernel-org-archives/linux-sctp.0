From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 16 Jul 2015 11:18:03 +0000
Subject: Re: [PATCH v2 0/2] Avoid link dependency of dlm on sctp module
Message-Id: <20150716111803.GA31148@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1436891629.git.marcelo.leitner@gmail.com>
 <20150715135714.GB24091@hmsreliant.think-freely.org>
 <20150715.135918.1121936842089030351.davem@davemloft.net>
In-Reply-To: <20150715.135918.1121936842089030351.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: marcelo.leitner@gmail.com, netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

On Wed, Jul 15, 2015 at 01:59:18PM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Wed, 15 Jul 2015 09:57:14 -0400
> 
> > Series
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 
> I don't like this at all.
> 
> I know it's a pain in the ass to have this dependency on SCTP, but
> calling exported functions is absolutely the right way to handle
> this kind of situation.

I have to disagree.  Its certainly true that a direct call from the kernel is
the right current way to handle a need for functionality in an external module,
but I think its important to offer a mechanism that allows for modules to not
load functionality that they don't need at run time (that is to say, if dlm
decides to use tcp rather than sctp, the sctp module shouldn't be loaded).

Its not a crisis in either case, but it sure would be nice to not load a module
just because a symbol reference exists.

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
