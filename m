From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 21:20:21 +0000
Subject: Re: [PATCH next 2/2] sctp: make use of WORD_TRUNC macro
Message-Id: <20160920212021.GC9323@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474402102.git.marcelo.leitner@gmail.com>
 <44d3d3e5e0be1f4e557893f1dd8bcc38fae009fa.1474402102.git.marcelo.leitner@gmail.com>
In-Reply-To: <44d3d3e5e0be1f4e557893f1dd8bcc38fae009fa.1474402102.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, David Laight <David.Laight@ACULAB.COM>

On Tue, Sep 20, 2016 at 05:24:20PM -0300, Marcelo Ricardo Leitner wrote:
> +	max_data = SCTP_TRUNC4(max_data);

Will post a v2 to fix the subject.

