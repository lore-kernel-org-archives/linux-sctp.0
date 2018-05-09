From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 09 May 2018 11:25:58 +0000
Subject: Re: [PATCH lksctp-tools 0/2] CI improvements
Message-Id: <20180509112558.GB29443@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525835560.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1525835560.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, May 09, 2018 at 12:16:33AM -0300, Marcelo Ricardo Leitner wrote:
> Small adjustments:
> - make use of make -j when building
> - enable test email notifications to the mailing list
> 
> The email notification to the list is a bit debatable, but I'd like to
> enable it so we raise awareness of these tests, at least for now.
> 
> Marcelo Ricardo Leitner (2):
>   travis: use parallel build
>   travis: enable email notifications
> 
>  .travis.yml | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --
> 2.14.3
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

Though it might be better to just use -j without an arg, as IIRC that should
naturally reach the number of online processors

Neil

