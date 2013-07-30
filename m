From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 30 Jul 2013 13:06:44 +0000
Subject: Re: Association issue.
Message-Id: <20130730130644.GA27793@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
In-Reply-To: <CAAwSLG+fNrUKrfd1dBshHvsSUOpsEASBtwXb2iZF+uQ+uM8kxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Jul 30, 2013 at 04:52:52PM +0530, Vipul Singhania wrote:
> Hi All,
> 
> 
> I have one test case in which I have 2 interfaces on each machine (two hosts).
> 
> One is working as server and one is as client.
> 
> If in server I make one interface as public (IP address 164.x.x.x)
> then the server sends reset to the client).
> 
> So question is does SCTP support association between public to private
> range IP address?
> 
Sort of, SCTP will gladly use any available ip address in the establishment of an
association.  That said, you do need to take care that your firewalls aren't
going to mess with those addresses. That is to say, if you have an address that
is 'private' in the sense that it is behind a nat firewall, you will likely get
a reset from the use of that address, because the peer will see connections from
that address as comming from the public natted address, which was not in the
association init chunk, hence the abort.
Neil

> 
> Thanks in advance.
> -- 
> -=vipsy
> http://through-dlens.blogspot.in
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
