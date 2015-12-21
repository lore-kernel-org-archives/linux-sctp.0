From: Sun Paul <paulrbk@gmail.com>
Date: Mon, 21 Dec 2015 02:09:32 +0000
Subject: Is SO_REUSEADDR option available for SCTP?
Message-Id: <CAFXGftL+F2F3vaYTCoLnWLAUC3ZQYEsJTRy93AS+xtOPSMWGkA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi

we have running in trouble in bind the port when the SCTP application
is stopped and then started, we got the "Address already in use".

we would like to know whether SO_REUSEADDR option available for SCTP?

if yes, is it also available for the java socket API?

Thanks

RBK
