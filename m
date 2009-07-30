From: Rami Rosen <rosenrami@gmail.com>
Date: Thu, 30 Jul 2009 06:38:43 +0000
Subject: [PATCH] sctp: remove unused union (sctp_cmsg_data_t) definition .
Message-Id: <ae5426fb0907292338v681057cct86408a8c7478d15e@mail.gmail.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="00504502ddc61a40a6046fe68e10"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

--00504502ddc61a40a6046fe68e10
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,
This patch removes an unused union definition (sctp_cmsg_data_t)
from include/net/sctp/user.h.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <rosenrami@gmail.com>

--00504502ddc61a40a6046fe68e10
Content-Type: text/plain; charset=US-ASCII; name="patch.txt"
Content-Disposition: attachment; filename="patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fxr43z790

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjdHAvdXNlci5oIGIvaW5jbHVkZS9uZXQvc2N0cC91
c2VyLmgKaW5kZXggMTU4MGMwNC4uYmUyMzM0YSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvc2N0
cC91c2VyLmgKKysrIGIvaW5jbHVkZS9uZXQvc2N0cC91c2VyLmgKQEAgLTIxMCwxMiArMjEwLDYg
QEAgZW51bSBzY3RwX3NpbmZvX2ZsYWdzIHsKIH07CiAKIAotdHlwZWRlZiB1bmlvbiB7Ci0JX191
OCAgIAkJCXJhdzsKLQlzdHJ1Y3Qgc2N0cF9pbml0bXNnCWluaXQ7Ci0Jc3RydWN0IHNjdHBfc25k
cmN2aW5mbwlzbmRyY3Y7Ci19IHNjdHBfY21zZ19kYXRhX3Q7Ci0KIC8qIFRoZXNlIGFyZSBjbXNn
X3R5cGVzLiAgKi8KIHR5cGVkZWYgZW51bSBzY3RwX2Ntc2dfdHlwZSB7CiAJU0NUUF9JTklULCAg
ICAgICAgICAgICAgLyogNS4yLjEgU0NUUCBJbml0aWF0aW9uIFN0cnVjdHVyZSAqLwo=
--00504502ddc61a40a6046fe68e10--
