# ----------------------------------------------------------------- #
#  CODE FOR PARSING INDIAN LANGUAGES			              #
#           developed by Indian Language Text-to-Speech Consortium  #
# ----------------------------------------------------------------- #
#                                                                   #
#  Copyright (c) 2015  Indian Language Text-to-Speech Consortium    #
#                      Headed by Prof Hema A Murthy, IIT Madras     #
#                      Department of Computer Science & Engineering #
#                      hema@cse.iitm.ac.in                          #
#                                                                   #
#                                 				              #
# All rights reserved.                                              #
#                                                                   #
# Redistribution and use in source and binary forms, with or        #
# without modification, are permitted provided that the following   #
# conditions are met:                                               #
#                                                                   #
# - It can be used for research purpose but for commercial use,     #
#   prior permission is needed.                                     #
# - Redistributions of source code must retain the above copyright  #
#   notice, this list of conditions and the following disclaimer.   #
# - Redistributions in binary form must reproduce the above         #
#   copyright notice, this list of conditions and the following     #
#   disclaimer in the documentation and/or other materials provided #
#   with the distribution.                                          #
# - Neither the name of the Indian Language TTS Consortium nor      #
#   the names of its contributors may be used to endorse or promote #
#   products derived from this software without specific prior      #
#   written permission.					                    #
#                                                                   #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND            #
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,       #
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF          #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          #
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS #
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,          #
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   #
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,     #
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON #
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   #
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    #
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE           #
# POSSIBILITY OF SUCH DAMAGE.                                       #
# ----------------------------------------------------------------- #

# ########################### Author Info ######################### #
#		Name:	Arun Baby
#  		Orgn: IIT Madras
#    		Email: arunbaby0@gmail.com
#		Date:	01-01-2016
#		Desc:	make for unifed parser
# ########################### Author Info END ##################### #

LEX= flex
YACC= bison -d

CC = gcc
FLAGS= -g -lfl  -Wall -w -std=c99

all: unified 

unified.tab.c unified.tab.h: unified.y
	$(YACC) unified.y
	
unifiedlex.yy.c: unified.l unified.tab.h
	$(LEX) -o $@ unified.l

unified: unifiedlex.yy.c unified.tab.c unified.tab.h
	$(CC) $? $(FLAGS) -o $@-parser   

clean: 
	rm *.tab.* *lex.yy.c *-parser 
