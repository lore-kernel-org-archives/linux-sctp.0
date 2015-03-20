From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 20 Mar 2015 11:49:04 +0000
Subject: Re: modprobe sctp error
Message-Id: <20150320114904.GA19548@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAyB5cLYfj24-+fGiZtGWa3Ae=c2=xpz2=3Ok3s=iMGxu5Abcw@mail.gmail.com>
In-Reply-To: <CAAyB5cLYfj24-+fGiZtGWa3Ae=c2=xpz2=3Ok3s=iMGxu5Abcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Mar 19, 2015 at 07:15:28PM -0700, Jerry Jerry wrote:
> Hello everyone,
> 
> We had another problem today, where modprobe shows an error in
> /var/log/message when we ran an sctp application:
> 
> modprobe: FATAL: Error inserting sctp
> (/lib/modules/2.6.32.12-0.7-default/kernel/net/sctp/sctp.ko): Invalid
> argument
> 
> I'm wondering what might be possible causes of this and how should we
> bypass this.... Appreciate any comments and suggestions.
> 
> Regards,
> Jerry
EINVAL is returned by mod_sysfs_setup.  Ostensibly its because you either
specified a module option that doesn't exist, or because the module is already
loaded.  There could be other reasons, but those are the ones that pop
immediately to mind.

Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
