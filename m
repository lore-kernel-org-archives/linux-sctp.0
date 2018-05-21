From: Michael Tuexen <tuexen@fh-muenster.de>
Date: Mon, 21 May 2018 12:16:56 +0000
Subject: Re: [PATCH net-next] sctp: add support for SCTP_REUSE_PORT sockopt
Message-Id: <4918BFA7-18F9-4125-A7F5-2A603C692A14@fh-muenster.de>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="Apple-Mail=_5C5EAEF6-27FF-4321-9EA8-50B0179DAB74"
List-Id: <linux-sctp.vger.kernel.org>
References: <be8e672439406e6c8b838321d63aa109b9620f4c.1526715880.git.lucien.xin@gmail.com>
 <20180521005059.GA15233@neilslaptop.think-freely.org>
 <20180521015404.GI5488@localhost.localdomain>
 <20180521113939.GA17593@hmswarspite.think-freely.org>
In-Reply-To: <20180521113939.GA17593@hmswarspite.think-freely.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net


--Apple-Mail=_5C5EAEF6-27FF-4321-9EA8-50B0179DAB74
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 21. May 2018, at 13:39, Neil Horman <nhorman@tuxdriver.com> wrote:
>=20
> On Sun, May 20, 2018 at 10:54:04PM -0300, Marcelo Ricardo Leitner =
wrote:
>> On Sun, May 20, 2018 at 08:50:59PM -0400, Neil Horman wrote:
>>> On Sat, May 19, 2018 at 03:44:40PM +0800, Xin Long wrote:
>>>> This feature is actually already supported by sk->sk_reuse which =
can be
>>>> set by SO_REUSEADDR. But it's not working exactly as RFC6458 =
demands in
>>>> section 8.1.27, like:
>>>>=20
>>>>  - This option only supports one-to-one style SCTP sockets
>>>>  - This socket option must not be used after calling bind()
>>>>    or sctp_bindx().
>>>>=20
>>>> Besides, SCTP_REUSE_PORT sockopt should be provided for user's =
programs.
>>>> Otherwise, the programs with SCTP_REUSE_PORT from other systems =
will not
>>>> work in linux.
>>>>=20
>>>> This patch reuses sk->sk_reuse and works pretty much as =
SO_REUSEADDR,
>>>> just with some extra setup limitations that are neeeded when it is =
being
>>>> enabled.
>>>>=20
>>>> "It should be noted that the behavior of the socket-level socket =
option
>>>> to reuse ports and/or addresses for SCTP sockets is unspecified", =
so it
>>>> leaves SO_REUSEADDR as is for the compatibility.
>>>>=20
>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>>> ---
>>>> include/uapi/linux/sctp.h |  1 +
>>>> net/sctp/socket.c         | 48 =
+++++++++++++++++++++++++++++++++++++++++++++++
>>>> 2 files changed, 49 insertions(+)
>>>>=20
>>> A few things:
>>>=20
>>> 1) I agree with Tom, this feature is a complete duplication of the =
SK_REUSEPORT
>>> socket option.  I understand that this is an implementation of the =
option in the
>>> RFC, but its definately a duplication of a feature, which makes =
several things
>>> really messy.
>>>=20
>>> 2) The overloading of the sk_reuse opeion is a bad idea, for several =
reasons.
>>> Chief among them is the behavioral interference between this patch =
and the
>>> SO_REUSEADDR socket level option, that also sets this feature.  If =
you set
>>> sk_reuse via SO_REUSEADDR, you will set the SCTP port reuse feature =
regardless
>>> of the bind or 1:1/1:m state of the socket.  Vice versa, if you set =
this socket
>>> option via the SCTP_PORT_REUSE option you will inadvertently turn on =
address
>>> reuse for the socket.  We can't do that.
>>=20
>> Given your comments, going a bit further here, one other big
>> implication is that a port would never be able to be considered to
>> fully meet SCTP standards regarding reuse because a rogue application
>> may always abuse of the socket level opt to gain access to the port.
>>=20
>> IOW, the patch allows the application to use such restrictions =
against
>> itself and nothing else, which undermines the patch idea.
>>=20
> Agreed.
>=20
>> I lack the knowledge on why the SCTP option was proposed in the RFC. =
I
>> guess they had a good reason to add the restriction on 1:1/1:m style.
>> Does the usage of the current imply in any risk to SCTP sockets? If
>> yes, that would give some grounds for going forward with the SCTP
>> option.
>>=20
> I'm also not privy to why the sctp option was proposed, though I =
expect that the
> lack of standardization of SO_REUSEPORT probably had something to do =
with it.
> As for the reasoning behind restriction to only 1:1 sockets, if I had =
to guess,
> I would say it likely because it creates ordering difficulty at the =
application
> level.
>=20
> CC-ing Michael Tuxen, who I believe had some input on this RFC.  =
Hopefully he
> can shed some light on this.
Dear all,

