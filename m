From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Sun, 31 Jul 2016 15:32:41 +0000
Subject: Re: sctp and tail loss recovery
Message-Id: <FFECB010-3C46-49DB-9F04-51FE71FFC26A@fh-muenster.de>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="Apple-Mail=_90B19AA5-689D-4DC8-90A4-9AC4019725A4"
List-Id: <linux-sctp.vger.kernel.org>
References: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
In-Reply-To: <0593f8d4-2302-a5c3-62cb-1fe6f1e53005@gmail.com>
To: linux-sctp@vger.kernel.org


--Apple-Mail=_90B19AA5-689D-4DC8-90A4-9AC4019725A4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 28 Jul 2016, at 21:06, Marcelo Ricardo Leitner =
<marcelo.leitner@gmail.com> wrote:
>=20
> On Sat, Jul 02, 2016 at 03:11:55PM +0200, Michael Tuexen wrote:
>>> On 30 Jun 2016, at 21:18, Marcelo Ricardo Leitner =
<marcelo.leitner@gmail.com> wrote:
>>>=20
>>> Hi Michael,
>>>=20
>>> Long story short, I'm chasing a performance issue on linux =
implementation and I think that TLR is the right fix for it. The receive =
operation is way more expensive than transmit and this causes its buffer =
to fill up, up to reach 0 window situation. Then, as the RFC allows, =
sender keeps sending 1 data chunk at a time, as a probe for possible =
unnoticed window updates due to SACK loss. But if the peer couldn't free =
any window in time, it will drop that chunk, and will cause a RTO.
>> OK.
>>=20
>> So I think there a better handling of SWS might help:
>>=20
>> What method of SWS does Linux use on the receiver side? On FreeBSD we =
announce the a_rwnd as
>=20
> Sorry the delay Michael, I wanted to re-read the code on this.
No problem...
>=20
> We don't do much, sender or receiver side.
>=20
> We will accept data and reduce a_rwnd accordingly, till it reaches 0.
> Then we keep announcing as 0 while allowing some overshoot.
>=20
> When some space is freed, we will only announce it if it's bigger than =
a
> threshold. But if we have to bundle a sack, we will also update it,
> regardless of a threshold. Hmm now writting the email seems that this
> update on bundled sack should also respect the threshold.=20
FreeBSD announces its receive buffer until is goes below a threshold. =
Than
it announces 1 byte (to speed down the sender but still allow for =
accepting
new data). Only if the buffer is really full, 0 is announced.
For each received messages some overhead is also considered. This is all
receiver side.
If you end up in this situation you will be at one chunk per RTT...
>=20
>> is actually is until it is less that a threshold. Then we announce =
a_rwnd =3D 1. This slows
>> down the sender but still allow the receiver to accept the data. This =
does avoid an RTO.
>=20
> On RFC 4960, it says:
>=20
> 6.1.  Transmission of DATA Chunks
> ...
>   A) At any given time, the data sender MUST NOT transmit new data to
>      any destination transport address if its peer's rwnd indicates
>      that the peer has no buffer space (i.e., rwnd is 0; see Section
>      6.2.1).  However, regardless of the value of rwnd (including if =
it
>      is 0), the data sender can always have one DATA chunk in flight =
to
>      the receiver if allowed by cwnd (see rule B, below).  This rule
>      allows the sender to probe for a change in rwnd that the sender
>      missed due to the SACK's having been lost in transit from the =
data
>      receiver to the data sender.
>=20
> it's saying the sender *can* send a chunk at any given time, but not
> meaning that it should abuse of that. Now I'm thinking, this is our
> problem, and that's why it's enough to slow down your sender:
>=20
> We don't really respect the 0 window situation. The only difference is
> that we start sending chunk by chunk, regardless of their
> interval/a_rwnd, because "the data sender can always have one DATA =
chunk
> in flight to the receiver if allowed by cwnd". Then a packet drop
> happens, as the window is very overshot already, and the sender won't
> retransmit even after the window update because there was a packet =
drop.
In FreeBSD using the 1 bytes instead of some small higher number allows
us to still accept data and make progress while slowing down the sender.
I guess this is important in this scenario.
>=20
> So after sending the first chunk in 0-window situation, if the reply
> still comes with 0-window, we should not send a new chunk, but wait =
for
> either the window update or RTO. If we keep hammering it, the receiver
> will have a harder time to re-open the window, and we have a SWS =
issue.
You need to do window probing. But it should become timer driven, since
the SACK can get lost.

