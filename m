From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 22 May 2020 14:36:23 +0000
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-Id: <20200522143623.GA386664@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
In-Reply-To: <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Fri, May 22, 2020 at 08:02:09AM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 21 May 2020 18:47
> > based on the review of Davids patch to do something similar I dusted off
> > the series I had started a few days ago to move the memdup_user or
> > copy_from_user from the inidividual sockopts into sctp_setsockopt,
> > which is done with one patch per option, so it might suit Marcelo's
> > taste a bit better.  I did not start any work on getsockopt.
> 
> I'm not sure that 49 patches is actually any easier to review.
> Most of the patches are just repetitions of the same change.
> If they were in different files it might be different.

It's subjective, yes, but we hardly have patches over 5k lines.
In the case here, as changing the functions also requires changing
their call later on the file, it helps to be able to check that is was
properly updated. Ditto for chained functions.

For example, I can spot things like this easier (from
[PATCH 26/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_key)

@@ -3646,7 +3641,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
        }

 out:
-       kzfree(authkey);
        return ret;
 }
...
@@ -4771,7 +4765,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
        }

        release_sock(sk);
-       kfree(kopt);
+       if (optname = SCTP_AUTH_KEY)
+               kzfree(kopt);
+       else
+               kfree(kopt);

 out_nounlock:
        return retval;

these are 1k lines apart.

Yet, your implementation around this is better:

@@ -3733,7 +3624,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
        }

 out:
-       kzfree(authkey);
+       memset(authkey, 0, optlen);
        return ret;
 }

so that sctp_setsockopt() doesn't have to handle it specially.

What if you two work on a joint patchset for this? The proposals are
quite close. The differences around the setsockopt handling are
minimal already. It is basically variable naming, indentation and one
or another small change like:

From Christoph's to David's:
@@ -2249,11 +2248,11 @@ static int sctp_setsockopt_autoclose(struct sock *sk, u32 *autoclose,
                return -EOPNOTSUPP;
        if (optlen != sizeof(int))
                return -EINVAL;
-
-       if (*autoclose > net->sctp.max_autoclose)
+
+       sp->autoclose = *optval;
+
+       if (sp->autoclose > net->sctp.max_autoclose)
                sp->autoclose = net->sctp.max_autoclose;
-       else
-               sp->autoclose = *autoclose;

        return 0;
 }

> 
> If you try to do getsockopt() the same way it will be much
> more complicated - you have to know whether the called function
> did the copy_to_user() and then suppress it.

If it is not possible, then the setsockopt one already splited half of
the lines of the patch. :-)
