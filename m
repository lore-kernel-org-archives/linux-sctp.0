From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 10 Aug 2018 18:30:26 +0000
Subject: Re: [PATCH lksctp-tools] nagle_snd: silence false-positive compiler warning
Message-Id: <20180810183026.GD5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <6530f05626614250e2c5257356c52d180326147c.1533140085.git.marcelo.leitner@gmail.com>
In-Reply-To: <6530f05626614250e2c5257356c52d180326147c.1533140085.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 01, 2018 at 01:33:04PM -0300, Marcelo Ricardo Leitner wrote:
> I'm getting:
> nagle_snd.c: In function ‘main’:
> nagle_snd.c:275:3: warning: ‘strncpy’ output truncated before terminating nul copying 10 bytes from a string of the same length [-Wstringop-truncation]
>    strncpy(message+i, "1234567890", 10);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Turns out the code is doing that on purpose. To silence it, lets use
> memcpy() instead.

Applied.
