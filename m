From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 22 Aug 2013 12:57:08 +0000
Subject: Re: mulithoming sample
Message-Id: <20130822125708.GA16781@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGXs5wVmt=MsfG5H0_yFXLt_swtDFB8CkcfT7Tv=BzwFDpxZtg@mail.gmail.com>
In-Reply-To: <CAGXs5wVmt=MsfG5H0_yFXLt_swtDFB8CkcfT7Tv=BzwFDpxZtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Aug 22, 2013 at 02:17:10PM +0300, Kevin Wilson wrote:
> Hello,
> Is there some simple  mulithoming sample available?
> I found  SCP multistreaming sample, but not  mulithoming.
> 
I don't know about a specific example, but the sctp_darn utility will do it
automatically if you just use two hosts with multiple ip addresses that are all
reachable from one another.  Just specify all the addresses you want to listen
on with the -B option and all the addresses you want to connect to with the -c
option.
Neil

> regards,
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
