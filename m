From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 03 Dec 2019 16:22:33 +0000
Subject: Fw: [Bug 205753] New: Incorrect SCTP DATA dispatching
Message-Id: <20191203082233.5c1525be@hermes.lan>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

All networking bugzilla bugs go to me. This one is new and  SCTP related

Begin forwarded message:

Date: Tue, 03 Dec 2019 13:32:39 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205753] New: Incorrect SCTP DATA dispatching


https://bugzilla.kernel.org/show_bug.cgi?id 5753

            Bug ID: 205753
           Summary: Incorrect SCTP DATA dispatching
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.67
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: evgenij.fokin@gmail.com
        Regression: No

I think that root cause in skipped messages.

For example, frame 56 in your debian10_sctp_test_to_sctp_test.pcapng shows that
the data message with sctp.data_tsn = 919935042 was received on server
interface but it was acked in frame 78 only.

It happens periodically with high-load traffic. The server can capture DATA on
network interface but SCTP level does not receive it.

-- 
You are receiving this mail because:
You are the assignee for the bug.
