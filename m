From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 28 Aug 2014 13:12:31 +0000
Subject: Re: uapi header mismatch with kernel ?
Message-Id: <53FF2ABF.30907@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CA+sbV4gaHaEskjKiAZOGUXAr5zjbCF7F70KC01y9xgOb8KcPng@mail.gmail.com>
In-Reply-To: <CA+sbV4gaHaEskjKiAZOGUXAr5zjbCF7F70KC01y9xgOb8KcPng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On 08/28/2014 03:05 PM, Tristan Su wrote:
> On Thu, Aug 28, 2014 at 3:47 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> On 08/28/2014 09:34 AM, Daniel Borkmann wrote:
>>>
>>> On 08/28/2014 08:33 AM, 苏庆 wrote:
>>>>
>>>> Hi all,
>>>>
>>>> I found that In 3.x kernel, the sctp states are defined differently
>>>> between kernel and uapi header. This makes our application fails to
>>>> work.
>>>>
>>>> Is that a mismatch or am I missing something?
>>>
>>>
>>> You are correct, and that's not good ... can you try out the below
>>> kernel patch?
>
> Thank you for the confirmation.
> I'm not kernel developer and have no experience on kernel patching/compiling
> but the fix looks straightforwards to me.
>
> It seems that the issue exists in mainline kernel and also distributions
>   like RHEL7, Ubuntu 14.04, etc. Applications that care SCTP_STATUS
>   would be impacted and it would not help even to recompile the application.

I'm currently verifying it myself and will send out a patch ASAP. It will
then go to stable afterwards on the next pull request from Dave to Linus.

> BTW, any idea on how long it would take for the fix to be delivered by
> distributions like RHEL?
>
> Should I report this to bugzilla.kernel.org or to linux distributions?

They will include it when it gets delivered via stable kernels.
