From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 10 Aug 2018 18:29:17 +0000
Subject: Re: [PATCH lksctp-tools] doc: update docs to match current rfc documents
Message-Id: <20180810182917.GB5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <6b56ee62ae03b3ed19091c75346b558545109c34.1533140089.git.marcelo.leitner@gmail.com>
In-Reply-To: <6b56ee62ae03b3ed19091c75346b558545109c34.1533140089.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Aug 01, 2018 at 01:33:03PM -0300, Marcelo Ricardo Leitner wrote:
> We applied some changes to the docs but forgot to update Makefile.am to
> reflect them, so currently 'make distcheck' fails with some files not
> being found.
> 
> This patch syncs it with the current folder content.

Applied.
