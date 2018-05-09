From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 09 May 2018 03:16:33 +0000
Subject: [PATCH lksctp-tools 0/2] CI improvements
Message-Id: <cover.1525835560.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Small adjustments:
- make use of make -j when building
- enable test email notifications to the mailing list

The email notification to the list is a bit debatable, but I'd like to
enable it so we raise awareness of these tests, at least for now.

Marcelo Ricardo Leitner (2):
  travis: use parallel build
  travis: enable email notifications

 .travis.yml | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--
2.14.3

