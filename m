From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Fri, 26 Apr 2019 12:33:05 +0000
Subject: Re: Few Questions About SCTP NAT
Message-Id: <4C7041B8-57B9-4A2C-A381-EC42BE1F168C@fh-muenster.de>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="Apple-Mail=_B4002844-37C9-43C4-AEB7-FE633FBEA156"
List-Id: <linux-sctp.vger.kernel.org>
References: <CADvbK_f22Xy_ZA-Ro1wXk-0GTyPo4jr7MocvZSfdwPk3r0YWag@mail.gmail.com>
In-Reply-To: <CADvbK_f22Xy_ZA-Ro1wXk-0GTyPo4jr7MocvZSfdwPk3r0YWag@mail.gmail.com>
To: linux-sctp@vger.kernel.org


--Apple-Mail=_B4002844-37C9-43C4-AEB7-FE633FBEA156
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

> On 25. Apr 2019, at 13:46, Xin Long <lucien.xin@gmail.com> wrote:
> 
> Sorry, seems I sent to the wrong email address.
> use tuexen@fh-muenster.de instead.
... I'm typically more responsive on this address than on the one
I use for mailing lists...
> 
> On Sat, Apr 20, 2019 at 6:45 PM Xin Long <lucien.xin@gmail.com> wrote:
>> 
>> cc'ing linux-sctp.
>> 
>> On Sat, Apr 20, 2019 at 4:24 PM Xin Long <lucien.xin@gmail.com> wrote:
>>> 
>>> Hi, Michael,
>>> 
>>> I'm trying to implement SCTP NAT
>>> (https://tools.ietf.org/html/draft-ietf-tsvwg-natsupp-12) on linux,
>>> but got some questions:
>>> 
>>> 1.
>>>                        +-------+
>>>               /--------| NAT 1 |--------\       /--\/--\
>>>   +------+   /         +-------+         \     /        \    +--------+
>>>   | Host |===                             ====| Internet |===| Host B |
>>>   |   A  |   \         +-------+         /     \        /    +--------+
>>>   +------+    \--------| NAT 2 |--------/       \--/\--/
>>>                        +-------+
>>> 
>>> In this topo, after 4 shake-hands and asconf:
>>> 
>>>          +---------+--------+----------+--------+-----------+
>>>   NAT 1  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>>>          +---------+--------+----------+--------+-----------+
>>>          |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
>>>          +---------+--------+----------+--------+-----------+
>>> 
>>>          +---------+--------+----------+--------+-----------+
>>>   NAT 2  |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>>>          +---------+--------+----------+--------+-----------+
>>>          |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
>>>          +---------+--------+----------+--------+-----------+
>>> 
>>> Now there are 1 entry on nat1 and 1 entry on nat2. If the connection is
>>> shutdown via nat1, the entry on nat1 will be deleted, right? What about
>>> the entry on nat2, when can it be deleted?
Deletion of state is purely timer based. This applies to NAT1 and NAT2.
>>> 
>>> 2.
>>>                                            /--\/--\
>>>   +--------+              +-----+         /        \         +--------+
>>>   | Host A | <----------> | NAT | <----> | Internet | <----> | Host B |
>>>   +--------+              +-----+         \        /         +--------+
>>>                                            \--/\--/
>>> 
>>> In this topo,  if both paths with saddr 10.0.0.1 and 10.1.0.1 go through
>>> NAT, will there be 2 entries created on this NAT after 4 shake-hands and
>>> asconf like:
>>> 
>>>          +---------+--------+----------+--------+-----------+
>>>   NAT    |  Int    |  Int   |   Ext    |   Ext  |    Priv   |
>>>          |  VTag   |  Port  |   VTag   |   Port |    Addr   |
>>>          +---------+--------+----------+--------+-----------+
>>>          |  1234   |    1   |    5678  |    2   |  10.0.0.1 |
>>>          +---------+--------+----------+--------+-----------+
>>>          |  1234   |    1   |    5678  |    2   |  10.1.0.1 |
>>>          +---------+--------+----------+--------+-----------+
>>> 
>>> or it will be handled as "Internal Port Number and Verification Tag
>>> Collisions"?
Which section are you referring to?
>>> 
>>> 3.
>>> For multipath, each entry for one path should maintain a 'state', like
>>> closed, established, cookie-echo etc, right?  If they belong to a same
>>> association, especially when they're on different nats, how do we keep
>>> each entry's state consistent? or they don't have to be consistent?
You don't need such a state as long as you delete state purely timer based.
>>> 
>>> Thanks.


--Apple-Mail=_B4002844-37C9-43C4-AEB7-FE633FBEA156
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEJAw
ggTVMIIDvaADAgECAghQTsb1PRG0ZDANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEcMBoG
A1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0IENlbnRl
cjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwNzIyMTIwODI2WhcN
MTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4GA1UE
CxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1PWLpbkztlNcAW5UidNQg6zSP
1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXstkEXQ7aAAeny/Sg4bAMOG6VwrMRF7
DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QPwQmi9mvOvdPNFDBP9eXjpMhim4IaAycw
DQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO7
2uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXFbOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQAB
o4IBhjCCAYIwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAf
BgNVHSMEGDAWgBQxw3kbuvVT1xfgiXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMGIGA1Ud
IARbMFkwEQYPKwYBBAGBrSGCLAEBBAICMBEGDysGAQQBga0hgiwBAQQDADARBg8rBgEEAYGtIYIs
AQEEAwEwDwYNKwYBBAGBrSGCLAEBBDANBgsrBgEEAYGtIYIsHjA+BgNVHR8ENzA1MDOgMaAvhi1o
dHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweAYIKwYBBQUHAQEE
bDBqMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA6BggrBgEF
BQcwAoYuaHR0cDovL3BraTAzMzYudGVsZXNlYy5kZS9jcnQvRFRfUk9PVF9DQV8yLmNlcjANBgkq
hkiG9w0BAQsFAAOCAQEAYyAo/ZwhhnK+OUZZOTIlvKkBmw3Myn1BnIZtCm4ssxNZdbEzkhthJxb/
w7LVNYL7hCoBSb1mu2YvssIGXW4/buMBWlvKQ2NclbbhMacf1QdfTeZlgk4y+cN8ekvNTVx07iHy
dQLsUj7SyWrTkCNuSWc1vn9NVqTszC/Pt6GXqHI+ybxA1lqkCD3WvILDt7cyjrEsjmpttzUCGc/1
OURYY6ckABCwu/xOr24vOLulV0k/2G5QbyyXltwdRpplic+uzPLl2Z9Tsz6hL5Kp2AvGhB8Exuse
6J99tXulAvEkxSRjETTMWpMgKnmIOiVCkKllO3yG0xIVIyn8LNrMOVtUFzCCBaIwggSKoAMCAQIC
BxekJKEJSDMwDQYJKoZIhvcNAQELBQAwWjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkRGTi1WZXJl
aW4xEDAOBgNVBAsTB0RGTi1QS0kxJDAiBgNVBAMTG0RGTi1WZXJlaW4gUENBIEdsb2JhbCAtIEcw
MTAeFw0xNDA1MjcxNDU0MDlaFw0xOTA3MDkyMzU5MDBaMIHGMQswCQYDVQQGEwJERTEcMBoGA1UE
CBMTTm9yZHJoZWluLVdlc3RmYWxlbjERMA8GA1UEBxMITXVlbnN0ZXIxIDAeBgNVBAoTF0ZhY2ho
b2Noc2NodWxlIE11ZW5zdGVyMSMwIQYDVQQLExpEYXRlbnZlcmFyYmVpdHVuZ3N6ZW50cmFsZTEd
MBsGA1UEAxMURkggTXVlbnN0ZXIgQ0EgLSBHMDExIDAeBgkqhkiG9w0BCQEWEWNhQGZoLW11ZW5z
dGVyLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuHlsrvBs7CL9IqMH9r//QU9E
pghTV/3skHuQZ3DpNY+lyJWOW5zbtUubgXt7lYHpIE4d4CclTZWqCHwoAI6gqzSSGjUKuX6/0ui/
LhXmlDvCBfwuER+T+3/R59hlLnhI5iYYPQiNywQIa3wJhBLTZrlXw8nDdjI54MAzcVDUX7l21sbo
ZIA6idM7SXmshxoRQ6xsfPHskrceNMcvtHNDhVnVscwRUJQUR55fs0X7Y93PasugWPv3xmgNr1da
Cq94eV+nslNU/GJaT9TQ3uG8pagLXl9NbDNkHIrvFAD5zXO0m/d00I4QhUVQyEtwnTegDqcM+WFh
JXensgnZhWe6bwIDAQABo4IB/jCCAfowEgYDVR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMC
AQYwEQYDVR0gBAowCDAGBgRVHSAAMB0GA1UdDgQWBBQK81u85DGA1jVCiabTw8833tHf1zAfBgNV
HSMEGDAWgBRJt8bP6D0ff+pEexMp9/EKcD7eZDAcBgNVHREEFTATgRFjYUBmaC1tdWVuc3Rlci5k
ZTCBiAYDVR0fBIGAMH4wPaA7oDmGN2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3Qt
Y2EvcHViL2NybC9jYWNybC5jcmwwPaA7oDmGN2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFs
LXJvb3QtY2EvcHViL2NybC9jYWNybC5jcmwwgdcGCCsGAQUFBwEBBIHKMIHHMDMGCCsGAQUFBzAB
hidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0
dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9j
YWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEA3kcDNdZKb7kSD7s1ly2qa/2QbQe+
ld3LhZeOcfysdLtN8oweBmgT3MYoZ+D9c+SoUWJAwTKPB15DoGy+fWhelXTpQrqxIGb4ISr1JCjg
slnmMUva0xjwZGxojZ9gE1bi18xfKw3+dMpwCLt6LbLTjr/tyH6otacwr2tZzuuJIUAORnefwTcr
vmB21n/BEQH/ZXruWu8lSO3L9YAmQB6ViaZFCpn2sMmOLACdoWxmUQb3QAjsa327jHUjsz53k9q5
Zrx/g+zOg5s1Wmy2JOlLQMUIZXXf0/6rB5Fr2llx7dBG/Uk7NhZdNy7OzNzci0C4Wnkd8rDVEWHG
hH2gfpcTfjCCBg0wggT1oAMCAQICBxuZiHQ3saMwDQYJKoZIhvcNAQELBQAwgcYxCzAJBgNVBAYT
AkRFMRwwGgYDVQQIExNOb3JkcmhlaW4tV2VzdGZhbGVuMREwDwYDVQQHEwhNdWVuc3RlcjEgMB4G
A1UEChMXRmFjaGhvY2hzY2h1bGUgTXVlbnN0ZXIxIzAhBgNVBAsTGkRhdGVudmVyYXJiZWl0dW5n
c3plbnRyYWxlMR0wGwYDVQQDExRGSCBNdWVuc3RlciBDQSAtIEcwMTEgMB4GCSqGSIb3DQEJARYR
Y2FAZmgtbXVlbnN0ZXIuZGUwHhcNMTYwNzA0MDcwNjEzWhcNMTkwNzA0MDcwNjEzWjB8MQswCQYD
VQQGEwJERTEgMB4GA1UECgwXRmFjaGhvY2hzY2h1bGUgTXVlbnN0ZXIxMjAwBgNVBAsMKUZhY2hi
ZXJlaWNoIEVsZWt0cm90ZWNobmlrIHVuZCBJbmZvcm1hdGlrMRcwFQYDVQQDDA5NaWNoYWVsIFR1
ZXhlbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMyaGlBt2ZtuF8QP8zYNrGxXC+es
PMajIPl+hu1LGHnN2BJ3J5ZMN44BOZw3n6LO1FaAgO8D4xU4/AELecX6VxJZ2zOOSD8uTYO4OnUu
24hkjFUQAj13tT644AKUQMMBpgj7wC52V5Jij+mZX/t1S38/WFiCGnirt4xTNi5OmN4K+VNZfG4x
0msDqFjJX70rF1y09/Mylu1M/Y0tu/I9DqhwDQT4LBOvyyaAlhSJ8Jb8m8YTt5xlOzrXlBmj4pKs
74y7C2IKRw4tFozGX1cf1LVEs2eBCb5iUwXrlcMipwm62sJ38GD00EOlRNTpAM5rDAcgWxMCffek
bRv/01whtOkCAwEAAaOCAkcwggJDMEAGA1UdIAQ5MDcwEQYPKwYBBAGBrSGCLAEBBAMFMBEGDysG
AQQBga0hgiwCAQQDATAPBg0rBgEEAYGtIYIsAQEEMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgXg
MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU0B2vaoSoEmYAggD04WZF
2hGif3UwHwYDVR0jBBgwFoAUCvNbvOQxgNY1Qomm08PPN97R39cwIAYDVR0RBBkwF4EVdHVleGVu
QGZoLW11ZW5zdGVyLmRlMIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5k
ZS9maC1tdWVuc3Rlci1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNh
LmRmbi5kZS9maC1tdWVuc3Rlci1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcow
gccwMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBH
BggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9maC1tdWVuc3Rlci1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZmgtbXVl
bnN0ZXItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBI9v+seJM6
AlSIrmmpopz6zh8QAsqGLJkkY2D0KYFucUY/xZaJTtZxvmWddbKk2903Qhg+vZKOf87PHhip7/4t
FSwhxYNSS36WsRJTeUa0f3KkSa28yrIRfWlJATgxfL5X/QQnopjCt34n4221kcsR7LHxBAn37ow+
/2L7WjWDDuOkaM9/ZSCtrN+yFRat1eUVs1Hk7sKT/bfJTsYqzovXitjmCP3YdB40dkuQ6/ZzEdXT
bpa4c45RcRnPqKXnxknK0UfRHNHqk15W7dUPVMzSGFUvjhmWPP2wW6a8F1U5sEqfHcoBFC5CGjGy
7Gk2luk3obi/KLrDyZC+dkjhDYEpMYIEOTCCBDUCAQEwgdIwgcYxCzAJBgNVBAYTAkRFMRwwGgYD
VQQIExNOb3JkcmhlaW4tV2VzdGZhbGVuMREwDwYDVQQHEwhNdWVuc3RlcjEgMB4GA1UEChMXRmFj
aGhvY2hzY2h1bGUgTXVlbnN0ZXIxIzAhBgNVBAsTGkRhdGVudmVyYXJiZWl0dW5nc3plbnRyYWxl
MR0wGwYDVQQDExRGSCBNdWVuc3RlciBDQSAtIEcwMTEgMB4GCSqGSIb3DQEJARYRY2FAZmgtbXVl
bnN0ZXIuZGUCBxuZiHQ3saMwDQYJYIZIAWUDBAIBBQCgggI3MBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDQyNjEyMzMwNlowLwYJKoZIhvcNAQkEMSIEIP1g9q/A
nPO1SEQHel6ZALjgavHc4tZ9afVziqKOwAt6MIHjBgkrBgEEAYI3EAQxgdUwgdIwgcYxCzAJBgNV
BAYTAkRFMRwwGgYDVQQIExNOb3JkcmhlaW4tV2VzdGZhbGVuMREwDwYDVQQHEwhNdWVuc3RlcjEg
MB4GA1UEChMXRmFjaGhvY2hzY2h1bGUgTXVlbnN0ZXIxIzAhBgNVBAsTGkRhdGVudmVyYXJiZWl0
dW5nc3plbnRyYWxlMR0wGwYDVQQDExRGSCBNdWVuc3RlciBDQSAtIEcwMTEgMB4GCSqGSIb3DQEJ
ARYRY2FAZmgtbXVlbnN0ZXIuZGUCBxuZiHQ3saMwgeUGCyqGSIb3DQEJEAILMYHVoIHSMIHGMQsw
CQYDVQQGEwJERTEcMBoGA1UECBMTTm9yZHJoZWluLVdlc3RmYWxlbjERMA8GA1UEBxMITXVlbnN0
ZXIxIDAeBgNVBAoTF0ZhY2hob2Noc2NodWxlIE11ZW5zdGVyMSMwIQYDVQQLExpEYXRlbnZlcmFy
YmVpdHVuZ3N6ZW50cmFsZTEdMBsGA1UEAxMURkggTXVlbnN0ZXIgQ0EgLSBHMDExIDAeBgkqhkiG
9w0BCQEWEWNhQGZoLW11ZW5zdGVyLmRlAgcbmYh0N7GjMA0GCSqGSIb3DQEBAQUABIIBALVWmYDx
U/FX0/ohepBXgTKas4rDoMsXH6Q6BhsKhFbD7Al2DNktO/DvJuZjbJxLKObm4/+XxHqt8TMORWli
Fo0NoR0xXIJeXgbU8PvwQH4oKNWUyd81l2lIZnou28Q1SgcvlI+b66m7eCus893mtnuwSMOFwfZS
R5jXiyjm6a0w7CrjHEbiC2DaAsTK+cdsvyPeHGEtfoJq20PlmIRrbxTTmH6niR3djin99POUm9R4
yf0fjH704VKisuQTrvt2DBtnSMKCfl2t1BeEdQq+Yn+i02mT/W3CDtiLz6SkMnJ4yO38s0/RiRMe
8ZyV4WALD/iD9hBaIHxnoC8uz//np3YAAAAAAAA=
--Apple-Mail=_B4002844-37C9-43C4-AEB7-FE633FBEA156--
