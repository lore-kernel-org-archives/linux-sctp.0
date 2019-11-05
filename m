From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 05 Nov 2019 21:45:11 +0000
Subject: Re: Fw: [Bug 205439] New: SCTP responds to heartbeat from the wrong address / interface
Message-Id: <20191105214511.GB27571@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191105073925.58ff6518@hermes.lan>
In-Reply-To: <20191105073925.58ff6518@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On Tue, Nov 05, 2019 at 07:39:25AM -0800, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Tue, 05 Nov 2019 11:59:05 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 205439] New: SCTP responds to heartbeat from the wrong address / interface
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id 5439
> 
>             Bug ID: 205439
>            Summary: SCTP responds to heartbeat from the wrong address /
>                     interface
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 4.9.35-server
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: paul@afk.ro
>         Regression: No
> 
> Seems that SCTP responds to heartbeat from the wrong address / interface.
> 
> # netstat -nS | fgrep 162.93.39.
> sctp       0      0 81.226.10.66:3561     162.93.39.198:3561      ESTABLISHED
>                     81.226.10.70          162.93.39.194
> sctp       0      0 81.226.10.66:3560     162.93.39.134:3560      ESTABLISHED
>                     81.226.10.70          162.93.39.130
> 
> Bad:
>     3   0.055267 162.93.39.130 → 185.226.110.70 SCTP 74 HEARTBEAT
>     4   0.055291 81.226.10.66 → 162.93.39.130 SCTP 74 HEARTBEAT_ACK
>     7   0.355746 162.93.39.194 → 185.226.110.70 SCTP 74 HEARTBEAT
>     8   0.355758 81.226.10.66 → 162.93.39.194 SCTP 74 HEARTBEAT_ACK
> 
> Good:
>    13   0.551876 162.93.39.134 → 81.226.10.66 SCTP 74 HEARTBEAT
>    14   0.551906 81.226.10.66 → 162.93.39.134 SCTP 74 HEARTBEAT_ACK
>    19   0.853376 162.93.39.198 → 81.226.10.66 SCTP 74 HEARTBEAT
>    20   0.853388 81.226.10.66 → 162.93.39.198 SCTP 74 HEARTBEAT_ACK
> 
> 
> This is multi-homed scenario of SCTP.
> 
> Regards,
> 
According to the RFC:
https://tools.ietf.org/html/rfc4960#page-38
In section 3.3.6, theres no guarantee that a HEARTBEAT_ACK will be sent
from the same address that the HEARTBEAT chunk was received on, only
that it will be sent back to the same address that generated the
HEARTBEAT, which both cases above are doing.

If you want to guarantee source address selection in addition to the
destination address guarantee, I think you need to set up your routing
tables such that the source address to the given destination is
specified.

We could probably change that to guarantee source address selection, but
I'm not sure thats a universally desired feature.

Best
Neil

> -- 
> You are receiving this mail because:
> You are the assignee for the bug.
> 
