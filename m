From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Mar 2013 15:48:04 +0000
Subject: Re: NULL primary_path
Message-Id: <5138B6B4.9090900@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
In-Reply-To: <CAGugRbVkLt2AzKkxX3SzJhjDfyPJpviD64_Y5-hgtqxSTwzQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 03/06/2013 08:53 PM, Vlad Yasevich wrote:
> On 03/06/2013 05:57 PM, Karl Heiss wrote:
>> I am getting kernel panics due to a NULL dereference in
>> sctp_getsockopt_sctp_status() when calling getsockopt() with
>> SCTP_STATUS immediately after establishing a connection.  This occurs
>> when transport = asoc->peer.primary_path; is NULL and transport is
>> later dereferenced.  Is there any way that an association would be
>> present but have no primary_path?
>
> No, that shouldn't happen.  The very first transport that is added
> to the association is assigned to the primary_path.  Primary_path can
> never be null since the association must have at least 1 transport and
> that 1 transport will always be primary.
>
> Is this happening on the server or the client side?
>
> Which kernel version?
>
> Is Add-IP on and are there any Add-IP options in the packets?

Also, are you using SOCK_STREAM or SOCK_SEQPACKET sockets?

Thanks
-vlad

>
> Thanks
> -vlad
>
>>  Should
>> sctp_getsockopt_sctp_status() be checking asoc->peer.primary_path and
>> returning -EINVAL?
>>
>> Karl
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

