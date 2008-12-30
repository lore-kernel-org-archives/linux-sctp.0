From: "Horacio Sanson" <hsanson@gmail.com>
Date: Tue, 30 Dec 2008 16:07:16 +0000
Subject: Re: [PATCH] lksctp: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <6156dd8b0812300807v48fe12beyfbec68c8501d8d22@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="----=_Part_187146_3664055.1230653236531"
List-Id: <linux-sctp.vger.kernel.org>
References: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
In-Reply-To: <1229497479-10198-1-git-send-email-hsanson@gmail.com>
To: linux-sctp@vger.kernel.org

------=_Part_187146_3664055.1230653236531
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Based on comments from Vlad I have prepared a new patch to replace
sinfo_timetolive with the newer sinfo_pr_policy and sinfo_pr_value
fields.

On Wed, Dec 24, 2008 at 1:31 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> Horacio Sanson wrote:
>>>> These values, except for SCTP_EOF, are exactly the same values used in
>>>> the FreeBSD implementation. This scheme allows the lower byte to be
>>>> used for sctp_sinfo_pr_policy values.
>>>>
>>>> I modified all these flags so they coincide with FreeBSD
>>>> implementation that is also the same code base used for MacOSX and
>>>> Windows implementations to avoid any incompatibilities between
>>>> implementations. At least sinfo_pr_policy is transported between peers
>>>> in an association and having standard values is a good idea.
>>> Buy you don't use it as such.  You have a separate __u16 defined.to carry
>>> pr_policy.  So before we had a structure:
>>>
>>> struct sctp_sndrcvinfo {
>>>        __u16 sinfo_stream;
>>>        __u16 sinfo_ssn;
>>>        __u16 sinfo_flags;
>>>                             <---- 16bit memory hole
>>>        __u32 sinfo_ppid;
>>>        __u32 sinfo_context;
>>>        __u32 sinfo_timetolive;
>>>        __u32 sinfo_tsn;
>>>        __u32 sinfo_cumtsn;
>>>        sctp_assoc_t sinfo_assoc_id;
>>> };
>>>
>>> and now we have a structure
>>> struct sctp_sndrcvinfo {
>>>        __u16 sinfo_stream;
>>>        __u16 sinfo_ssn;
>>>        __u16 sinfo_flags;
>>>        __u16 sinfo_pr_policy;      <---- hole filled
>>>        __u32 sinfo_ppid;
>>>        __u32 sinfo_context;
>>>        __u32 sinfo_pr_value;
>>>        __u32 sinfo_tsn;
>>>        __u32 sinfo_cumtsn;
>>>        sctp_assoc_t sinfo_assoc_id;
>>> };
>>>
>>> So, I am trying to find the reason for shifting the flags.  Also, this shift
>>> would require all the application to recompile since they would suddenly start
>>> providing wrong flag values to the kernel (broken ABI).
>>>
>>
>> The idea of the shift, and this is how is done in FreeBSD, is to allow
>> both sinfo_flags and sinfo_pr_policy flags to be specified when using
>> the sctp_sendmsg() call. For example this would allow a call like:
>>
>>    sctp_sendmsg(sock,
>>                 msg, msglen,
>>                 toaddr, tolen,
>>                 0,
>>                 SCTP_UNORDERED|SCTP_PR_SCTP_TTL,  // <-- sinfo_flags
>> and sinfo_pr_policy
>>                 0, 3000, 0);
>>
>> The latest socket api draft does not mention the sinfo_pr_policy flags
>> as possible values for the flags argument in sctp_sendmsg() but I
>> believe this is a mistake as it makes no sense to allow users to
>> specify a pr_value but give no way to specify the corresponding
>> pr_policy in the same call. So even if the socket api draft states
>> that sinfo_flags and sinfo_pr_policy are separate fields in the
>> sctp_sndrcvinfo struct, there is a reason to have their values shifted
>> so they can be combined in a single integer variable.
>>
>
> Ok, so you don't really need to shift this.  You simply need to define
> the partial reliability policy as flags so they can be passed sctp_sendmsg().
>
> This is a problem with retrofitting the existing api that I'll bring up.
>
>>
>> To avoid breaking the ABI what would be a good approach?? I though
>> maybe doing this:
>>
>> enum sctp_sinfo_flags {
>>  SCTP_UNORDERED = 1,         /* Send/receive message unordered. */
>>  SCTP_ADDR_OVER = 2,         /* Override the primary destination. */
>>  SCTP_ABORT     = 4,         /* Send an ABORT message to the peer. */
>>  SCTP_PR_NONE   = 8,         /* Reliable transmission */
>>  SCTP_PR_TTL    = 16,        /* Timed partial reliability */
>>  SCTP_EOF       = MSG_FIN,   /* Initiate graceful shutdown process. (0x0200) */
>> };
>>
>> /* this for draft compatibility */
>> #define SCTP_PR_SCTP_NONE   SCTP_PR_NONE
>> #define SCTP_PR_SCTP_TTL    SCTP_PR_TTL
>>
>>
>> But allowing the SCTP_PR_* flags to coexist in the same integer is not
>> a good idea because these flags are exclusive.... if for some reason
>> the user provides both SCTP_PR_NONE and SCTP_PR_TTL at the same time
>> what should the implementation interpret? this is not addressed in the
>> draft either. The other option would be to reserve the higher 16bits
>> for PR policy flags and the lower 16bits for sinfo_flags:
>>
>
> The spec doesn't address at all the ability to pass pr policy values to sctp_sendmsg().
>

