From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 29 Jun 2019 14:25:10 +0000
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
Message-Id: <20190629142510.GA10629@avx2>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
In-Reply-To: <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@dilger.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shyam Saini <shyam.saini@amarulasolutions.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, keescook@chromium.org, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, devel@lists.orangefs.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, mayhs11saini@gmail.com

On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:

> I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> is about 30x, and SIZEOF_FIELD() is only about 5x.
> 
> That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> which it is closely related, but is also closer to the original "sizeof()".
> 
> Since this is a rather trivial change, it can be split into a number of
> patches to get approval/landing via subsystem maintainers, and there is no
> huge urgency to remove the original macros until the users are gone.  It
> would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> whittled away as the patches come through the maintainer trees.

The signature should be

	sizeof_member(T, m)

it is proper English,
it is lowercase, so is easier to type,
it uses standard term (member, not field),
it blends in with standard "sizeof" operator,
