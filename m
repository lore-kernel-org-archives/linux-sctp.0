From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 19 Oct 2012 23:58:19 +0000
Subject: Fw: [Bug 49131] New: sctp related kernel panic
Message-Id: <20121019165819.448bc8e4@nehalam.linuxnetplumber.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org



Begin forwarded message:

Date: Fri, 19 Oct 2012 22:22:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: shemminger@linux-foundation.org
Subject: [Bug 49131] New: sctp related kernel panic


https://bugzilla.kernel.org/show_bug.cgi?idI131

           Summary: sctp related kernel panic
           Product: Networking
           Version: 2.5
    Kernel Version: 3.7-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: shemminger@linux-foundation.org
        ReportedBy: ast@domdv.de
        Regression: No


Created an attachment (id=84061)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=84061)
Panic Log

The 3.7-rc1 kernel panics when sctp is used. See attached log collected from
/dev/pstore.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.
