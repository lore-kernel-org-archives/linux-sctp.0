From: Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 02 Apr 2012 13:24:23 +0000
Subject: question about net/sctp/socket.c
Message-Id: <alpine.DEB.2.02.1204021521460.1959@hadrien>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In the file net/sctp/socket.c, the function sctp_getsockopt_peeloff ends 
with:

        retval = sock_map_fd(newsock, 0);
         if (retval < 0) {
                 sock_release(newsock);
                 goto out;
         }

         SCTP_DEBUG_PRINTK("%s: sk: %p newsk: %p sd: %d\n",
                           __func__, sk, newsock->sk, retval);

         /* Return the fd mapped to the new socket.  */
         peeloff.sd = retval;
         if (put_user(len, optlen))
                 return -EFAULT;
         if (copy_to_user(optval, &peeloff, len))
                 retval = -EFAULT;

Should there be a call to sock_release in the final two error cases as 
well?  I don't see anything that removes the need for it.  And is some 
cleanup of the effect of sock_map_fd needed as well?

thanks,
julia
