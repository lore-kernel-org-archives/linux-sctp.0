From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 03 Oct 2020 18:07:31 +0000
Subject: Re: [PATCH lksctp-tools] Use symvmer attribute, not asms for symbol versioning
Message-Id: <20201003180731.GJ70998@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Fri, Sep 18, 2020 at 08:48:30PM +0200, Petr Lautrbach wrote:
> This project could not be built with LTO as it uses ASMs to implement
> symbol versioning. ASMs like this are fundamentally incompatible with
> LTO because GCC does not look inside the ASM string to find symbol
> references. Starting with gcc-10 there is a new symbol attribute for
> implementing symbol versioning.
> 
> A fallback to the old way of implementing symbol versioning via asms is
> included, so it should work with clang as well as gcc-9 and
> earlier.
> 
> Fixes: https://github.com/sctp/lksctp-tools/issues/35
> 
> Author: Jeff Law <law@redhat.com>
> Signed-off-by: Petr Lautrbach <plautrba@redhat.com>

Applied, thanks.
