From: Dong Liu <dliu.cn@gmail.com>
Date: Thu, 13 Mar 2014 17:53:55 +0000
Subject: Re: 1.0.16 sctp_connectx() in 32 bit
Message-Id: <5321F0B3.5020308@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5321185A.8050700@gmail.com>
In-Reply-To: <5321185A.8050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 3/13/14, 4:54 AM, Daniel Borkmann wrote:
> On 03/13/2014 03:30 AM, Dong Liu wrote:
>> Hi,
>>
>> I think I found a problem in the new sctp_connectx() code.
>>
>> in sctp_connectx3() there are,
>>
>>      struct sctp_getaddrs_old param;
>>      socklen_t opt_len =3D sizeof(param);
>>      status getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_CONNECTX3, &param,=20
>> &opt_len);
>>
>> And in kernel net/sctp/socket.c sctp_getsockopt_connectx3(), there is=20
>> a check,
>>
>>              if (len < sizeof(param)) |
>>                  return -EINVAL; |
>>
>> But struct sctp_getaddrs_old contains a pointer . When compiled in 32=20
>> bit or 64 bit,
> > the size of sctp_getaddrs_old is different. So if the kernel is in=20
> 64 bit mode but
> > the libsctp is in 32 bit mode. sctp_connectx() will fail with EINVAL.
>
> Kernel issue already fixed in:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=FFd5939381c609056b33b7585fb05a77b4c695f3=20
>
>
Thanks Daniel,

The patch is small, I can easily apply to my running kernel.

Dong
>> Thanks,
>>
>> Dong

