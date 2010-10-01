From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@gmail.com>
Date: Fri, 01 Oct 2010 09:35:48 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl() (take 3)
Message-Id: <1285925748.6591.569.camel@yamato.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <1285725095-9860-1-git-send-email-flameeyes@gmail.com>
	 <20100930.173557.108787840.davem@davemloft.net>
In-Reply-To: <20100930.173557.108787840.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Il giorno gio, 30/09/2010 alle 17.35 -0700, David Miller ha scritto:
> 
> 
> Please put the break statement inside of the basic block.
> 
> The way you have it here the indentation looks not so nice. 

Okay will resend; please do note that I copied the style (and most of
the code) from dccp anyway.

-- 
Diego Elio Pettenò — “Flameeyes”
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


