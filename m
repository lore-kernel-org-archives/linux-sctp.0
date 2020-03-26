From: "Mao, Jinhui (NSB - CN/Hangzhou)" <jinhui.mao@nokia-sbell.com>
Date: Thu, 26 Mar 2020 05:22:46 +0000
Subject: One question regarding the SCTP write buffer free mechanism
Message-Id: <9f7ef2f9a93b420c915a9e130356cdfa@nokia-sbell.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Dear Linux SCTP experts. 

Recently we found a SCTP problem in our product, the scenario can be described as follow

Endpoint A                                                                                     Endpoint Z 
{App sends 3 messages; strm 0} DATA [TSN=6] ---------------> (ack) 
                                                     DATA [TSN=7] ---------------> (lost)
                                                     DATA [TSN=8] ---------------> (gap detected,immediately send ack)
                                                                                              /----- SACK [TSN Ack=6,Block=1, Start=2,End=2]
                                                                                    <-----/ 
                                                                                     ......
                                                   DATA [TSN] ---------------> (gap detected,immediately send ack)
                                                                                               /----- SACK [TSN Ack=6,Block=1, Start=2,End=4]
                                                                                    <-----/       (3 SACK to indicate that TSN=7 lost, fast re-trans triggered)
                                       Re-trans DATA [TSN=7] ---------------> (also lost)
                                                    DATA [TSN] ---------------> (gap detected,immediately send ack)
                                                                                               /----- SACK [TSN Ack=6,Block=1, Start=2,End=5]
                                                                                     <-----/       
                                                                                       ......
                                                  DATA [TSN40] ---------------> (gap detected,immediately send ack)
                                                                                                /----- SACK [TSN Ack=6,Block=1, Start=2,End34]
                                                                                      <-----/       
                       Error happened on Endpoint A when calling SCTP sendmsg to send more to Endpoint B, the error is "Resource temporarily unavailable". Association is not destroyed at this time. 
1 second later RTO Timeout 2nd Re-trans DATA [TSN=7] ---------------> (Acked)


So could you please help to comments on the following question?
-	Does this means that if an gap is found in the SACK, those packages sent after this lost packet will stay in the write buffer until the gap is filled? Even if they are successfully SACKed?

Thanks a lot!

Best Regards!

Mao Jinhui
