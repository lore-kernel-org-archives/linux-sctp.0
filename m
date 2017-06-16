From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 16 Jun 2017 21:29:56 +0000
Subject: sctp-tests test suite now available!
Message-Id: <20170616212956.GE5799@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hello,

Xin Long and I are proud to announce sctp-tests[1], a test suite built
with the purpose of being a development test suite. That is, it is
supposed to assist development by having a large set of tests readily
available for a developer to help ensure that the proposed patches are
good to go.

The idea is to go adding more and more test cases as patches to linux
kernel or lksctp-tools are added and achieve large coverage within some
time.

Patches are of course welcomed. For now we are expecting github pull
requests for them and not posts on any mailing list. It should be okay,
though, to discuss it here on linux-sctp@.

Currently it supports using physical hosts or network namespaces for
testing and for netns it can do simple client-server or
client-router-server topology. For client-server, it can do libteam or
ipsec.

[2] is to give you an idea on how easy it is to write test cases with
sctp-tests. Only 42 lines were needed to do a test on
Client-Router-Server topology with varying PMTU on the fly! Yay!

More information on how to use it can be found on its README.

Thanks!

[1] https://github.com/sctp/sctp-tests
[2] https://github.com/sctp/sctp-tests/blob/master/testcase/regression/gsomtuchange/test.sh
