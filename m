From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Mar 2013 17:17:18 +0000
Subject: Re: NULL primary_path
Message-Id: <5138CB9E.6070306@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 03/07/2013 12:06 PM, Karl Heiss wrote:
> The issue appears to manifest itself when the connection is closed
> from the remote end and getsockopt(SCTP_STATUS) is called within a
> small window in which the association is still valid but
> asoc->peer.primary_path is NULL.

Aha!  Thanks.  There was a bug in the rcu clean-up that allowed the=20
association to remain while all transports have been removed.

Here is a patch that should have addressed this condition:

commit 8c98653f05534acd1cb07ea4929702a3659177d1
Author: Daniel Borkmann <dborkman@redhat.com>
Date:   Fri Feb 1 04:37:43 2013 +0000

     sctp: sctp_close: fix release of bindings for deferred call_rcu's

Full patch is here:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=8C98653f05534acd1cb07ea4929702a3659177d1

Make sure that you have this patch in the kernel you are running

-vlad

>
> On Thu, Mar 7, 2013 at 10:48 AM, Vlad Yasevich <vyasevich@gmail.com> wrot=
e:
>> On 03/06/2013 08:53 PM, Vlad Yasevich wrote:
>>>
>>> On 03/06/2013 05:57 PM, Karl Heiss wrote:
>>>>
>>>> I am getting kernel panics due to a NULL dereference in
>>>> sctp_getsockopt_sctp_status() when calling getsockopt() with
>>>> SCTP_STATUS immediately after establishing a connection.  This occurs
>>>> when transport =3D asoc->peer.primary_path; is NULL and transport is
>>>> later dereferenced.  Is there any way that an association would be
>>>> present but have no primary_path?
>>>
>>>
>>> No, that shouldn't happen.  The very first transport that is added
>>> to the association is assigned to the primary_path.  Primary_path can
>>> never be null since the association must have at least 1 transport and
>>> that 1 transport will always be primary.
>>>
>>> Is this happening on the server or the client side?
>>>
>>> Which kernel version?
>>>
>>> Is Add-IP on and are there any Add-IP options in the packets?
>>
>>
>> Also, are you using SOCK_STREAM or SOCK_SEQPACKET sockets?
>>
>> Thanks
>> -vlad
>>
>>
>>>
>>> Thanks
>>> -vlad
>>>
>>>>   Should
>>>> sctp_getsockopt_sctp_status() be checking asoc->peer.primary_path and
>>>> returning -EINVAL?
>>>>
>>>> Karl
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" =
in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>

