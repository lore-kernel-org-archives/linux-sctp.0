From: Karl Heiss <kheiss@gmail.com>
Date: Wed, 06 Mar 2013 22:57:40 +0000
Subject: NULL primary_path
Message-Id: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

I am getting kernel panics due to a NULL dereference in
sctp_getsockopt_sctp_status() when calling getsockopt() with
SCTP_STATUS immediately after establishing a connection.  This occurs
when transport = asoc->peer.primary_path; is NULL and transport is
later dereferenced.  Is there any way that an association would be
present but have no primary_path?  Should
sctp_getsockopt_sctp_status() be checking asoc->peer.primary_path and
returning -EINVAL?

Karl
