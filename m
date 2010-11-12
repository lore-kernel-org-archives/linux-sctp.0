From: David Miller <davem@davemloft.net>
Date: Fri, 12 Nov 2010 02:29:39 +0000
Subject: Re: [PATCH 4/10] Fix leaking of kernel heap addresses in net/
Message-Id: <20101111.182939.258124014.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2129857903-1289528127-cardhu_decombobulator_blackberry.rim.net-1506931048-@bda083.bisx.prod.on.blackberry>
In-Reply-To: <2129857903-1289528127-cardhu_decombobulator_blackberry.rim.net-1506931048--JnVBb1XAImjjL2gL5RxOEzYg3SYOavFBmZ6FRVpaDsI@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: drosenberg-PiUznwcHFHrqlBn2x/YWAg@public.gmane.org
Cc: urs.thuermann-l29pVbxQd1IUtdQbppsyvg@public.gmane.org, socketcan-core-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, pekkas-UjJjq++bwZ7HOG6cAo2yLw@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hadi-jkUAjuhPggJWk0Htik3J/w@public.gmane.org, vladislav.yasevich-VXdhtT5mjnY@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, remi.denis-courmont-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, socketcan-fJ+pQTUTwRTk1uMJSBkQmQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org

From: "Dan Rosenberg" <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 02:15:25 +0000

> I am willing to do whatever is necessary to make these changes
> acceptable.  Are you completely set on not removing these addresses
> from the output?

I want whatever you replace it with to be equivalent for
object tracking purposes.