the reason this was added is to have a specified way to allow a system =
to
behave like a client and server making use of the INIT collision.

For 1-to-many style sockets you can do this by creating a socket, =
binding it,
calling listen on it and trying to connect to the peer.

For 1-to-1 style sockets you need two sockets for it. One listener and =
one
you use to connect (and close it in case of failure, open a new one...).

It was not clear if one can achieve this with SO_REUSEPORT and/or =
SO_REUSEADDR
on all platforms. We left that unspecified.

I hope this makes the intention clearer.

Best regards
Michael
>=20
> Neil
>=20
>>>=20
>>> Its a bit frustrating, since SO_REUSEPORT is widely available on =
multiple
>>> operating systems, but isn't standard (AFAIK).  I would say however, =
given the
>>> prevalence of the socket level option, we should likely advocate for =
the removal
>>> of the sctp specific option, or at the least implement and document =
it as being
>>=20
>> Is it possible, to remove/deprecate an option once it is published on =
a RFC?
>>=20
>>> an alias for SO_REUSEPORT
>>>=20
>>>=20
>>> As this stands however, its a NACK from me.
>>>=20
>>> Neil
>>>=20
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_5C5EAEF6-27FF-4321-9EA8-50B0179DAB74
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQkDCCBNUw
ggO9oAMCAQICCFBOxvU9EbRkMA0GCSqGSIb3DQEBCwUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVyMSMw
IQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0xNDA3MjIxMjA4MjZaFw0xOTA3
MDkyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdE
Rk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U1wBblSJ01CDrNI/W7MAx
BAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6fL9KDhsAw4bpXCsxEXsM84Ik
Q4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869080UME/15eOkyGKbghoDJzANAmVg
Te3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqDoZRdQWvY0hD1TP3KUazZve+Sg7va64sW
VlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkhnSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjggGG
MIIBgjAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFEm3xs/oPR9/6kR7Eyn38QpwPt5kMB8GA1Ud
IwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMBIGA1UdEwEB/wQIMAYBAf8CAQIwYgYDVR0gBFsw
WTARBg8rBgEEAYGtIYIsAQEEAgIwEQYPKwYBBAGBrSGCLAEBBAMAMBEGDysGAQQBga0hgiwBAQQD
ATAPBg0rBgEEAYGtIYIsAQEEMA0GCysGAQQBga0hgiweMD4GA1UdHwQ3MDUwM6AxoC+GLWh0dHA6
Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvRFRfUk9PVF9DQV8yLmNybDB4BggrBgEFBQcBAQRsMGow
LAYIKwYBBQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMDoGCCsGAQUFBzAC
hi5odHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9EVF9ST09UX0NBXzIuY2VyMA0GCSqGSIb3
DQEBCwUAA4IBAQBjICj9nCGGcr45Rlk5MiW8qQGbDczKfUGchm0KbiyzE1l1sTOSG2EnFv/DstU1
gvuEKgFJvWa7Zi+ywgZdbj9u4wFaW8pDY1yVtuExpx/VB19N5mWCTjL5w3x6S81NXHTuIfJ1AuxS
PtLJatOQI25JZzW+f01WpOzML8+3oZeocj7JvEDWWqQIPda8gsO3tzKOsSyOam23NQIZz/U5RFhj
pyQAELC7/E6vbi84u6VXST/YblBvLJeW3B1GmmWJz67M8uXZn1OzPqEvkqnYC8aEHwTG6x7on321
e6UC8STFJGMRNMxakyAqeYg6JUKQqWU7fIbTEhUjKfws2sw5W1QXMIIFojCCBIqgAwIBAgIHF6Qk
oQlIMzANBgkqhkiG9w0BAQsFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQ
MA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTE0MDUyNzE0NTQwOVoXDTE5MDcwOTIzNTkwMFowgcYxCzAJBgNVBAYTAkRFMRwwGgYDVQQIExNO
b3JkcmhlaW4tV2VzdGZhbGVuMREwDwYDVQQHEwhNdWVuc3RlcjEgMB4GA1UEChMXRmFjaGhvY2hz
Y2h1bGUgTXVlbnN0ZXIxIzAhBgNVBAsTGkRhdGVudmVyYXJiZWl0dW5nc3plbnRyYWxlMR0wGwYD
VQQDExRGSCBNdWVuc3RlciBDQSAtIEcwMTEgMB4GCSqGSIb3DQEJARYRY2FAZmgtbXVlbnN0ZXIu
ZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4eWyu8GzsIv0iowf2v/9BT0SmCFNX
/eyQe5BncOk1j6XIlY5bnNu1S5uBe3uVgekgTh3gJyVNlaoIfCgAjqCrNJIaNQq5fr/S6L8uFeaU
O8IF/C4RH5P7f9Hn2GUueEjmJhg9CI3LBAhrfAmEEtNmuVfDycN2MjngwDNxUNRfuXbWxuhkgDqJ
0ztJeayHGhFDrGx88eyStx40xy+0c0OFWdWxzBFQlBRHnl+zRftj3c9qy6BY+/fGaA2vV1oKr3h5
X6eyU1T8YlpP1NDe4bylqAteX01sM2Qciu8UAPnNc7Sb93TQjhCFRVDIS3CdN6AOpwz5YWEld6ey
CdmFZ7pvAgMBAAGjggH+MIIB+jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjAR
BgNVHSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFArzW7zkMYDWNUKJptPDzzfe0d/XMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEWNhQGZoLW11ZW5zdGVyLmRlMIGI
BgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9w
dWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcowgccwMwYIKwYBBQUHMAGGJ2h0
dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBHBggrBgEFBQcwAoY7aHR0cDov
L2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYI
KwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQDeRwM11kpvuRIPuzWXLapr/ZBtB76V3cuF
l45x/Kx0u03yjB4GaBPcxihn4P1z5KhRYkDBMo8HXkOgbL59aF6VdOlCurEgZvghKvUkKOCyWeYx
S9rTGPBkbGiNn2ATVuLXzF8rDf50ynAIu3otstOOv+3Ifqi1pzCva1nO64khQA5Gd5/BNyu+YHbW
f8ERAf9leu5a7yVI7cv1gCZAHpWJpkUKmfawyY4sAJ2hbGZRBvdACOxrfbuMdSOzPneT2rlmvH+D
7M6DmzVabLYk6UtAxQhldd/T/qsHkWvaWXHt0Eb9STs2Fl03Ls7M3NyLQLhaeR3ysNURYcaEfaB+
lxN+MIIGDTCCBPWgAwIBAgIHG5mIdDexozANBgkqhkiG9w0BAQsFADCBxjELMAkGA1UEBhMCREUx
HDAaBgNVBAgTE05vcmRyaGVpbi1XZXN0ZmFsZW4xETAPBgNVBAcTCE11ZW5zdGVyMSAwHgYDVQQK
ExdGYWNoaG9jaHNjaHVsZSBNdWVuc3RlcjEjMCEGA1UECxMaRGF0ZW52ZXJhcmJlaXR1bmdzemVu
dHJhbGUxHTAbBgNVBAMTFEZIIE11ZW5zdGVyIENBIC0gRzAxMSAwHgYJKoZIhvcNAQkBFhFjYUBm
aC1tdWVuc3Rlci5kZTAeFw0xNjA3MDQwNzA2MTNaFw0xOTA3MDQwNzA2MTNaMHwxCzAJBgNVBAYT
AkRFMSAwHgYDVQQKDBdGYWNoaG9jaHNjaHVsZSBNdWVuc3RlcjEyMDAGA1UECwwpRmFjaGJlcmVp
Y2ggRWxla3Ryb3RlY2huaWsgdW5kIEluZm9ybWF0aWsxFzAVBgNVBAMMDk1pY2hhZWwgVHVleGVu
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzJoaUG3Zm24XxA/zNg2sbFcL56w8xqMg
+X6G7UsYec3YEncnlkw3jgE5nDefos7UVoCA7wPjFTj8AQt5xfpXElnbM45IPy5Ng7g6dS7biGSM
VRACPXe1PrjgApRAwwGmCPvALnZXkmKP6Zlf+3VLfz9YWIIaeKu3jFM2Lk6Y3gr5U1l8bjHSawOo
WMlfvSsXXLT38zKW7Uz9jS278j0OqHANBPgsE6/LJoCWFInwlvybxhO3nGU7OteUGaPikqzvjLsL
YgpHDi0WjMZfVx/UtUSzZ4EJvmJTBeuVwyKnCbrawnfwYPTQQ6VE1OkAzmsMByBbEwJ996RtG//T
XCG06QIDAQABo4ICRzCCAkMwQAYDVR0gBDkwNzARBg8rBgEEAYGtIYIsAQEEAwUwEQYPKwYBBAGB
rSGCLAIBBAMBMA8GDSsGAQQBga0hgiwBAQQwCQYDVR0TBAIwADAOBgNVHQ8BAf8EBAMCBeAwHQYD
VR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBTQHa9qhKgSZgCCAPThZkXaEaJ/
dTAfBgNVHSMEGDAWgBQK81u85DGA1jVCiabTw8833tHf1zAgBgNVHREEGTAXgRV0dWV4ZW5AZmgt
bXVlbnN0ZXIuZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2Zo
LW11ZW5zdGVyLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZu
LmRlL2ZoLW11ZW5zdGVyLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAz
BggrBgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsG
AQUFBzAChjtodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2ZoLW11ZW5zdGVyLWNhL3B1Yi9jYWNlcnQv
Y2FjZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9maC1tdWVuc3Rl
ci1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAEj2/6x4kzoCVIiu
aaminPrOHxACyoYsmSRjYPQpgW5xRj/FlolO1nG+ZZ11sqTb3TdCGD69ko5/zs8eGKnv/i0VLCHF
g1JLfpaxElN5RrR/cqRJrbzKshF9aUkBODF8vlf9BCeimMK3fifjbbWRyxHssfEECffujD7/Yvta
NYMO46Roz39lIK2s37IVFq3V5RWzUeTuwpP9t8lOxirOi9eK2OYI/dh0HjR2S5Dr9nMR1dNulrhz
jlFxGc+opefGScrRR9Ec0eqTXlbt1Q9UzNIYVS+OGZY8/bBbprwXVTmwSp8dygEULkIaMbLsaTaW
6TehuL8ousPJkL52SOENgSkxggQpMIIEJQIBATCB0jCBxjELMAkGA1UEBhMCREUxHDAaBgNVBAgT
E05vcmRyaGVpbi1XZXN0ZmFsZW4xETAPBgNVBAcTCE11ZW5zdGVyMSAwHgYDVQQKExdGYWNoaG9j
aHNjaHVsZSBNdWVuc3RlcjEjMCEGA1UECxMaRGF0ZW52ZXJhcmJlaXR1bmdzemVudHJhbGUxHTAb
BgNVBAMTFEZIIE11ZW5zdGVyIENBIC0gRzAxMSAwHgYJKoZIhvcNAQkBFhFjYUBmaC1tdWVuc3Rl
ci5kZQIHG5mIdDexozAJBgUrDgMCGgUAoIICKzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0xODA1MjExMjE2NTdaMCMGCSqGSIb3DQEJBDEWBBTdzD7LgPI+dqPmTzQ+
dVFdLeu5RjCB4wYJKwYBBAGCNxAEMYHVMIHSMIHGMQswCQYDVQQGEwJERTEcMBoGA1UECBMTTm9y
ZHJoZWluLVdlc3RmYWxlbjERMA8GA1UEBxMITXVlbnN0ZXIxIDAeBgNVBAoTF0ZhY2hob2Noc2No
dWxlIE11ZW5zdGVyMSMwIQYDVQQLExpEYXRlbnZlcmFyYmVpdHVuZ3N6ZW50cmFsZTEdMBsGA1UE
AxMURkggTXVlbnN0ZXIgQ0EgLSBHMDExIDAeBgkqhkiG9w0BCQEWEWNhQGZoLW11ZW5zdGVyLmRl
AgcbmYh0N7GjMIHlBgsqhkiG9w0BCRACCzGB1aCB0jCBxjELMAkGA1UEBhMCREUxHDAaBgNVBAgT
E05vcmRyaGVpbi1XZXN0ZmFsZW4xETAPBgNVBAcTCE11ZW5zdGVyMSAwHgYDVQQKExdGYWNoaG9j
aHNjaHVsZSBNdWVuc3RlcjEjMCEGA1UECxMaRGF0ZW52ZXJhcmJlaXR1bmdzemVudHJhbGUxHTAb
BgNVBAMTFEZIIE11ZW5zdGVyIENBIC0gRzAxMSAwHgYJKoZIhvcNAQkBFhFjYUBmaC1tdWVuc3Rl
ci5kZQIHG5mIdDexozANBgkqhkiG9w0BAQEFAASCAQCSyGAJ6CZKSItuinIVAqoJHhpM4PgvZyNa
/tQLvIeMeyPU4zxMgKwfG0iIJevQQJI49icTweGaj0EtwVeNA94CR5fPiBBTt2yUPpZRdogiKcVn
pO6ttCshymJsUAVcXDq67QCOACK7gqLC5EMBjN9TbhJ5+H+BowaHw/ujCpHDLXCbKO1HLppfmwrh
dM/K81JEjDcWdAXvzl8+7yFBPa2aAwXWkxovyA0oEhP0dI5VH0hpyi8qzKT6dxiHUr6BEuEbIArg
6elbjA/cdPBQ7VGuUxqWUrmDuVV+lEzJB3Jehm1usrBYZemkhOKrDi3Wzy3Mzi/wOoN2zTOYbmP6
66IKAAAAAAAA
--Apple-Mail=_5C5EAEF6-27FF-4321-9EA8-50B0179DAB74--
