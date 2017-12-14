From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 14 Dec 2017 10:40:59 +0000
Subject: Re: How to restrict SCTP abort during a process crash
Message-Id: <20171214104059.GA30889@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
In-Reply-To: <CAOTBYLYCFVt0hHf5_pJQCEPsh9vSNXR3V7b0SaVycJ4-KZja0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Thu, Dec 14, 2017 at 12:00:42PM +0530, Ashok Kumar wrote:
> Neil / Xin,
> 
> The best way is to change the LKSTCP kernel code to handle this
> situation and stop sending SCTP abort message?
> 
> Can you please give guidance on where to change the code?
> 
> Thanks,
> Ashok
> 

while Xin's code will have the desired effect, that is absolutely the wrong
thing to do, as you don't want to suppress abort messages, you want to suppress
them in the event that a process needs to be migrated to your backup system.

If you're going to hack up your system like that, I'd suggest two things:

1) Use a systemtap script, or a kprobe module to hook into the code in question,
that way you can keep your custom changes isolated.

2) Gate the setting of chunk to NULL on the presence of SIGKILL or SIGSEGV in
the pending signals set of the task you are working on.

Neil

