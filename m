From: "Horacio Sanson" <hsanson@gmail.com>
Date: Thu, 24 Apr 2008 01:20:24 +0000
Subject: Re: Latest lksctp-dev tree broke sctp_sendmsg()?
Message-Id: <6156dd8b0804231820u54684675k269b225933dedc22@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
In-Reply-To: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Wed, Apr 23, 2008 at 12:00 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> Horacio Sanson wrote:
>
>
> > I am using the lksctp-dev kernel and the lksctp-tools both up to date
> > from git repository. I also checked that the only libsctp library I
> > have is the one from git and made sure to load the sctp kernel
> > modules.
> >
> > I must mention that this program worked fine before with kernel
> > 2.6.25-rc3 but after a recent update of lksctp-dev to 2.6.25-rc8  a
> > few days ago it started failing.....
> >
> > For now I will keep working with the 2.6.22 kernel.
> >
> >
>
>  would you be able to do a bisect?
>
>  # git-bisect start # git-bisect bad
>  # git-bisect good v2.6.24-rc3
>

Sorry I completely removed the git repository tree and did a new
clone. Now everything is working fine with the latest kernel
2.6.25-rc8.

thanks for the help
Horacio

>
>  I'd do it if I could reproduce the problem.
>
>  Thanks
>  -vlad
>
