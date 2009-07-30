From: Rami Rosen <rosenrami@gmail.com>
Date: Thu, 30 Jul 2009 07:04:17 +0000
Subject: Re: [PATCH] sctp: remove unused union (sctp_cmsg_data_t) definition .
Message-Id: <ae5426fb0907300004p26aaa40atff6249389b73c724@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
In-Reply-To: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

>it still used by lksctp-tools.
I know; wouldn't it be more suitable to put it in include/linux/sctp.h ?

Regards,
Rami Rosen


On Thu, Jul 30, 2009 at 9:55 AM, Wei Yongjun<yjwei@cn.fujitsu.com> wrote:
> Rami Rosen wrote:
>> Hi,
>> This patch removes an unused union definition (sctp_cmsg_data_t)
>> from include/net/sctp/user.h.
>>
>> Regards,
>> Rami Rosen
>>
>>
>> Signed-off-by: Rami Rosen <rosenrami@gmail.com>
>>
>
> sctp_cmsg_data_t =A0is not used by kernel source code, but it still used
> by lksctp-tools.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
