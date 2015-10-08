From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu, 08 Oct 2015 14:06:59 +0000
Subject: Re: alignment issue using sctp_assoc_stats via getsockopt
Message-Id: <56167883.90005@iogearbox.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAJzSi+fw7uNkK+ZE227kg2sK6_xZ0crVYDDyJkUR6DfdvsfgcQ@mail.gmail.com>
In-Reply-To: <CAJzSi+fw7uNkK+ZE227kg2sK6_xZ0crVYDDyJkUR6DfdvsfgcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 10/08/2015 03:45 PM, Neil Horman wrote:
> On Thu, Oct 08, 2015 at 08:26:56AM -0300, Marcelo wrote:
>> Em 8 de outubro de 2015 08:11:40 BRT, Neil Horman <nhorman@tuxdriver.com> escreveu:
>>> On Wed, Oct 07, 2015 at 06:11:55PM -0300, Marcelo Ricardo Leitner
>>> wrote:
>>>> Hi Jakub,
>>>>
>>>> On Tue, Oct 06, 2015 at 01:04:43PM +0200, Jakub Tomalak wrote:
>>>>> Greetings,
>>>>>
>>>>> I have discovered an alignment issue when using SCTP in a 32-bit
>>>>> binary on a 64-bit host.
>>>>>
>>>>> Essentially, the problem is that struct sctp_assoc_stats contains a
>>>>> sockaddr_storage field and is at a different offset for 32-bit and
>>>>> 64-bit architectures (well, Intel/AMD anyway).
>>>>>
>>>>> Essentially when a 32-bit binary makes a getsockopt call with
>>>>> sctp_assoc_stats againts a 64-bit kernel, the kernel copies the
>>> data
>>>>> in with a different alignment, causing the 32-bit binary to receive
>>>>> incorrect data for all of the chunk counters (fields after the
>>>>> sockaddr field)..
>>>>>
>>>>> The fix is relatively simple for i386 and x86_64 architectures. I
>>> am
>>>>> not sure about MIPS64 and ARM, since a colleague mentioned they do
>>> not
>>>>> support unaligned memory access and also mentioned that MIPS64
>>> doesn't
>>>>> allow alignment with word sizes smaller than 8 bytes.
>>>>>
>>>>> Here is the diff I tested against both 32-bit and 64-bit RHEL and
>>>>> Ubuntu systems (with kernels ranging from 3.12.x to 3.16.y).
>>>>>
>>>>> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
>>>>> index ce70fe6..41aa566 100644
>>>>> --- a/include/uapi/linux/sctp.h
>>>>> +++ b/include/uapi/linux/sctp.h
>>>>> @@ -873,7 +873,7 @@ struct sctp_assoc_stats {
>>>>>          __u64           sas_iodchunks;   /* Ordered data chunks
>>> received */
>>>>>          __u64           sas_octrlchunks; /* Control chunks sent */
>>>>>          __u64           sas_ictrlchunks; /* Control chunks received
>>> */
>>>>> -};
>>>>> +} __attribute__((packed, aligned(4)));
>>>>>
>>>>> /*
>>>>>    * 8.1 sctp_bindx()
>>>>> @@ -900,6 +900,6 @@ struct sctp_paddrthlds {
>>>>>          struct sockaddr_storage spt_address;
>>>>>          __u16 spt_pathmaxrxt;
>>>>>          __u16 spt_pathpfthld;
>>>>> -};
>>>>> +} __attribute__((packed, aligned(4)));
>>>>>
>>>>> #endif /* _UAPI_SCTP_H */
>>>>>
>>>>> I have no idea what the official process is for submitting patches
>>> to
>>>>> the SCTP module, and since this is probably a very edge case
>>> scenario,
>>>>> I thought I would at least mention it in case anyone else comes
>>> across
>>>>> similar problems.
>>>>
>>>> We can say that it starts by sharing your thoughts like you did. And
>>>> when you are confident with a patch, you can submit it to netdev@
>>>> directly while keeping this ML Cc'ed. Dave Miller is the one who
>>>> integrates sctp patches.
>>>>
>>>> Now about your patch. I think it's just too late to fix that.  That
>>>> issue is exposed to user-space for too long so that I'm afraid it has
>>>> already become a "feature". If we fix that, it will break
>>> applications
>>>> that are handling that in some other way.
>>>>
>>>>    Marcelo
>>>>
>>>> --
>>> For the life of me I can't recall how to do this, but can we add a
>>> thunk layer
>>> to the syscall to detect the arch of the calling process and fix up the
>>> alignment while inside the syscall, and translate back in the epiloge?
>>>
>>> Neil
>>
>> Add this to lksctp-tools you mean?
>>
>
> No, to the kernel.  IIRC in the early days of x86_64, lots of syscalls had
> problem like this, where 32 bit user space and 64 bit kernels didn't agree on
> word sizes and alignment, so there was a thunk layer that detected that
> condition, made a copy of the user passed data, fixed the alignment, and gave
> that to the real syscall in the kernel, then reversed the process before
> returning to user space.  It was horrid and messy, but it seems like we could do
> something simmilar here

But for such things we have the compat infrastructure in the kernel, f.e.
see ffd5939381c6 ("net: sctp: fix sctp_connectx abi for ia32 emulation/compat
mode"). So, I think something similar for the getsockopt() might be required.

Cheers,
Daniel