In the end I opted to use this approach of adding the SCTP_PR_SCTP_*
constants to the sinfo_flags enum. Using the upper 16 bits causes
a lot of trouble when splitting and converting it to a 16bit value
needed to fit in the sinfo_pr_policy field.

>
>> enum sctp_sinfo_flags {
>> ^ISCTP_UNORDERED = 1,         /* Send/receive message unordered. */
>> ^ISCTP_ADDR_OVER = 2,         /* Overrde the primary destination. */
>> ^ISCTP_ABORT     = 4,         /* Send an ABORT message to the peer. */
>> ^ISCTP_EOF       = MSG_FIN,   /* Initiate graceful shutdown process. (0x0200) */
>> ^ISCTP_PR_NONE   = 0x010000,  /* Reliable transmission */
>> ^ISCTP_PR_TTL    = 0x020000,  /* Timed partial reliability */
>> };
>>
>> but this assumes that integers are always 32bits long and I am not
>> sure this is a good assumption to take.
>
> This is safe because the flags argument to sctp_sendmsg() is defined as uint32_t and
> you are guaranteed to have 32 bits there.
>
> Also, notice that this split will need to be taken care of in libsctp, since that is
> where sctp_sendmsg() is defined.  That function will have to split the flags into
> sinfo_flags and sinfo_pr_policy.  This means that we'll need a 2 ways define policy:
> as a flag, and as a direct policy.
>
> The kernel doesn't need to know anything about the split and can treat the 'flag' policy
> values as errors.
>
> I think BSD shifted the flags so that it could get way without dual definitions, but they
> broke the ABI by doing so.  I don't know how they could get away with that.
>
>>
>
>>>> I need the ability to set sinfo_pr_policy to SCTP_PR_SCTP_TTL and
>>>> sinfo_pr_value equal to zero as a way to enable a completely
>>>> unreliable service (i.e. no retransmissions at all), similar to UDP
>>>> but with congestion control (maybe DCCP emulation??).
>>> OK.  So you need to have a default case, where the expires_policy is
>>> junk and in that case you verify pr_value before setting msg->expires_policy.
>>>
>>> In essence, you need to cover the case of user using the new structure as
>>> well as using an old structure that had a memory hole.
>>>
>>
>>
>>
>>>> I believe this functionality added to unordered delivery can be useful
>>>> for several applications and allows SCTP to cover all the reliability
>>>> spectrum from ordered reliable, ordered unreliable, unordered
>>>> reliable, unordered unreliable, ordered partial reliable and unordered
>>>> partial reliable.
>>>>
>>>> Another alternative would be to define a new partial reliability
>>>> profile, something like SCTP_PR_SCTP_UNR, that forces sinfo_pr_value
>>>> to zero and never retransmits.
>>> I think what you are looking for a retransmit policy (SCTP_PR_RTX) with the
>>> number of retransmits set 0.  You don't want to do this as a timer policy with
>>> a timeout of 0 milliseconds, because you may end up discarding packets
>>> as fast as your app can generate them and never send anything.
>>>
>>
>> I have this SCTP_PR_RTX functionality already implemented as a
>> separate patch. Once my first
>> patch gets approval I will submit it for review.
>>
>> If I understand right then something like this would be ok??
>>
>> switch(sinfo->sinfo_pr_policy) {
>>
>>     case SCTP_PR_NONE:
>>          msg->expires_policy = SCTP_PR_NONE;
>>          msg->expires_at = 0;
>>          break;
>>     case SCTP_PR_RTX:
>>          msg->expires_policy = SCTP_PR_RTX;
>>          msg->expires_at = sinfo->sinfo_pr_value;
>>          break;
>>     case SCTP_PR_TTL:
>>     default:
>>          if(pr_value <= 0) {
>
> I don't think pr_value can be less then 0 since it's defined a unsigned.

fixed.

>
>>             msg->expires_policy = SCTP_PR_NONE;
>>             msg->expires_at = 0;
>>          } else {
>>             msg->expires_policy = SCTP_PR_TTL;
>>             msg->expires_at = jiffies + msecs_to_jiffies(sinfo->sinfo_pr_value);
>>          }
>>          break;
>> }
>>
>
> Yes.
>

great, I use this switch statement now.

>>
>>>> About validating sinfo_pr_value and sinfo_pr_policy I added validating
>>>> code on the sctp_msghdr_parse method. I think this is the best place
>>>> to make this validation. This would also make sure that the user gets
>>>> an error message if the sinfo_pr_value or sinfo_pr_policy values are
>>>> not initialized correctly (me thinks).
>>> No, the user may be using an old structure and and old api/abi.  We can't break
>>> them.  This has been my gripe with this draft for a long time... it keeps
>>> breaking ABI and requiring these ugly workarounds.
>>>
>>> You can log a rate limited warning, but you can't error out since that will
>>> break applications.
>>>
>>> BTW, why are the constants SCTP_PR_SCTP_*.  Having SCTP there once should be
>>> enough.  We can define BSD compatibility stuff, but having it clean in the kernel.
>>>
>>
>> Once the values I can use for the SCTP_PR_* flags is established I
>> will think on the validation. And about the constants having SCTP
>> twice in them, well I am just following the draft as it is written.
>
> Ah... I should have looked.
>
> I think this is getting cleared up.  I'll get a comment to the rest
> of the authors and the wG about specifying policy in sctp_sendmsg() and let
> you know the outcome.
>

hope this time I got it right....

Horacio

> -vlad
>
>>
>> regards
>> Horacio
>>
>>> -vlad
>>>
>>
>
>

