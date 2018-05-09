From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 14:36:20 +0000
Subject: Re: [PATCH lksctp-tools 0/2] CI improvements
Message-Id: <20180509143620.GR5105@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1525835560.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1525835560.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, May 09, 2018 at 07:25:58AM -0400, Neil Horman wrote:
> On Wed, May 09, 2018 at 12:16:33AM -0300, Marcelo Ricardo Leitner wrote:
> > Small adjustments:
> > - make use of make -j when building
> > - enable test email notifications to the mailing list
> >
> > The email notification to the list is a bit debatable, but I'd like to
> > enable it so we raise awareness of these tests, at least for now.
> >
> > Marcelo Ricardo Leitner (2):
> >   travis: use parallel build
> >   travis: enable email notifications
> >
> >  .travis.yml | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > --
> > 2.14.3
> >
> >
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
>
> Though it might be better to just use -j without an arg, as IIRC that should
> naturally reach the number of online processors

Without an arg it means 'unlimited'. For a library that has 23 .c
files (not counting func_tests/), it could match. :)

>
> Neil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
