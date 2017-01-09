From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 09 Jan 2017 13:30:07 +0000
Subject: question about "acpi, nfit: validate ars_status output buffer size"
Message-Id: <20170109133007.GA952@elgon.mountain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Dan,

It's really hard to understand commit 82aa37cf0986 ("acpi, nfit:
validate ars_status output buffer size") from Dec 6, 2016.

drivers/acpi/nfit/core.c
   139                  /* No ARS performed for the current boot */
   140                  if (status = NFIT_ARS_STATUS_NONE)
   141                          return -EAGAIN;
   142  
   143                  /*
   144                   * ARS interrupted, either we overflowed or some other
   145                   * agent wants the scan to stop.  If we didn't overflow
   146                   * then just continue with the returned results.
   147                   */
   148                  if (status = NFIT_ARS_STATUS_INTR) {
   149                          if (ars_status->out_length >= 40 && (ars_status->flags
   150                                                  & NFIT_ARS_F_OVERFLOW))

When I read the commit message, it implies that we're being more strict
about what we process but actually this is && instead of || so we're
being less strict.

The commit message doesn't really describe the user visible effects of
this bug.  I'm not an expert on ACPI and I have grepped the source but
can't figure it out.

Also this isn't aligned the normal way.  It should be:

				if (ars_status->out_length >= 40 &&
				    (ars_status->flags & NFIT_ARS_F_OVERFLOW))

   151                                  return -ENOSPC;
   152                          return 0;
   153                  }

regards,
dan carpenter
