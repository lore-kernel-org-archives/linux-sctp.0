From: Paul Moore <paul@paul-moore.com>
Date: Wed, 21 Feb 2018 20:45:43 +0000
Subject: Re: [PATCH V7 2/4] sctp: Add ip option support
Message-Id: <161ba1d60d8.2781.85c95baa4474aabc7814e68940a78392@paul-moore.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180220191527.14307-1-richard_c_haines@btinternet.com>
	<20180221143345.GA3888@localhost.localdomain>
In-Reply-To: <20180221143345.GA3888@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

On February 21, 2018 9:33:51 AM Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Tue, Feb 20, 2018 at 07:15:27PM +0000, Richard Haines wrote:
>> Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
>> and CALIPSO/IPv6 services.
>> 
>> Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
>
> LGTM too, thanks!
>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

I agree, thanks everyone for all the work, review, and patience behind this patchset!  I'll work on merging this into selinux/next and I'll send a note when it's done.

--
paul moore
www.paul-moore.com


