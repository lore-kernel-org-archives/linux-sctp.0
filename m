From: David Miller <davem@davemloft.net>
Date: Fri, 12 Nov 2010 02:59:17 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <20101111.185917.68135794.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1289529269.3090.207.camel@Dan>
	<20101111.184902.233699247.davem@davemloft.net>
	<1289530264.3090.212.camel@Dan>
In-Reply-To: <1289530264.3090.212.camel@Dan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: drosenberg-PiUznwcHFHrqlBn2x/YWAg@public.gmane.org
Cc: urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, socketcan-core-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, pekkas-UjJjq++bwZ7HOG6cAo2yLw@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hadi-jkUAjuhPggJWk0Htik3J/w@public.gmane.org, vladislav.yasevich-VXdhtT5mjnY@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, remi.denis-courmont-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, socketcan-fJ+pQTUTwRTk1uMJSBkQmQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Thu, 11 Nov 2010 21:51:04 -0500

> This has already been suggested, and I agree it is a much better
> approach.  If I take this approach, and find some suitable substitute
> for those cases where the socket inode is not available, will you
> consider these changes?

I will consider an approach where the keys reported allow object
tracking equally as the actual pointers allow for right now.

I've said that this is my criteria about 3 times now.

