From: David Miller <davem@davemloft.net>
Date: Sat, 17 Sep 2016 14:00:52 +0000
Subject: Re: [PATCH net] sctp: fix SSN comparision
Message-Id: <20160917.100052.67659156559031070.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9f22e4725d836feda1b2c2483303adb30838216f.1473962178.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 15 Sep 2016 15:02:38 -0300

> This function actually operates on u32 yet its paramteres were declared
> as u16, causing integer truncation upon calling.
> 
> Note in patch context that ADDIP_SERIAL_SIGN_BIT is already 32 bits.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
