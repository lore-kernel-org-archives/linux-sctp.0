From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 28 Jul 2018 22:31:19 +0000
Subject: [PATCH 0/4] Improve travis-ci integration
Message-Id: <cover.1532816583.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

As now we probe for some kernel features, it is important that we try to
build the library against different kernel headers. 
That's what the first patch does.

patch 2 and 3 seize the moment to build using different
compilers/versions and patch 4 minimize emails by only sending build
fail/success if it changes.

Build status can be seen at https://www.travis-ci.org/sctp/lksctp-tools

Marcelo Ricardo Leitner (4):
  travis: build against multiple kernel versions
  travis: build against multiple gcc versions
  travis: build against multiple clang versions
  travis: only send notifications if build status changed

 .travis.yml            | 110 ++++++++++++++++++++++++++++++++++++++---
 .travis/linux-build.sh |  43 ++++++++++++++++
 2 files changed, 147 insertions(+), 6 deletions(-)
 create mode 100755 .travis/linux-build.sh

-- 
2.17.1