Best regards
Michael
>=20
> We do it like "Are we there yet? Are we there yet? Are we there yet?"
> </donkey, shrek movie> hehe ;-)
>=20
> Makes sense?
>=20
>>>=20
>>> I'm not seeing anything in the specs that would prevent this =
situation other than a TLR would do. Or I missed it?
>> I would think that TLR is trying to address the case where a packet =
at the end of a batch is lost
>> due to congestion in the network.
>=20
> Agreed. Better thinking, even if TLP would help it, it's not the right
> fix, as it would be same as saying that some packet drops are =
expected.
>=20
> Thanks,
> Marcelo
>=20
>>=20
>> Best regards
>> Michael
>>>=20
>>> On TLR, the most updated info I could find, is already (recently) =
expired and archived: =
https://datatracker.ietf.org/doc/draft-nielsen-tsvwg-sctp-tlr/
>>> I could find Karen's email =
https://www.ietf.org/mail-archive/web/tsvwg/current/msg13703.html
>>> But then nothing else. Do you know what happened?
>>>=20
>>> Thanks,
>>> Marcelo
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20


--Apple-Mail=_90B19AA5-689D-4DC8-90A4-9AC4019725A4
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPjjCCBCEw
ggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNEZXV0
c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVyMSMwIQYDVQQD
ExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBaFw0xOTA2MzAyMzU5
MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJ
MSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U1wBblSJ01CDrNI/W7MAxBAuZgeKm
FNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItq
aACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869080UME/15eOkyGKbghoDJzANAmVgTe3RCSMq
ljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqDoZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HV
Ez2mHycwzUlU28kTNJpxdcVs6qcLmPkhnSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYD
VR0fBGkwZzBloGOgYYZfaHR0cDovL3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9E
b3dubG9hZEFSTC5jcmw/LWNybF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYD
VR0OBBYEFEm3xs/oPR9/6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqz
K50zMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IB
AQA74Vp3wEgX3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvh
ERHua3iRM347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0J
a6bahWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyHxQoL
BzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFVDCCBDygAwIBAgIEC4s0BzANBgkqhkiG
9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4GA1UECxMHREZO
LVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4XDTA3MTIyMTEyNTAw
MVoXDTE5MDYzMDAwMDAwMFowgcYxCzAJBgNVBAYTAkRFMRwwGgYDVQQIExNOb3JkcmhlaW4tV2Vz
dGZhbGVuMREwDwYDVQQHEwhNdWVuc3RlcjEgMB4GA1UEChMXRmFjaGhvY2hzY2h1bGUgTXVlbnN0
ZXIxIzAhBgNVBAsTGkRhdGVudmVyYXJiZWl0dW5nc3plbnRyYWxlMR0wGwYDVQQDExRGSCBNdWVu
c3RlciBDQSAtIEcwMTEgMB4GCSqGSIb3DQEJARYRY2FAZmgtbXVlbnN0ZXIuZGUwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4eWyu8GzsIv0iowf2v/9BT0SmCFNX/eyQe5BncOk1j6XI
lY5bnNu1S5uBe3uVgekgTh3gJyVNlaoIfCgAjqCrNJIaNQq5fr/S6L8uFeaUO8IF/C4RH5P7f9Hn
2GUueEjmJhg9CI3LBAhrfAmEEtNmuVfDycN2MjngwDNxUNRfuXbWxuhkgDqJ0ztJeayHGhFDrGx8
8eyStx40xy+0c0OFWdWxzBFQlBRHnl+zRftj3c9qy6BY+/fGaA2vV1oKr3h5X6eyU1T8YlpP1NDe
4bylqAteX01sM2Qciu8UAPnNc7Sb93TQjhCFRVDIS3CdN6AOpwz5YWEld6eyCdmFZ7pvAgMBAAGj
ggGzMIIBrzASBgNVHRMBAf8ECDAGAQH/AgEBMAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQUCvNbvOQx
gNY1Qomm08PPN97R39cwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUw
E4ERY2FAZmgtbXVlbnN0ZXIuZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2Eu
ZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2Rw
Mi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcB
AQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4u
ZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IB
AQCo2aYdGZmn8f2ODuDAB383ilspAMdtncufyUcT23x64U+pxaSC7ZChBrTg70XxsidIv/eH6OCY
ZUKUV8snbXzwXIPkLx5JrKpVcFeEA/wU92YT410fxngXCKXjPtd1QujcEih20Nr5R1GGbMc18YnS
5oOJtYI+/ZfXS9ko5wUFi1ZR5JbUU8R3itGG5EUB5QY93t1KqQSd2waJ/qOpyvqOVw6UYq6Xbbre
u1n2LVl1XqgwF2Wr5lv2q9Mm0xFQGHounHVtn7TIAb2a8cbLfRJ/9WxoWCBM91NvhimBfsM9T04b
E6IA2PnglDTBMmediFqIW8MP/JK5tTJe8Tguvq2NMIIGDTCCBPWgAwIBAgIHG5mIdDexozANBgkq
hkiG9w0BAQsFADCBxjELMAkGA1UEBhMCREUxHDAaBgNVBAgTE05vcmRyaGVpbi1XZXN0ZmFsZW4x
ETAPBgNVBAcTCE11ZW5zdGVyMSAwHgYDVQQKExdGYWNoaG9jaHNjaHVsZSBNdWVuc3RlcjEjMCEG
A1UECxMaRGF0ZW52ZXJhcmJlaXR1bmdzemVudHJhbGUxHTAbBgNVBAMTFEZIIE11ZW5zdGVyIENB
IC0gRzAxMSAwHgYJKoZIhvcNAQkBFhFjYUBmaC1tdWVuc3Rlci5kZTAeFw0xNjA3MDQwNzA2MTNa
Fw0xOTA3MDQwNzA2MTNaMHwxCzAJBgNVBAYTAkRFMSAwHgYDVQQKDBdGYWNoaG9jaHNjaHVsZSBN
dWVuc3RlcjEyMDAGA1UECwwpRmFjaGJlcmVpY2ggRWxla3Ryb3RlY2huaWsgdW5kIEluZm9ybWF0
aWsxFzAVBgNVBAMMDk1pY2hhZWwgVHVleGVuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAzJoaUG3Zm24XxA/zNg2sbFcL56w8xqMg+X6G7UsYec3YEncnlkw3jgE5nDefos7UVoCA7wPj
FTj8AQt5xfpXElnbM45IPy5Ng7g6dS7biGSMVRACPXe1PrjgApRAwwGmCPvALnZXkmKP6Zlf+3VL
fz9YWIIaeKu3jFM2Lk6Y3gr5U1l8bjHSawOoWMlfvSsXXLT38zKW7Uz9jS278j0OqHANBPgsE6/L
JoCWFInwlvybxhO3nGU7OteUGaPikqzvjLsLYgpHDi0WjMZfVx/UtUSzZ4EJvmJTBeuVwyKnCbra
wnfwYPTQQ6VE1OkAzmsMByBbEwJ996RtG//TXCG06QIDAQABo4ICRzCCAkMwQAYDVR0gBDkwNzAR
Bg8rBgEEAYGtIYIsAQEEAwUwEQYPKwYBBAGBrSGCLAIBBAMBMA8GDSsGAQQBga0hgiwBAQQwCQYD
VR0TBAIwADAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0G
A1UdDgQWBBTQHa9qhKgSZgCCAPThZkXaEaJ/dTAfBgNVHSMEGDAWgBQK81u85DGA1jVCiabTw883
3tHf1zAgBgNVHREEGTAXgRV0dWV4ZW5AZmgtbXVlbnN0ZXIuZGUwgYgGA1UdHwSBgDB+MD2gO6A5
hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2ZoLW11ZW5zdGVyLWNhL3B1Yi9jcmwvY2FjcmwuY3Js
MD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ZoLW11ZW5zdGVyLWNhL3B1Yi9jcmwvY2Fj
cmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggrBgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRm
bi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L2ZoLW11ZW5zdGVyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDov
L2NkcDIucGNhLmRmbi5kZS9maC1tdWVuc3Rlci1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJ
KoZIhvcNAQELBQADggEBAEj2/6x4kzoCVIiuaaminPrOHxACyoYsmSRjYPQpgW5xRj/FlolO1nG+
ZZ11sqTb3TdCGD69ko5/zs8eGKnv/i0VLCHFg1JLfpaxElN5RrR/cqRJrbzKshF9aUkBODF8vlf9
BCeimMK3fifjbbWRyxHssfEECffujD7/YvtaNYMO46Roz39lIK2s37IVFq3V5RWzUeTuwpP9t8lO
xirOi9eK2OYI/dh0HjR2S5Dr9nMR1dNulrhzjlFxGc+opefGScrRR9Ec0eqTXlbt1Q9UzNIYVS+O
GZY8/bBbprwXVTmwSp8dygEULkIaMbLsaTaW6TehuL8ousPJkL52SOENgSkxggQpMIIEJQIBATCB
0jCBxjELMAkGA1UEBhMCREUxHDAaBgNVBAgTE05vcmRyaGVpbi1XZXN0ZmFsZW4xETAPBgNVBAcT
CE11ZW5zdGVyMSAwHgYDVQQKExdGYWNoaG9jaHNjaHVsZSBNdWVuc3RlcjEjMCEGA1UECxMaRGF0
ZW52ZXJhcmJlaXR1bmdzemVudHJhbGUxHTAbBgNVBAMTFEZIIE11ZW5zdGVyIENBIC0gRzAxMSAw
HgYJKoZIhvcNAQkBFhFjYUBmaC1tdWVuc3Rlci5kZQIHG5mIdDexozAJBgUrDgMCGgUAoIICKzAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjA3MzExNTMyNDFaMCMG
CSqGSIb3DQEJBDEWBBTD+wFYEv59LU3lNHLMl6HvUMdU2zCB4wYJKwYBBAGCNxAEMYHVMIHSMIHG
MQswCQYDVQQGEwJERTEcMBoGA1UECBMTTm9yZHJoZWluLVdlc3RmYWxlbjERMA8GA1UEBxMITXVl
bnN0ZXIxIDAeBgNVBAoTF0ZhY2hob2Noc2NodWxlIE11ZW5zdGVyMSMwIQYDVQQLExpEYXRlbnZl
cmFyYmVpdHVuZ3N6ZW50cmFsZTEdMBsGA1UEAxMURkggTXVlbnN0ZXIgQ0EgLSBHMDExIDAeBgkq
hkiG9w0BCQEWEWNhQGZoLW11ZW5zdGVyLmRlAgcbmYh0N7GjMIHlBgsqhkiG9w0BCRACCzGB1aCB
0jCBxjELMAkGA1UEBhMCREUxHDAaBgNVBAgTE05vcmRyaGVpbi1XZXN0ZmFsZW4xETAPBgNVBAcT
CE11ZW5zdGVyMSAwHgYDVQQKExdGYWNoaG9jaHNjaHVsZSBNdWVuc3RlcjEjMCEGA1UECxMaRGF0
ZW52ZXJhcmJlaXR1bmdzemVudHJhbGUxHTAbBgNVBAMTFEZIIE11ZW5zdGVyIENBIC0gRzAxMSAw
HgYJKoZIhvcNAQkBFhFjYUBmaC1tdWVuc3Rlci5kZQIHG5mIdDexozANBgkqhkiG9w0BAQEFAASC
AQA2qEuAV8Tm1whtY1zud6up31pgYleetA6Hy2tytzu35AlzhLKngO7V8cf7ue8tGin+cWYtOrC6
1tQnxisVSn1CoysFcDldQunZlSkGYbL99g8SBNdNX/WFZ3XGHSzyl3nJrZau2yz6nCrzVaTrCM+3
3oHyZ0x4C0wwBOYaBLbBLeMAMkc7NlKbSb3c8HWfn/Nm++XhcPgGgv15hGRlHPmxjfRPNAsYqN57
XmIuHnCKI9hSAt14fumT1qVN0edIqEz5RngxQpzupllgcmRKJQKtVlUuhrqeBJZhe0iSpq8TWIEe
pTI+WQ7PMD0W2A6Yk+7FUQF6Mb1XO2kNd6aJU2+nAAAAAAAA
--Apple-Mail=_90B19AA5-689D-4DC8-90A4-9AC4019725A4--
