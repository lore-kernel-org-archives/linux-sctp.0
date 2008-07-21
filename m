From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Jul 2008 13:12:21 +0000
Subject: Re: [PATC] sctp: various fixes
Message-Id: <48848B35.6050702@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <12164416121552-git-send-email-vladislav.yasevich@hp.com>	<20080718.230833.22196996.davem@davemloft.net> <20080719.224047.228019059.davem@davemloft.net>
In-Reply-To: <20080719.224047.228019059.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 18 Jul 2008 23:08:33 -0700 (PDT)
> 
>> From: Vlad Yasevich <vladislav.yasevich@hp.com>
>> Date: Sat, 19 Jul 2008 00:26:45 -0400
>>
>>> This is a bunch of SCTP fixes that have accumlated over the past week or
>>> so. 
>> All applied, thanks Vlad.
> 
> Vlad, I had to add the following fix to the tree in order
> to unbreak the build when CONFIG_HIGHMEM is enabled.
> 

ahh...  since tcp isn't a module, it didn't trigger that.

Thanks Dave.  I didn't think about turning highmem off..

-vlad

> highmem: Export totalhigh_pages.
> 
> Hash et al. sizing code in SCTP wants to make the
> calculation totalram_pages - totalhigh_pages, just
> like TCP.  But this requires an export for the
> CONFIG_HIGHMEM case to work.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index 7da4a7b..e16e152 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -40,6 +40,7 @@
>  #ifdef CONFIG_HIGHMEM
>  
>  unsigned long totalhigh_pages __read_mostly;
> +EXPORT_SYMBOL(totalhigh_pages);
>  
>  unsigned int nr_free_highpages (void)
>  {
> 

