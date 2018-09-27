From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 27 Sep 2018 15:10:45 +0000
Subject: Re: [PATCH lksctp-tools] func_tests: fix use of uninitialized var
Message-Id: <20180927151045.GA6761@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <04a0012e5f7a25b2995813c17cd5f38245eb9fe4.1537980726.git.marcelo.leitner@gmail.com>
In-Reply-To: <04a0012e5f7a25b2995813c17cd5f38245eb9fe4.1537980726.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Sep 26, 2018 at 01:53:58PM -0300, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> code-share1 reported that test_1_to_1_events was failing with:
> ./test_1_to_1_events
> test_1_to_1_events.c 1 PASS : COMM_UP notification on client socket - SUCCESS
> test_1_to_1_events.c 2 PASS : COMM_UP notification on server socket - SUCCESS
> test_1_to_1_events.c 3 BROK : Got a datamsg, expecting notification
> DUMP_CORE sctputil.c: 187
> 
> Turns out we were not initializing events, and thus relying on trash in
> the stack to enable sctp_authentication_event for us.
> 
> Fixes #25
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied.