------=_Part_187146_3664055.1230653236531
Content-Type: text/x-diff;
 name=0001-lksctp-replace-sinfo_timetolive-with-sinfo_pr_value.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpcqtb3v0
Content-Disposition: attachment;
 filename=0001-lksctp-replace-sinfo_timetolive-with-sinfo_pr_value.patch

RnJvbSA3NWI1Njc3Mzk5ZGM1OGQ3NGRjN2NmYTA0YjRkNmYzN2VlNzA1ZWJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIb3JhY2lvIFNhbnNvbiA8aG9yYWNpb0Bza2lsbHVwamFwYW4u
Y28uanA+CkRhdGU6IFdlZCwgMzEgRGVjIDIwMDggMDA6NTI6NDEgKzA5MDAKU3ViamVjdDogW1BB
VENIXSBsa3NjdHA6IHJlcGxhY2Ugc2luZm9fdGltZXRvbGl2ZSB3aXRoIHNpbmZvX3ByX3ZhbHVl
LgoKTW9kaWZpZWQgYWxsIHJlbGV2YW50IHN0cnVjdHVyZXMgaW4gYWxsIGhlYWRlciBhbmQgc291
cmNlIGZpbGVzIHRvCnJlcGxhY2UgdGhlIGRlcHJlY2F0ZWQgc2luZm9fdGltZXRvbGl2ZSBmaWVs
ZCB3aXRoIHRoZSBuZXdlcgpzaW5mb19wcl9wb2xpY3kgYW5kIHNpbmZvX3ByX3ZhbHVlLgoKU2ln
bmVkLW9mZi1ieTogSG9yYWNpbyBTYW5zb24gPGhvcmFjaW9Ac2tpbGx1cGphcGFuLmNvLmpwPgot
LS0KIGluY2x1ZGUvbmV0L3NjdHAvc3RydWN0cy5oIHwgICAxMCArKysrKystLS0tCiBpbmNsdWRl
L25ldC9zY3RwL3VzZXIuaCAgICB8ICAgIDUgKysrKy0KIG5ldC9zY3RwL2Fzc29jaW9sYS5jICAg
ICAgIHwgICAgMyArKy0KIG5ldC9zY3RwL2NodW5rLmMgICAgICAgICAgIHwgICAzOSArKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0KIG5ldC9zY3RwL291dHB1dC5jICAgICAg
ICAgIHwgICAgMiArLQogbmV0L3NjdHAvc29ja2V0LmMgICAgICAgICAgfCAgIDI5ICsrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tCiBuZXQvc2N0cC91bHBldmVudC5jICAgICAgICB8ICAgIDMg
KystCiA3IGZpbGVzIGNoYW5nZWQsIDYwIGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjdHAvc3RydWN0cy5oIGIvaW5jbHVkZS9uZXQvc2N0
cC9zdHJ1Y3RzLmgKaW5kZXggOTY2MWQ3Yi4uZjdlYzI0OSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9u
ZXQvc2N0cC9zdHJ1Y3RzLmgKKysrIGIvaW5jbHVkZS9uZXQvc2N0cC9zdHJ1Y3RzLmgKQEAgLTI4
MCw5ICsyODAsMTAgQEAgc3RydWN0IHNjdHBfc29jayB7CiAJLyogVmFyaW91cyBTb2NrZXQgT3B0
aW9ucy4gICovCiAJX191MTYgZGVmYXVsdF9zdHJlYW07CiAJX191MzIgZGVmYXVsdF9wcGlkOwor
CV9fdTE2IGRlZmF1bHRfcHJfcG9saWN5OwogCV9fdTE2IGRlZmF1bHRfZmxhZ3M7CiAJX191MzIg
ZGVmYXVsdF9jb250ZXh0OwotCV9fdTMyIGRlZmF1bHRfdGltZXRvbGl2ZTsKKwlfX3UzMiBkZWZh
dWx0X3ByX3ZhbHVlOwogCV9fdTMyIGRlZmF1bHRfcmN2X2NvbnRleHQ7CiAJaW50IG1heF9idXJz
dDsKIApAQCAtNjI2LDEzICs2MjcsMTMgQEAgc3RydWN0IHNjdHBfZGF0YW1zZyB7CiAJc3RydWN0
IGxpc3RfaGVhZCB0cmFjazsKIAkvKiBSZWZlcmVuY2UgY291bnRpbmcuICovCiAJYXRvbWljX3Qg
cmVmY250OworCS8qIFBvbGljeSB1c2VkIHRvIGRldGVybWluZSBob3cgZXhwaXJlc19hdCBpcyBp
bnRlcnByZXRlZCAqLworCXVuc2lnbmVkIGxvbmcgZXhwaXJlc19wb2xpY3k7CiAJLyogV2hlbiBp
cyB0aGlzIG1lc3NhZ2Ugbm8gbG9uZ2VyIGludGVyZXN0aW5nIHRvIHRoZSBwZWVyPyAqLwogCXVu
c2lnbmVkIGxvbmcgZXhwaXJlc19hdDsKIAkvKiBEaWQgdGhlIG1lc3NlbmdlIGZhaWwgdG8gc2Vu
ZD8gKi8KIAlpbnQgc2VuZF9lcnJvcjsKIAljaGFyIHNlbmRfZmFpbGVkOwotCS8qIENvbnRyb2wg
d2hldGhlciBjaHVua3MgZnJvbSB0aGlzIG1lc3NhZ2UgY2FuIGJlIGFiYW5kb25lZC4gKi8KLQlj
aGFyIGNhbl9hYmFuZG9uOwogfTsKIAogc3RydWN0IHNjdHBfZGF0YW1zZyAqc2N0cF9kYXRhbXNn
X2Zyb21fdXNlcihzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqLApAQCAtMTc1OSw5ICsxNzYwLDEw
IEBAIHN0cnVjdCBzY3RwX2Fzc29jaWF0aW9uIHsKIAkvKiBEZWZhdWx0IHNlbmQgcGFyYW1ldGVy
cy4gKi8KIAlfX3UxNiBkZWZhdWx0X3N0cmVhbTsKIAlfX3UxNiBkZWZhdWx0X2ZsYWdzOworCV9f
dTE2IGRlZmF1bHRfcHJfcG9saWN5OwogCV9fdTMyIGRlZmF1bHRfcHBpZDsKIAlfX3UzMiBkZWZh
dWx0X2NvbnRleHQ7Ci0JX191MzIgZGVmYXVsdF90aW1ldG9saXZlOworCV9fdTMyIGRlZmF1bHRf
cHJfdmFsdWU7CiAKIAkvKiBEZWZhdWx0IHJlY2VpdmUgcGFyYW1ldGVycyAqLwogCV9fdTMyIGRl
ZmF1bHRfcmN2X2NvbnRleHQ7CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9zY3RwL3VzZXIuaCBi
L2luY2x1ZGUvbmV0L3NjdHAvdXNlci5oCmluZGV4IGYyMDViMTAuLmJjZGIwMWUgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvbmV0L3NjdHAvdXNlci5oCisrKyBiL2luY2x1ZGUvbmV0L3NjdHAvdXNlci5o
CkBAIC0xODMsOSArMTgzLDEwIEBAIHN0cnVjdCBzY3RwX3NuZHJjdmluZm8gewogCV9fdTE2IHNp
bmZvX3N0cmVhbTsKIAlfX3UxNiBzaW5mb19zc247CiAJX191MTYgc2luZm9fZmxhZ3M7CisJX191
MTYgc2luZm9fcHJfcG9saWN5OwogCV9fdTMyIHNpbmZvX3BwaWQ7CiAJX191MzIgc2luZm9fY29u
dGV4dDsKLQlfX3UzMiBzaW5mb190aW1ldG9saXZlOworCV9fdTMyIHNpbmZvX3ByX3ZhbHVlOwog
CV9fdTMyIHNpbmZvX3RzbjsKIAlfX3UzMiBzaW5mb19jdW10c247CiAJc2N0cF9hc3NvY190IHNp
bmZvX2Fzc29jX2lkOwpAQCAtMjAyLDYgKzIwMyw4IEBAIGVudW0gc2N0cF9zaW5mb19mbGFncyB7
CiAJU0NUUF9VTk9SREVSRUQgPSAxLCAgLyogU2VuZC9yZWNlaXZlIG1lc3NhZ2UgdW5vcmRlcmVk
LiAqLwogCVNDVFBfQUREUl9PVkVSID0gMiwgIC8qIE92ZXJyaWRlIHRoZSBwcmltYXJ5IGRlc3Rp
bmF0aW9uLiAqLwogCVNDVFBfQUJPUlQ9NCwgICAgICAgIC8qIFNlbmQgYW4gQUJPUlQgbWVzc2Fn
ZSB0byB0aGUgcGVlci4gKi8KKwlTQ1RQX1BSX1NDVFBfTk9ORT04LCAvKiBSZWxpYWJsZSB0cmFu
c21pc3Npb24gKi8KKwlTQ1RQX1BSX1NDVFBfVFRMPTE2LCAvKiBUaW1lZCBwYXJ0aWFsIHJlbGlh
YmlsaXR5ICovCiAJU0NUUF9FT0Y9TVNHX0ZJTiwgICAgLyogSW5pdGlhdGUgZ3JhY2VmdWwgc2h1
dGRvd24gcHJvY2Vzcy4gKi8JCiB9OwogCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9hc3NvY2lvbGEu
YyBiL25ldC9zY3RwL2Fzc29jaW9sYS5jCmluZGV4IGY0YjIzMDQuLmMxNzgxMzkgMTAwNjQ0Ci0t
LSBhL25ldC9zY3RwL2Fzc29jaW9sYS5jCisrKyBiL25ldC9zY3RwL2Fzc29jaW9sYS5jCkBAIC0z
MDIsNyArMzAyLDggQEAgc3RhdGljIHN0cnVjdCBzY3RwX2Fzc29jaWF0aW9uICpzY3RwX2Fzc29j
aWF0aW9uX2luaXQoc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKmEKIAlhc29jLT5kZWZhdWx0X3Bw
aWQgPSBzcC0+ZGVmYXVsdF9wcGlkOwogCWFzb2MtPmRlZmF1bHRfZmxhZ3MgPSBzcC0+ZGVmYXVs
dF9mbGFnczsKIAlhc29jLT5kZWZhdWx0X2NvbnRleHQgPSBzcC0+ZGVmYXVsdF9jb250ZXh0Owot
CWFzb2MtPmRlZmF1bHRfdGltZXRvbGl2ZSA9IHNwLT5kZWZhdWx0X3RpbWV0b2xpdmU7CisJYXNv
Yy0+ZGVmYXVsdF9wcl9wb2xpY3kgPSBzcC0+ZGVmYXVsdF9wcl9wb2xpY3k7CisJYXNvYy0+ZGVm
YXVsdF9wcl92YWx1ZSA9IHNwLT5kZWZhdWx0X3ByX3ZhbHVlOwogCWFzb2MtPmRlZmF1bHRfcmN2
X2NvbnRleHQgPSBzcC0+ZGVmYXVsdF9yY3ZfY29udGV4dDsKIAogCS8qIEFVVEggcmVsYXRlZCBp
bml0aWFsaXphdGlvbnMgKi8KZGlmZiAtLWdpdCBhL25ldC9zY3RwL2NodW5rLmMgYi9uZXQvc2N0
cC9jaHVuay5jCmluZGV4IDE3NDhlZjkuLjMzMTQxYmUgMTAwNjQ0Ci0tLSBhL25ldC9zY3RwL2No
dW5rLmMKKysrIGIvbmV0L3NjdHAvY2h1bmsuYwpAQCAtNTYsNyArNTYsNyBAQCBzdGF0aWMgdm9p
ZCBzY3RwX2RhdGFtc2dfaW5pdChzdHJ1Y3Qgc2N0cF9kYXRhbXNnICptc2cpCiAJYXRvbWljX3Nl
dCgmbXNnLT5yZWZjbnQsIDEpOwogCW1zZy0+c2VuZF9mYWlsZWQgPSAwOwogCW1zZy0+c2VuZF9l
cnJvciA9IDA7Ci0JbXNnLT5jYW5fYWJhbmRvbiA9IDA7CisJbXNnLT5leHBpcmVzX3BvbGljeSA9
IFNDVFBfUFJfU0NUUF9OT05FOwogCW1zZy0+ZXhwaXJlc19hdCA9IDA7CiAJSU5JVF9MSVNUX0hF
QUQoJm1zZy0+Y2h1bmtzKTsKIH0KQEAgLTE3MCwxMyArMTcwLDIzIEBAIHN0cnVjdCBzY3RwX2Rh
dGFtc2cgKnNjdHBfZGF0YW1zZ19mcm9tX3VzZXIoc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKmFz
b2MsCiAJLyogTm90ZTogQ2FsY3VsYXRlIHRoaXMgb3V0c2lkZSBvZiB0aGUgbG9vcCwgc28gdGhh
dCBhbGwgZnJhZ21lbnRzCiAJICogaGF2ZSB0aGUgc2FtZSBleHBpcmF0aW9uLgogCSAqLwotCWlm
IChzaW5mby0+c2luZm9fdGltZXRvbGl2ZSkgewotCQkvKiBzaW5mb190aW1ldG9saXZlIGlzIGlu
IG1pbGxpc2Vjb25kcyAqLwotCQltc2ctPmV4cGlyZXNfYXQgPSBqaWZmaWVzICsKLQkJCQkgICAg
bXNlY3NfdG9famlmZmllcyhzaW5mby0+c2luZm9fdGltZXRvbGl2ZSk7Ci0JCW1zZy0+Y2FuX2Fi
YW5kb24gPSAxOwotCQlTQ1RQX0RFQlVHX1BSSU5USygiJXM6IG1zZzolcCBleHBpcmVzX2F0OiAl
bGQgamlmZmllczolbGRcbiIsCi0JCQkJICBfX2Z1bmNfXywgbXNnLCBtc2ctPmV4cGlyZXNfYXQs
IGppZmZpZXMpOworCXN3aXRjaChzaW5mby0+c2luZm9fcHJfcG9saWN5KSB7CisJCWNhc2UgU0NU
UF9QUl9TQ1RQX05PTkU6CisJCQltc2ctPmV4cGlyZXNfcG9saWN5ID0gU0NUUF9QUl9TQ1RQX05P
TkU7CisJCQltc2ctPmV4cGlyZXNfYXQgPSAwOworCQkJYnJlYWs7CisJCWNhc2UgU0NUUF9QUl9T
Q1RQX1RUTDoKKwkJZGVmYXVsdDoKKwkJCWlmKCFzaW5mby0+c2luZm9fcHJfdmFsdWUpIHsKKwkJ
CQltc2ctPmV4cGlyZXNfcG9saWN5ID0gU0NUUF9QUl9TQ1RQX05PTkU7CisJCQkJbXNnLT5leHBp
cmVzX2F0ID0gMDsKKwkJCX0gZWxzZSB7CisJCQkJbXNnLT5leHBpcmVzX3BvbGljeSA9IFNDVFBf
UFJfU0NUUF9UVEw7CisJCQkJbXNnLT5leHBpcmVzX2F0ID0gamlmZmllcyArIG1zZWNzX3RvX2pp
ZmZpZXMoc2luZm8tPnNpbmZvX3ByX3ZhbHVlKTsKKwkJCQlTQ1RQX0RFQlVHX1BSSU5USygiJXM6
IG1zZzolcCBleHBpcmVzX2F0OiAlbGQgamlmZmllczolbGRcbiIsCisJCQkJCV9fZnVuY19fLCBt
c2csIG1zZy0+ZXhwaXJlc19hdCwgamlmZmllcyk7CisJCQl9CisJCQlicmVhazsKIAl9CiAKIAlt
YXggPSBhc29jLT5mcmFnX3BvaW50OwpAQCAtMjkxLDExICszMDEsMTQgQEAgaW50IHNjdHBfY2h1
bmtfYWJhbmRvbmVkKHN0cnVjdCBzY3RwX2NodW5rICpjaHVuaykKIHsKIAlzdHJ1Y3Qgc2N0cF9k
YXRhbXNnICptc2cgPSBjaHVuay0+bXNnOwogCi0JaWYgKCFtc2ctPmNhbl9hYmFuZG9uKQotCQly
ZXR1cm4gMDsKLQotCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIG1zZy0+ZXhwaXJlc19hdCkpCi0J
CXJldHVybiAxOworCXN3aXRjaChtc2ctPmV4cGlyZXNfcG9saWN5KSB7CisJCWNhc2UgU0NUUF9Q
Ul9TQ1RQX05PTkU6CisJCQkJcmV0dXJuIDA7CisJCWNhc2UgU0NUUF9QUl9TQ1RQX1RUTDoKKwkJ
CWlmKHRpbWVfYWZ0ZXIoamlmZmllcywgbXNnLT5leHBpcmVzX2F0KSkKKwkJCQlyZXR1cm4gMTsK
KwkJCWJyZWFrOworCX0KIAogCXJldHVybiAwOwogfQpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvb3V0
cHV0LmMgYi9uZXQvc2N0cC9vdXRwdXQuYwppbmRleCBjM2Y0MTdmLi5iMzQ0YTlkIDEwMDY0NAot
LS0gYS9uZXQvc2N0cC9vdXRwdXQuYworKysgYi9uZXQvc2N0cC9vdXRwdXQuYwpAQCAtNzQ1LDcg
Kzc0NSw3IEBAIHN0YXRpYyBzY3RwX3htaXRfdCBzY3RwX3BhY2tldF9hcHBlbmRfZGF0YShzdHJ1
Y3Qgc2N0cF9wYWNrZXQgKnBhY2tldCwKIAlhc29jLT5wZWVyLnJ3bmQgPSByd25kOwogCS8qIEhh
cyBiZWVuIGFjY2VwdGVkIGZvciB0cmFuc21pc3Npb24uICovCiAJaWYgKCFhc29jLT5wZWVyLnBy
c2N0cF9jYXBhYmxlKQotCQljaHVuay0+bXNnLT5jYW5fYWJhbmRvbiA9IDA7CisJCWNodW5rLT5t
c2ctPmV4cGlyZXNfcG9saWN5ID0gU0NUUF9QUl9TQ1RQX05PTkU7CiAKIGZpbmlzaDoKIAlyZXR1
cm4gcmV0dmFsOwpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvc29ja2V0LmMgYi9uZXQvc2N0cC9zb2Nr
ZXQuYwppbmRleCBhMWI5MDQ1Li5jMjFjYjRjIDEwMDY0NAotLS0gYS9uZXQvc2N0cC9zb2NrZXQu
YworKysgYi9uZXQvc2N0cC9zb2NrZXQuYwpAQCAtMTY5OCw3ICsxNjk4LDggQEAgU0NUUF9TVEFU
SUMgaW50IHNjdHBfc2VuZG1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrICpzaywK
IAkJZGVmYXVsdF9zaW5mby5zaW5mb19mbGFncyA9IGFzb2MtPmRlZmF1bHRfZmxhZ3M7CiAJCWRl
ZmF1bHRfc2luZm8uc2luZm9fcHBpZCA9IGFzb2MtPmRlZmF1bHRfcHBpZDsKIAkJZGVmYXVsdF9z
aW5mby5zaW5mb19jb250ZXh0ID0gYXNvYy0+ZGVmYXVsdF9jb250ZXh0OwotCQlkZWZhdWx0X3Np
bmZvLnNpbmZvX3RpbWV0b2xpdmUgPSBhc29jLT5kZWZhdWx0X3RpbWV0b2xpdmU7CisJCWRlZmF1
bHRfc2luZm8uc2luZm9fcHJfcG9saWN5ID0gYXNvYy0+ZGVmYXVsdF9wcl9wb2xpY3k7CisJCWRl
ZmF1bHRfc2luZm8uc2luZm9fcHJfdmFsdWUgPSBhc29jLT5kZWZhdWx0X3ByX3ZhbHVlOwogCQlk
ZWZhdWx0X3NpbmZvLnNpbmZvX2Fzc29jX2lkID0gc2N0cF9hc3NvYzJpZChhc29jKTsKIAkJc2lu
Zm8gPSAmZGVmYXVsdF9zaW5mbzsKIAl9CkBAIC0yNTM5LDcgKzI1NDAsNyBAQCBzdGF0aWMgaW50
IHNjdHBfc2V0c29ja29wdF9pbml0bXNnKHN0cnVjdCBzb2NrICpzaywgY2hhciBfX3VzZXIgKm9w
dHZhbCwgaW50IG9wdAogICogICBpbiB0byB0aGlzIGNhbGwgdGhlIHNjdHBfc25kcmN2aW5mbyBz
dHJ1Y3R1cmUgZGVmaW5lZCBpbiBTZWN0aW9uCiAgKiAgIDUuMi4yKSBUaGUgaW5wdXQgcGFyYW1l
dGVycyBhY2NlcHRlZCBieSB0aGlzIGNhbGwgaW5jbHVkZQogICogICBzaW5mb19zdHJlYW0sIHNp
bmZvX2ZsYWdzLCBzaW5mb19wcGlkLCBzaW5mb19jb250ZXh0LAotICogICBzaW5mb190aW1ldG9s
aXZlLiAgVGhlIHVzZXIgbXVzdCBwcm92aWRlIHRoZSBzaW5mb19hc3NvY19pZCBmaWVsZCBpbgor
ICogICBzaW5mb19wcl92YWx1ZS4gIFRoZSB1c2VyIG11c3QgcHJvdmlkZSB0aGUgc2luZm9fYXNz
b2NfaWQgZmllbGQgaW4KICAqICAgdG8gdGhpcyBjYWxsIGlmIHRoZSBjYWxsZXIgaXMgdXNpbmcg
dGhlIFVEUCBtb2RlbC4KICAqLwogc3RhdGljIGludCBzY3RwX3NldHNvY2tvcHRfZGVmYXVsdF9z
ZW5kX3BhcmFtKHN0cnVjdCBzb2NrICpzaywKQEAgLTI1NjMsMTMgKzI1NjQsMTUgQEAgc3RhdGlj
IGludCBzY3RwX3NldHNvY2tvcHRfZGVmYXVsdF9zZW5kX3BhcmFtKHN0cnVjdCBzb2NrICpzaywK
IAkJYXNvYy0+ZGVmYXVsdF9mbGFncyA9IGluZm8uc2luZm9fZmxhZ3M7CiAJCWFzb2MtPmRlZmF1
bHRfcHBpZCA9IGluZm8uc2luZm9fcHBpZDsKIAkJYXNvYy0+ZGVmYXVsdF9jb250ZXh0ID0gaW5m
by5zaW5mb19jb250ZXh0OwotCQlhc29jLT5kZWZhdWx0X3RpbWV0b2xpdmUgPSBpbmZvLnNpbmZv
X3RpbWV0b2xpdmU7CisJCWFzb2MtPmRlZmF1bHRfcHJfcG9saWN5ID0gaW5mby5zaW5mb19wcl9w
b2xpY3k7CisJCWFzb2MtPmRlZmF1bHRfcHJfdmFsdWUgPSBpbmZvLnNpbmZvX3ByX3ZhbHVlOwog
CX0gZWxzZSB7CiAJCXNwLT5kZWZhdWx0X3N0cmVhbSA9IGluZm8uc2luZm9fc3RyZWFtOwogCQlz
cC0+ZGVmYXVsdF9mbGFncyA9IGluZm8uc2luZm9fZmxhZ3M7CiAJCXNwLT5kZWZhdWx0X3BwaWQg
PSBpbmZvLnNpbmZvX3BwaWQ7CiAJCXNwLT5kZWZhdWx0X2NvbnRleHQgPSBpbmZvLnNpbmZvX2Nv
bnRleHQ7Ci0JCXNwLT5kZWZhdWx0X3RpbWV0b2xpdmUgPSBpbmZvLnNpbmZvX3RpbWV0b2xpdmU7
CisJCXNwLT5kZWZhdWx0X3ByX3BvbGljeSA9IGluZm8uc2luZm9fcHJfcG9saWN5OworCQlzcC0+
ZGVmYXVsdF9wcl92YWx1ZSA9IGluZm8uc2luZm9fcHJfdmFsdWU7CiAJfQogCiAJcmV0dXJuIDA7
CkBAIC0zNTI0LDcgKzM1MjcsOCBAQCBTQ1RQX1NUQVRJQyBpbnQgc2N0cF9pbml0X3NvY2soc3Ry
dWN0IHNvY2sgKnNrKQogCXNwLT5kZWZhdWx0X3BwaWQgPSAwOwogCXNwLT5kZWZhdWx0X2ZsYWdz
ID0gMDsKIAlzcC0+ZGVmYXVsdF9jb250ZXh0ID0gMDsKLQlzcC0+ZGVmYXVsdF90aW1ldG9saXZl
ID0gMDsKKwlzcC0+ZGVmYXVsdF9wcl9wb2xpY3kgPSBTQ1RQX1BSX1NDVFBfTk9ORTsKKwlzcC0+
ZGVmYXVsdF9wcl92YWx1ZSA9IDA7CiAKIAlzcC0+ZGVmYXVsdF9yY3ZfY29udGV4dCA9IDA7CiAJ
c3AtPm1heF9idXJzdCA9IHNjdHBfbWF4X2J1cnN0OwpAQCAtNDgyNCw3ICs0ODI4LDcgQEAgc3Rh
dGljIGludCBzY3RwX2dldHNvY2tvcHRfYWRhcHRhdGlvbl9sYXllcihzdHJ1Y3Qgc29jayAqc2ss
IGludCBsZW4sCiAgKiAgIGluIHRvIHRoaXMgY2FsbCB0aGUgc2N0cF9zbmRyY3ZpbmZvIHN0cnVj
dHVyZSBkZWZpbmVkIGluIFNlY3Rpb24KICAqICAgNS4yLjIpIFRoZSBpbnB1dCBwYXJhbWV0ZXJz
IGFjY2VwdGVkIGJ5IHRoaXMgY2FsbCBpbmNsdWRlCiAgKiAgIHNpbmZvX3N0cmVhbSwgc2luZm9f
ZmxhZ3MsIHNpbmZvX3BwaWQsIHNpbmZvX2NvbnRleHQsCi0gKiAgIHNpbmZvX3RpbWV0b2xpdmUu
ICBUaGUgdXNlciBtdXN0IHByb3ZpZGUgdGhlIHNpbmZvX2Fzc29jX2lkIGZpZWxkIGluCisgKiAg
IHNpbmZvX3ByX3ZhbHVlLiAgVGhlIHVzZXIgbXVzdCBwcm92aWRlIHRoZSBzaW5mb19hc3NvY19p
ZCBmaWVsZCBpbgogICogICB0byB0aGlzIGNhbGwgaWYgdGhlIGNhbGxlciBpcyB1c2luZyB0aGUg
VURQIG1vZGVsLgogICoKICAqICAgRm9yIGdldHNvY2tvcHQsIGl0IGdldCB0aGUgZGVmYXVsdCBz
Y3RwX3NuZHJjdmluZm8gc3RydWN0dXJlLgpAQCAtNDg1NCwxMyArNDg1OCwxNSBAQCBzdGF0aWMg
aW50IHNjdHBfZ2V0c29ja29wdF9kZWZhdWx0X3NlbmRfcGFyYW0oc3RydWN0IHNvY2sgKnNrLAog
CQlpbmZvLnNpbmZvX2ZsYWdzID0gYXNvYy0+ZGVmYXVsdF9mbGFnczsKIAkJaW5mby5zaW5mb19w
cGlkID0gYXNvYy0+ZGVmYXVsdF9wcGlkOwogCQlpbmZvLnNpbmZvX2NvbnRleHQgPSBhc29jLT5k
ZWZhdWx0X2NvbnRleHQ7Ci0JCWluZm8uc2luZm9fdGltZXRvbGl2ZSA9IGFzb2MtPmRlZmF1bHRf
dGltZXRvbGl2ZTsKKwkJaW5mby5zaW5mb19wcl9wb2xpY3kgPSBhc29jLT5kZWZhdWx0X3ByX3Bv
bGljeTsKKwkJaW5mby5zaW5mb19wcl92YWx1ZSA9IGFzb2MtPmRlZmF1bHRfcHJfdmFsdWU7CiAJ
fSBlbHNlIHsKIAkJaW5mby5zaW5mb19zdHJlYW0gPSBzcC0+ZGVmYXVsdF9zdHJlYW07CiAJCWlu
Zm8uc2luZm9fZmxhZ3MgPSBzcC0+ZGVmYXVsdF9mbGFnczsKIAkJaW5mby5zaW5mb19wcGlkID0g
c3AtPmRlZmF1bHRfcHBpZDsKIAkJaW5mby5zaW5mb19jb250ZXh0ID0gc3AtPmRlZmF1bHRfY29u
dGV4dDsKLQkJaW5mby5zaW5mb190aW1ldG9saXZlID0gc3AtPmRlZmF1bHRfdGltZXRvbGl2ZTsK
KwkJaW5mby5zaW5mb19wcl9wb2xpY3kgPSBzcC0+ZGVmYXVsdF9wcl9wb2xpY3k7CisJCWluZm8u
c2luZm9fcHJfdmFsdWUgPSBzcC0+ZGVmYXVsdF9wcl92YWx1ZTsKIAl9CiAKIAlpZiAocHV0X3Vz
ZXIobGVuLCBvcHRsZW4pKQpAQCAtNjEwNywxMCArNjExMywxMyBAQCBTQ1RQX1NUQVRJQyBpbnQg
c2N0cF9tc2doZHJfcGFyc2UoY29uc3Qgc3RydWN0IG1zZ2hkciAqbXNnLAogCQkJCShzdHJ1Y3Qg
c2N0cF9zbmRyY3ZpbmZvICopQ01TR19EQVRBKGNtc2cpOwogCiAJCQkvKiBNaW5pbWFsbHksIHZh
bGlkYXRlIHRoZSBzaW5mb19mbGFncy4gKi8KLQkJCWlmIChjbXNncy0+aW5mby0+c2luZm9fZmxh
Z3MgJgorLyoKK2lmIChjbXNncy0+aW5mby0+c2luZm9fZmxhZ3MgJgogCQkJICAgIH4oU0NUUF9V
Tk9SREVSRUQgfCBTQ1RQX0FERFJfT1ZFUiB8Ci0JCQkgICAgICBTQ1RQX0FCT1JUIHwgU0NUUF9F
T0YpKQorCQkJICAgICAgU0NUUF9BQk9SVCB8IFNDVFBfRU9GIHwgU0NUUF9QUl9TQ1RQX05PTkUg
fAorCQkJICAgICAgU0NUUF9QUl9TQ1RQX1RUTCkpCiAJCQkJcmV0dXJuIC1FSU5WQUw7CisqLwog
CQkJYnJlYWs7CiAKIAkJZGVmYXVsdDoKZGlmZiAtLWdpdCBhL25ldC9zY3RwL3VscGV2ZW50LmMg
Yi9uZXQvc2N0cC91bHBldmVudC5jCmluZGV4IDVmMTg2Y2EuLjk1MTdlNDcgMTAwNjQ0Ci0tLSBh
L25ldC9zY3RwL3VscGV2ZW50LmMKKysrIGIvbmV0L3NjdHAvdWxwZXZlbnQuYwpAQCAtOTQ4LDcg
Kzk0OCw4IEBAIHZvaWQgc2N0cF91bHBldmVudF9yZWFkX3NuZHJjdmluZm8oY29uc3Qgc3RydWN0
IHNjdHBfdWxwZXZlbnQgKmV2ZW50LAogCXNpbmZvLnNpbmZvX2NvbnRleHQgPSBldmVudC0+YXNv
Yy0+ZGVmYXVsdF9yY3ZfY29udGV4dDsKIAogCS8qIFRoZXNlIGZpZWxkcyBhcmUgbm90IHVzZWQg
d2hpbGUgcmVjZWl2aW5nLiAqLwotCXNpbmZvLnNpbmZvX3RpbWV0b2xpdmUgPSAwOworCXNpbmZv
LnNpbmZvX3ByX3BvbGljeSA9IFNDVFBfUFJfU0NUUF9OT05FOworCXNpbmZvLnNpbmZvX3ByX3Zh
bHVlID0gMDsKIAogCXB1dF9jbXNnKG1zZ2hkciwgSVBQUk9UT19TQ1RQLCBTQ1RQX1NORFJDViwK
IAkJIHNpemVvZihzdHJ1Y3Qgc2N0cF9zbmRyY3ZpbmZvKSwgKHZvaWQgKikmc2luZm8pOwotLSAK
MS41LjYuMwoK
------=_Part_187146_3664055.1230653236531--
