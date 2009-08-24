From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 24 Aug 2009 16:26:10 +0000
Subject: [PATCH 0/2] Re: Do piggybacked ACKs work
Message-Id: <1251131172-20602-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Try to wrap up the discussion and all the patches that
happened in this tread, I'd like to send out what I've come
up with.  It's really a merge of all the points
we've discussed (minus the Nagel/small fragment discussion).

What we try to do in the first patch is bundle the SACK
if we are going to send the DATA, regardless of if the SACK
will fit in the same packet or not.

The second patch in the series, will size the DATA chunks
to account for possbile SACKs.  This will encourage bundling.

The last piece of the puzzle is what to do with the small message
fragements.  Wei's approach doesn't work in the face of small
messages that the user decides to fragment as well (think, 400
byte message with a frag_size of 50).  I think we need to
take message size into account in this situation.

Anyway, please feel free to comment on this approach.

-vlad

