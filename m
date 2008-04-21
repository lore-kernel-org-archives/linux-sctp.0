From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Apr 2008 14:41:28 +0000
Subject: Re: Latest lksctp-dev tree broke sctp_sendmsg()?
Message-Id: <480CA798.30001@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
In-Reply-To: <6156dd8b0804210231m4e0a5549v6f9890978d355387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

David Pascoe wrote:
> Is there some way to ask a running linux kernel which version of
> lksctp-tools it needs ?

No,  there currently isn't any version information in lksctp.
I've checked the tools history and there is nothing there that changed.

The older libraries should still work on the newer kernels

Let me take a look and see why there is an error.

-vlad

> 
> On 4/21/08, Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Mon, Apr 21, 2008 at 06:31:57PM +0900, Horacio Sanson wrote:
>>  > I have a small echo server/client program for testing. It works in
>>  > linux kernel 2.6.22-14 (Ubuntu) but using the latest lksctp-dev tree
>>  > (from git) I get "invalid parameter" errors when calling
>>  > sctp_sendmsg().
>>  >
>>  > Any directions are appreciated:
>>  >
>>  > Horacio
>>
> 

