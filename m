From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 24 Feb 2018 00:56:00 +0000
Subject: Re: [PATCH V7 2/4] sctp: Add ip option support
Message-Id: <20180224005600.GG4375@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180220191527.14307-1-richard_c_haines@btinternet.com>
	<20180221143345.GA3888@localhost.localdomain>
	<161ba1d60d8.2781.85c95baa4474aabc7814e68940a78392@paul-moore.com>
	<CAHC9VhSnPku5SYnNkyUqvi46OpzPZKbJf+fxeCR0y3ym0zcMYA@mail.gmail.com>
	<20180223024010.GE4375@localhost.localdomain>
	<CAHC9VhT_1GQJPoOBN0ambF=F1+ZXhoYB3mMc8kzgCFOep+hsCg@mail.gmail.com>
In-Reply-To: <CAHC9VhT_1GQJPoOBN0ambF=F1+ZXhoYB3mMc8kzgCFOep+hsCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On Fri, Feb 23, 2018 at 11:11:50AM -0500, Paul Moore wrote:
> On Thu, Feb 22, 2018 at 9:40 PM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > On Thu, Feb 22, 2018 at 06:08:05PM -0500, Paul Moore wrote:
> >> On Wed, Feb 21, 2018 at 3:45 PM, Paul Moore <paul@paul-moore.com> wrote:
> >> > On February 21, 2018 9:33:51 AM Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> >> >> On Tue, Feb 20, 2018 at 07:15:27PM +0000, Richard Haines wrote:
> >> >>> Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
> >> >>> and CALIPSO/IPv6 services.
> >> >>>
> >> >>> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
> >> >>
> >> >> LGTM too, thanks!
> >> >>
> >> >> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> >> >
> >> > I agree, thanks everyone for all the work, review, and patience behind this patchset!  I'll work on merging this into selinux/next and I'll send a note when it's done.
> >>
> >> I just merged the four patches (1,3,4 from the v6 patchset, 2 from the
> >> v7 patchset) in selinux/next and did a quick sanity test on the kernel
> >> (booted, no basic SELinux regressions).  Additional testing help is
> >> always appreciated ...
> >
> > I'll try it early next week.
> >
> > Any ideas on when this is going to appear on Dave's net-next tree?
> > We have a lot of SCTP changes to be posted on this cycle and would be
> > nice if we could avoid merge conflicts.
> 
> It's merged into the SELinux tree, next branch; see the links below.
> Last I checked DaveM doesn't pull the selinux/next into his net-next
> tree (that would be a little funny for historical reasons).
> 
> Any idea on how bad the merge conflicts are?

I know about 5 patchsets that we are cooking. For 4 of them I think it
would be mostly fine, perhaps one conflict here and there. But the
other one is a refactoring on MTU handling and it touches lots of
places that 92c49e12646e4 ("sctp: Add ip option support") also
touched, like in the chunk below:

+++ b/include/net/sctp/sctp.h
@@ -441,9 +441,11 @@ static inline int sctp_list_single_entry(struct list_head *head)
 static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
 {
 	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
+	struct sctp_af *af = sp->pf->af;
 	int frag = pmtu;
 
-	frag -= sp->pf->af->net_header_len;
+	frag -= af->ip_options_len(asoc->base.sk);
+	frag -= af->net_header_len;

In the refactor I'm removing this function from here and adding a
similar, not quite the same but similar, in a .c file. 

I post the mtu patchset as RFC next week so we can know better.

  Marcelo

> 
> >> * git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> >> * https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git
> 
> -- 
> paul moore
> www.paul-moore.com
