From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 04 Jun 2018 20:19:47 +0000
Subject: Re: [PATCH lksctp-tools 00/12] build: detect kernel features when building
Message-Id: <20180604201947.GA2693@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1527700680.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1527700680.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, May 30, 2018 at 02:17:51PM -0300, Marcelo Ricardo Leitner wrote:
> Currently we have an issue with struct sctp_event_subscribe. Kernel
> won't accept any buffer larger than the version of sctp_event_subscribe
> that is expects, and because of that we cannot simply have a copy of
> kernel headers inside lksctp-tools. If we do, we have no way to use the
> right version of sctp_event_subscribe.

(late email)
Series applied.
