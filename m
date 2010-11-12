From: David Miller <davem@davemloft.net>
Date: Fri, 12 Nov 2010 02:02:16 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <20101111.180216.116373967.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289524026.5167.68.camel@dan>
	<20101111.171024.242132239.davem@davemloft.net>
	<1289524801.5167.76.camel@dan>
In-Reply-To: <1289524801.5167.76.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: drosenberg-PiUznwcHFHrqlBn2x/YWAg@public.gmane.org
Cc: urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, socketcan-core-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, pekkas-UjJjq++bwZ7HOG6cAo2yLw@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hadi-jkUAjuhPggJWk0Htik3J/w@public.gmane.org, vladislav.yasevich-VXdhtT5mjnY@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, remi.denis-courmont-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, socketcan-fJ+pQTUTwRTk1uMJSBkQmQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Thu, 11 Nov 2010 20:20:01 -0500

> If not, then you have committed to leaving a permanent easy target for
> exploits.

In your opinion.
