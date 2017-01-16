From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 16 Jan 2017 18:47:32 +0000
Subject: Re: Problem on SCTP
Message-Id: <20170116184732.GH3781@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+C9Wf0Xgq0n-cw+ffeq-maDWoP=6dUV0c=zt80ugZLJQ@mail.gmail.com>
 <20170110143351.GA10195@hmswarspite.think-freely.org>
 <CAFXGft+XA_r+R2hxJU2qYvFJbS+avQ7TTOQ50xkTXm8q8KpDtg@mail.gmail.com>
 <20170111125708.GA1518@hmswarspite.think-freely.org>
 <CAFXGftLSFgPpxD6Oak8h1Y5y11-zXWLj0v4ziMFkjX8eZ4ZJgA@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6DB025F9FD@AcuExch.aculab.com>
 <4163FC71-3A20-4484-8CDC-FA22D4FA72CF@lurchi.franken.de>
 <CAFXGftJe=ooG8sQR+NmMcVMNthvu6qtaH9YBPBFJMM+Ax-4UOA@mail.gmail.com>
 <CAFXGftLn8Kc9svJJRRmUiHxN_5_O0se2srw996BbPSVTbDP0fA@mail.gmail.com>
 <15C09FCB-B635-4144-84FA-E699A9C684CA@lurchi.franken.de>
In-Reply-To: <15C09FCB-B635-4144-84FA-E699A9C684CA@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sun Paul <paulrbk@gmail.com>
Cc: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>, David Laight <David.Laight@aculab.com>, Neil Horman <nhorman@tuxdriver.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Jan 13, 2017 at 10:43:39AM +0100, Michael Tuexen wrote:
> Your router does NOT change any field in the SCTP packet, but the 
> SCTP checksum was modified from
>    Checksum: 0xbaea49e5 (not verified)
> to
>    Checksum: 0xa9a86d3f (not verified)

Sun, which operating system is your router running?

  Marcelo

