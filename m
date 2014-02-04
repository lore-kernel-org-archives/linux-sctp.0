From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 04 Feb 2014 12:20:42 +0000
Subject: Re: Is there any performance impact, if we tune kernel SCTP (/proc/sys/net/sctp/sack_timeout) parame
Message-Id: <20140204122042.GA30585@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <abcd1234abc123ab12a0000031211000020000005003@gmail.com>
In-Reply-To: <abcd1234abc123ab12a0000031211000020000005003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Feb 04, 2014 at 07:09:23AM +0000, Norah Jones wrote:
> Hi, 
> 
> Can we set the same to 0? If so, how??
> 
> Thanks,
> Norah Jones
> 
Policy on that sysctl won't let you set the sack timeout below 1, as a timeout
of 0 jiffys is nonsense, and would cause the sack timer to run near constantly.
Neil

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
