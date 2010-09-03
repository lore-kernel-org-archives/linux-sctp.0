From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Date: Fri, 03 Sep 2010 15:54:12 +0000
Subject: Re: [PATCH] sctp: prevent reading out-of-bounds memory
Message-Id: <AANLkTin=qJxn1dYjmAa8pwR38EEin8fsJJnR0vc1JxJT@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <AANLkTineCKfL-UvqfQBTZPDFeqm3Nrpb=pFnZpkSqbEQ@mail.gmail.com>
	<4C810313.80000@hp.com>
	<AANLkTikRBOhTQM0gyS8_Vwu7EsetaaaEuv0owkBp7B_F@mail.gmail.com>
	<AANLkTi=dtsjCvvoOYBiMe6+sro8Ui8P7xtMH=k808BwU@mail.gmail.com>
	<4C8118F6.3010405@hp.com>
In-Reply-To: <4C8118F6.3010405@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Hopefully this covers everything.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/net/sctp/socket.c	2010-09-03 08:58:48.127080114 -04=
00
+++ linux-2.6.35.4/net/sctp/socket.c	2010-09-03 11:52:28.239595395 -0400
@@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf =3D kaddrs;
 	while (walk_size < addrs_size) {
+
+		if (walk_size + sizeof(sa_family_t) > addrs_size) {
+			kfree(kaddrs);
+			return -EINVAL;
+		}
+
 		sa_addr =3D (struct sockaddr *)addr_buf;
 		af =3D sctp_get_af_specific(sa_addr->sa_family);

@@ -1002,9 +1008,14 @@ static int __sctp_connect(struct sock* s
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf =3D kaddrs;
 	while (walk_size < addrs_size) {
+
+		if (walk_size + sizeof(sa_family_t) > addrs_size) {
+			err =3D -EINVAL;
+			goto out_free;
+		}
+
 		sa_addr =3D (union sctp_addr *)addr_buf;
 		af =3D sctp_get_af_specific(sa_addr->sa.sa_family);
-		port =3D ntohs(sa_addr->v4.sin_port);

 		/* If the address family is not supported or if this address
 		 * causes the address buffer to overflow return EINVAL.
@@ -1013,6 +1024,8 @@ static int __sctp_connect(struct sock* s
 			err =3D -EINVAL;
 			goto out_free;
 		}
+	=09
+		port =3D ntohs(sa_addr->v4.sin_port);

 		/* Save current address so we can work with it */
 		memcpy(&to, sa_addr, af->sockaddr_len);



On Fri, Sep 3, 2010 at 11:49 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
> On 09/03/2010 10:47 AM, Dan Rosenberg wrote:
>> Ugh, just remembered the port number is also dereferenced, so the
>> second of these two checks needs to be expanded to the size of a
>> sockaddr_in. =A0Note to self: don't write patches on too little sleep.
>> Apologies for the unnecessary traffic.
>>
>
> Actually, you can move that down. =A0Otherwise, we'd end up executing the=
 same code
> twice which is just silly.
>
> So, the code should be like this:
> =A0 =A0 =A0 =A01. =A0see if we can get the address family.
> =A0 =A0 =A0 =A02. =A0Get the address family.
> =A0 =A0 =A0 =A03. =A0see if we get the sockaddr of appropriate size,
> =A0 =A0 =A0 =A04. =A0Get that structure.
> =A0 =A0 =A0 =A05. =A0reference fields.
>
> -vlad
>
>> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>>
>> --- linux-2.6.35.4.orig/net/sctp/socket.c =A0 =A0 2010-09-03 08:58:48.12=
7080114 -0400
>> +++ linux-2.6.35.4/net/sctp/socket.c =A02010-09-03 10:45:08.467098052 -0=
400
>> @@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>> =A0 =A0 =A0 /* Walk through the addrs buffer and count the number of add=
resses. */
>> =A0 =A0 =A0 addr_buf =3D kaddrs;
>> =A0 =A0 =A0 while (walk_size < addrs_size) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (walk_size + sizeof(sa_family_t) > addrs_si=
ze) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(kaddrs);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa_addr =3D (struct sockaddr *)addr_buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 af =3D sctp_get_af_specific(sa_addr->sa_fami=
ly);
>>
>> @@ -1002,6 +1008,12 @@ static int __sctp_connect(struct sock* s
>> =A0 =A0 =A0 /* Walk through the addrs buffer and count the number of add=
resses. */
>> =A0 =A0 =A0 addr_buf =3D kaddrs;
>> =A0 =A0 =A0 while (walk_size < addrs_size) {
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (walk_size + sizeof(struct sockaddr_in) > a=
ddrs_size) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa_addr =3D (union sctp_addr *)addr_buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 af =3D sctp_get_af_specific(sa_addr->sa.sa_f=
amily);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 port =3D ntohs(sa_addr->v4.sin_port);
>>
>>
>>
>> On Fri, Sep 3, 2010 at 10:35 AM, Dan Rosenberg
>> <dan.j.rosenberg@gmail.com> wrote:
>>> Ha, I knew there was an easier way. =A0Take two:
>>>
>>> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>>>
>>> --- linux-2.6.35.4.orig/net/sctp/socket.c =A0 =A0 =A0 2010-09-03 08:58:=
48.127080114 -0400
>>> +++ linux-2.6.35.4/net/sctp/socket.c =A0 =A02010-09-03 10:28:14.9295953=
12 -0400
>>> @@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>> =A0 =A0 =A0 =A0/* Walk through the addrs buffer and count the number of=
 addresses. */
>>> =A0 =A0 =A0 =A0addr_buf =3D kaddrs;
>>> =A0 =A0 =A0 =A0while (walk_size < addrs_size) {
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (walk_size + sizeof(sa_family_t) > add=
rs_size) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(kaddrs);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sa_addr =3D (struct sockaddr *)addr_buf;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0af =3D sctp_get_af_specific(sa_addr->sa_=
family);
>>>
>>> @@ -1002,6 +1008,12 @@ static int __sctp_connect(struct sock* s
>>> =A0 =A0 =A0 =A0/* Walk through the addrs buffer and count the number of=
 addresses. */
>>> =A0 =A0 =A0 =A0addr_buf =3D kaddrs;
>>> =A0 =A0 =A0 =A0while (walk_size < addrs_size) {
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (walk_size + sizeof(sa_family_t) > add=
rs_size) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sa_addr =3D (union sctp_addr *)addr_buf;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0af =3D sctp_get_af_specific(sa_addr->sa.=
sa_family);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port =3D ntohs(sa_addr->v4.sin_port);
>>>
>>>
>>>>
>>>> Hm.. we already validate that we have the proper amount of space for a=
 given sockaddr.
>>>> The only thing we are missing is making sure that there is room to get=
 the proper address
>>>> family and I think you can do that without adding any extra variables:
>>>>
>>>> =A0 =A0 =A0 =A0if (walk_size + sizeof(sa_family_t) > addr_size) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Not enough room for address family */
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(kaddrs);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>>>> =A0 =A0 =A0 =A0}
>>>>
>>>> -vlad
>>>>
>>>
>>> On Fri, Sep 3, 2010 at 10:15 AM, Vlad Yasevich
>>> <vladislav.yasevich@hp.com> wrote:
>>>> On 09/03/2010 09:48 AM, Dan Rosenberg wrote:
>>>>> Two user-controlled allocations in SCTP are subsequently dereferenced
>>>>> as sockaddr structs, without checking if the dereferenced struct
>>>>> members fall beyond the end of the allocated chunk. =A0There doesn't
>>>>> appear to be any information leakage here based on how these members
>>>>> are used and additional checking, but it's still worth fixing.
>>>>>
>>>>> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
>>>>>
>>>>> --- linux-2.6.35.4.orig/net/sctp/socket.c =A0 =A0 2010-09-03 08:58:48=
.127080114 -0400
>>>>> +++ linux-2.6.35.4/net/sctp/socket.c =A02010-09-03 09:22:06.337096825=
 -0400
>>>>> @@ -889,6 +889,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>>> =A0 =A0 =A0 int err;
>>>>> =A0 =A0 =A0 int addrcnt =3D 0;
>>>>> =A0 =A0 =A0 int walk_size =3D 0;
>>>>> + =A0 =A0 unsigned int remaining =3D addrs_size;
>>>>> =A0 =A0 =A0 struct sockaddr *sa_addr;
>>>>> =A0 =A0 =A0 void *addr_buf;
>>>>> =A0 =A0 =A0 struct sctp_af *af;
>>>>> @@ -916,6 +917,13 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>>> =A0 =A0 =A0 /* Walk through the addrs buffer and count the number of =
addresses. */
>>>>> =A0 =A0 =A0 addr_buf =3D kaddrs;
>>>>> =A0 =A0 =A0 while (walk_size < addrs_size) {
>>>>> +
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Don't read out-of-bounds memory */
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (remaining < sizeof(struct sockaddr)) {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(kaddrs);
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>>>> +
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa_addr =3D (struct sockaddr *)addr_buf;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 af =3D sctp_get_af_specific(sa_addr->sa_f=
amily);
>>>>>
>>>>> @@ -929,6 +937,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 addrcnt++;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr_buf +=3D af->sockaddr_len;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 walk_size +=3D af->sockaddr_len;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 remaining -=3D af->sockaddr_len;
>>>>> =A0 =A0 =A0 }
>>>>>
>>>>> =A0 =A0 =A0 /* Do the work. */
>>>>> @@ -984,6 +993,7 @@ static int __sctp_connect(struct sock* s
>>>>> =A0 =A0 =A0 void *addr_buf;
>>>>> =A0 =A0 =A0 unsigned short port;
>>>>> =A0 =A0 =A0 unsigned int f_flags =3D 0;
>>>>> + =A0 =A0 unsigned int remaining =3D addrs_size;
>>>>>
>>>>> =A0 =A0 =A0 sp =3D sctp_sk(sk);
>>>>> =A0 =A0 =A0 ep =3D sp->ep;
>>>>> @@ -1002,6 +1012,13 @@ static int __sctp_connect(struct sock* s
>>>>> =A0 =A0 =A0 /* Walk through the addrs buffer and count the number of =
addresses. */
>>>>> =A0 =A0 =A0 addr_buf =3D kaddrs;
>>>>> =A0 =A0 =A0 while (walk_size < addrs_size) {
>>>>> +
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Don't read out-of-bounds memory */
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (remaining < sizeof(union sctp_addr)) {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EINVAL;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>>>> +
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa_addr =3D (union sctp_addr *)addr_buf;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 af =3D sctp_get_af_specific(sa_addr->sa.s=
a_family);
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 port =3D ntohs(sa_addr->v4.sin_port);
>>>>> @@ -1101,6 +1118,7 @@ static int __sctp_connect(struct sock* s
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 addrcnt++;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr_buf +=3D af->sockaddr_len;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 walk_size +=3D af->sockaddr_len;
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 remaining -=3D af->sockaddr_len;
>>>>> =A0 =A0 =A0 }
>>>>>
>>>>> =A0 =A0 =A0 /* In case the user of sctp_connectx() wants an associati=
on
>>>>>
>>>>
>>>>
>>>
>>
>
>
