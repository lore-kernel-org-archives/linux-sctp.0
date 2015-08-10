From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 10 Aug 2015 13:34:19 +0000
Subject: Re: DF flag on LKSCTP
Message-Id: <CAFXGftK0svb_HsY7NdsO-SxMgECt+b5piT1TrhBF4CRfdf3X+g@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft++VpN+uF6C9YT7z3cYYQoOmQgOz0Eo5Xj7_=625wA9QA@mail.gmail.com>
In-Reply-To: <CAFXGft++VpN+uF6C9YT7z3cYYQoOmQgOz0Eo5Xj7_=625wA9QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Thank for the reply

can you provide more details on this?



On Mon, Aug 10, 2015 at 8:25 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Aug 10, 2015 at 04:36:01PM +0800, Sun Paul wrote:
>> Hi
>>
>> is there a way to configuration to configure the IPv4 "Don't Fragment"
>> aligned with the system variable net.ipv4.ip_no_pmtu_disc?
>>
>> from the testing so far, the DF always set to 1 for those SCTP packet
>> generated from LKSCTP.
>>
>> - paul
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> PMT is set per peer address in sctp.  It defaults to on IIRC, and can be
> disabled per peer via the SCTP_PEER_ADDR_PARAMS socket option.
>
> Neil
>
