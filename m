From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 17 Mar 2014 11:31:51 +0000
Subject: Re: How to set SACK_DELAY?
Message-Id: <20140317113151.GB29358@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+GqCxyOCV7w2ykQAcJonyB6geYXjV=7oytX7h0-aFBow@mail.gmail.com>
In-Reply-To: <CAFXGft+GqCxyOCV7w2ykQAcJonyB6geYXjV=7oytX7h0-aFBow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Mar 17, 2014 at 05:53:35PM +0800, Sun Paul wrote:
> Hi I am using CentOS 6.5, how I can set the SCTP SACK DELAY in SYSCTL.CONF?
> 
net.sctp.sack_timeout = <value>

> Thanks
> 
> - RBK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
